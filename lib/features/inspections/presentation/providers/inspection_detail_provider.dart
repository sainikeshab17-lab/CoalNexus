import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';

class InspectionDetailState {
  final AsyncValue<Inspection?> inspection;
  final AsyncValue<List<InspectionFinding>> findings;

  const InspectionDetailState({
    required this.inspection,
    required this.findings,
  });

  InspectionDetailState copyWith({
    AsyncValue<Inspection?>? inspection,
    AsyncValue<List<InspectionFinding>>? findings,
  }) {
    return InspectionDetailState(
      inspection: inspection ?? this.inspection,
      findings: findings ?? this.findings,
    );
  }
}

final inspectionDetailProvider = NotifierProvider.family<InspectionDetailNotifier, InspectionDetailState, String>((id) {
  return InspectionDetailNotifier(id);
});

class InspectionDetailNotifier extends Notifier<InspectionDetailState> {
  final String arg;

  InspectionDetailNotifier(this.arg);

  @override
  InspectionDetailState build() {
    _loadData(arg);
    return const InspectionDetailState(
      inspection: AsyncValue.loading(),
      findings: AsyncValue.loading(),
    );
  }

  Future<void> loadData(String id) async {
    await _loadData(id);
  }

  Future<void> _loadData(String id) async {
    try {
      final getInspectionById = ref.read(getInspectionByIdProvider);
      final getInspectionFindings = ref.read(getInspectionFindingsProvider);

      final inspection = await getInspectionById(id);
      final findings = await getInspectionFindings(id);

      state = state.copyWith(
        inspection: AsyncValue.data(inspection),
        findings: AsyncValue.data(findings),
      );
    } catch (e, st) {
      state = state.copyWith(
        inspection: AsyncValue.error(e, st),
        findings: AsyncValue.error(e, st),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      inspection: const AsyncValue.loading(),
      findings: const AsyncValue.loading(),
    );
    await _loadData(arg);
  }

  void addLocalFinding(InspectionFinding finding) {
    state.findings.whenData((list) {
      state = state.copyWith(
        findings: AsyncValue.data([...list, finding]),
      );
    });
  }
}
