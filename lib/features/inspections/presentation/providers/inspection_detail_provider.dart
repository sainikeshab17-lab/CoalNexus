import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';

class InspectionDetailState {
  final AsyncValue<Inspection?> inspection;
  final AsyncValue<List<InspectionFinding>> findings;
  final AsyncValue<List<AuditTrail>> auditTrail;

  const InspectionDetailState({
    required this.inspection,
    required this.findings,
    required this.auditTrail,
  });

  InspectionDetailState copyWith({
    AsyncValue<Inspection?>? inspection,
    AsyncValue<List<InspectionFinding>>? findings,
    AsyncValue<List<AuditTrail>>? auditTrail,
  }) {
    return InspectionDetailState(
      inspection: inspection ?? this.inspection,
      findings: findings ?? this.findings,
      auditTrail: auditTrail ?? this.auditTrail,
    );
  }
}

final inspectionDetailProvider = NotifierProvider.family<InspectionDetailNotifier, InspectionDetailState, String>(
  (id) => InspectionDetailNotifier(id),
);

class InspectionDetailNotifier extends Notifier<InspectionDetailState> {
  final String arg;
  InspectionDetailNotifier(this.arg);

  @override
  InspectionDetailState build() {
    _loadData(arg);
    return const InspectionDetailState(
      inspection: AsyncValue.loading(),
      findings: AsyncValue.loading(),
      auditTrail: AsyncValue.loading(),
    );
  }

  Future<void> loadData(String id) async {
    await _loadData(id);
  }

  Future<void> _loadData(String id) async {
    try {
      final getInspectionById = ref.read(getInspectionByIdProvider);
      final getInspectionFindings = ref.read(getInspectionFindingsProvider);
      final auditRepository = ref.read(auditRepositoryProvider);

      final inspection = await getInspectionById(id);
      final findings = await getInspectionFindings(id);
      final auditTrail = await auditRepository.getAuditTrail(id);

      state = state.copyWith(
        inspection: AsyncValue.data(inspection),
        findings: AsyncValue.data(findings),
        auditTrail: AsyncValue.data(auditTrail),
      );
    } catch (e, st) {
      state = state.copyWith(
        inspection: AsyncValue.error(e, st),
        findings: AsyncValue.error(e, st),
        auditTrail: AsyncValue.error(e, st),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      inspection: const AsyncValue.loading(),
      findings: const AsyncValue.loading(),
      auditTrail: const AsyncValue.loading(),
    );
    await _loadData(arg);
  }

  Future<void> updateStatus(InspectionStatus newStatus) async {
    final inspection = state.inspection.value;
    if (inspection == null) return;

    final oldStatus = inspection.status;
    final updated = inspection.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      localVersion: inspection.localVersion + 1,
    );

    try {
      await ref.read(inspectionRepositoryProvider).updateInspection(updated);
      
      // Log audit
      await ref.read(auditRepositoryProvider).logAction(
        entityType: 'Inspection',
        entityId: inspection.localId,
        action: 'STATUS_CHANGE',
        previousState: oldStatus.name,
        newState: newStatus.name,
        comment: 'Status updated via app workflow',
      );

      await refresh();
    } catch (e) {
      // Error handling
    }
  }

  void addLocalFinding(InspectionFinding finding) {
    state.findings.whenData((list) {
      state = state.copyWith(
        findings: AsyncValue.data([...list, finding]),
      );
    });
  }
}
