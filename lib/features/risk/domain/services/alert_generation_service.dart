import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class AlertGenerationService {
  final AppDatabase db;
  final _uuid = const Uuid();

  AlertGenerationService(this.db);

  Future<void> generateRiskAlert({
    required String mineId,
    required double score,
    required RiskLevel level,
    required List<RiskFactor> factors,
  }) async {
    // Check if a similar unread critical alert already exists for this mine to avoid spam
    if (level == RiskLevel.critical) {
      final existingAlerts = await (db.select(db.alerts)
            ..where((t) => t.mineId.equals(mineId))
            ..where((t) => t.isRead.equals(false))
            ..where((t) => t.severity.equals('CRITICAL')))
          .get();

      if (existingAlerts.isNotEmpty) return;
    }

    final factorSummary = factors.take(2).map((f) => f.title).join(' + ');
    
    await db.into(db.alerts).insert(AlertsCompanion.insert(
      localId: _uuid.v4(),
      mineId: mineId,
      title: '${level.label} RISK DETECTED',
      message: 'Risk score reached ${score.toInt()}. Contributing factors: $factorSummary.',
      severity: level.label,
      createdAt: Value(DateTime.now()),
    ));
  }
}
