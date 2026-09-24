import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_list_provider.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';

import 'package:coalnexus/features/risk/domain/services/risk_predictor_service.dart';
import 'package:coalnexus/features/iot/presentation/providers/iot_providers.dart';
import 'package:coalnexus/features/risk/application/safety_incident_simulation_service.dart';

final riskPredictorServiceProvider = Provider<RiskPredictionService>((ref) {
  return RiskPredictionService();
});

final safetySimulationProvider = NotifierProvider<SafetyIncidentSimulationService, SimulationState>(SafetyIncidentSimulationService.new);

final allMinesRiskProvider = Provider<AsyncValue<List<MineRisk>>>((ref) {
  final minesAsync = ref.watch(mineListProvider);
  final inspectionsAsync = ref.watch(inspectionListProvider);
  final violationsAsync = ref.watch(violationListProvider);
  final sensorsMapAsync = ref.watch(allSensorsStreamProvider);
  final predictor = ref.watch(riskPredictorServiceProvider);

  return minesAsync.when(
    data: (mines) => inspectionsAsync.when(
      data: (inspections) => violationsAsync.when(
        data: (violations) => sensorsMapAsync.when(
          data: (sensorsMap) {
            final risks = mines.map((mine) {
              final sensors = sensorsMap[mine.localId] ?? [];
              return predictor.predictMineRisk(
                mine.localId,
                violations,
                inspections,
                sensors,
              );
            }).toList();
            return AsyncValue.data(risks);
          },
          loading: () => const AsyncValue.loading(),
          error: (e, st) => AsyncValue.error(e, st),
        ),
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      ),
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final mineRiskProvider = Provider.family<AsyncValue<MineRisk>, String>((ref, mineId) {
  final allRisksAsync = ref.watch(allMinesRiskProvider);
  return allRisksAsync.whenData((risks) => risks.firstWhere((r) => r.mineId == mineId));
});

final riskOverviewProvider = Provider<AsyncValue<Map<RiskLevel, int>>>((ref) {
  final allRisksAsync = ref.watch(allMinesRiskProvider);
  return allRisksAsync.whenData((risks) {
    final overview = <RiskLevel, int>{
      RiskLevel.low: 0,
      RiskLevel.medium: 0,
      RiskLevel.high: 0,
      RiskLevel.critical: 0,
    };
    for (final risk in risks) {
      overview[risk.level] = (overview[risk.level] ?? 0) + 1;
    }
    return overview;
  });
});
