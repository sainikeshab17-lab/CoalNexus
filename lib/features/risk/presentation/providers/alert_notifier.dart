import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/risk/domain/services/alert_generation_service.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';

final alertGenerationServiceProvider = Provider<AlertGenerationService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AlertGenerationService(db);
});

final riskAlertTriggerProvider = Provider<void>((ref) {
  final risksAsync = ref.watch(allMinesRiskProvider);
  final generator = ref.watch(alertGenerationServiceProvider);

  risksAsync.whenData((risks) {
    for (final risk in risks) {
      if (risk.score >= 80) {
        generator.generateRiskAlert(
          mineId: risk.mineId,
          score: risk.score,
          level: risk.level,
          factors: risk.factors,
        );
      }
    }
  });
});
