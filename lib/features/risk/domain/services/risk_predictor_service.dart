import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';

class RiskPredictionService {
  MineRisk predictMineRisk(
    String mineId,
    List<Violation> violations,
    List<Inspection> inspections,
    List<SensorReading> sensors,
  ) {
    double score = 0;
    final List<RiskFactor> factors = [];

    // 1. IoT Sensor Abnormalities Contribution
    double sensorScore = 0;
    int criticalSensors = 0;
    int warningSensors = 0;

    for (final s in sensors) {
      if (s.status == SensorStatus.critical) {
        sensorScore += 30;
        criticalSensors++;
      } else if (s.status == SensorStatus.warning) {
        sensorScore += 15;
        warningSensors++;
      }
    }

    if (sensorScore > 0) {
      score += sensorScore;
      factors.add(RiskFactor(
        title: 'IoT Sensor Anomalies',
        description: 'Detected $criticalSensors critical and $warningSensors warning sensor states (e.g. Methane/Dust).',
        weight: sensorScore,
      ));
    }

    // 2. Violation Severity Contribution (Active only)
    final activeViolations = violations.where((v) => 
      v.mineId == mineId && v.status != ViolationStatus.closed
    ).toList();

    double severityScore = 0;
    int criticalViolations = 0;
    
    for (final v in activeViolations) {
      switch (v.severity) {
        case ViolationSeverity.critical:
          severityScore += 25;
          criticalViolations++;
          break;
        case ViolationSeverity.high:
          severityScore += 15;
          break;
        case ViolationSeverity.medium:
          severityScore += 8;
          break;
        case ViolationSeverity.low:
          severityScore += 3;
          break;
      }
    }
    
    if (severityScore > 0) {
      score += severityScore;
      factors.add(RiskFactor(
        title: 'Active Violations',
        description: '${activeViolations.length} active regulatory violations, including $criticalViolations critical.',
        weight: severityScore,
      ));
    }

    // 3. Recurring Violations Penalty
    final titleCounts = <String, int>{};
    for (final v in activeViolations) {
      titleCounts[v.title] = (titleCounts[v.title] ?? 0) + 1;
    }
    
    double recurringPenalty = 0;
    titleCounts.forEach((title, count) {
      if (count > 1) {
        recurringPenalty += (count - 1) * 10;
      }
    });

    if (recurringPenalty > 0) {
      score += recurringPenalty;
      factors.add(RiskFactor(
        title: 'Recurring Safety Issues',
        description: 'Repeated non-compliance patterns found across inspections.',
        weight: recurringPenalty,
      ));
    }

    // 4. Inspection Recency Check
    final mineInspections = inspections.where((i) => i.mineId == mineId).toList();
    if (mineInspections.isEmpty) {
      score += 15;
      factors.add(const RiskFactor(
        title: 'Missing Safety Audits',
        description: 'No initial compliance inspection records found.',
        weight: 15,
      ));
    } else {
      mineInspections.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final lastInspection = mineInspections.first.createdAt;
      final daysSince = DateTime.now().difference(lastInspection).inDays;
      
      if (daysSince > 30) {
        score += 10;
        factors.add(RiskFactor(
          title: 'Delayed Inspection Audit',
          description: 'Last physical site audit was performed $daysSince days ago.',
          weight: 10,
        ));
      }
    }

    final finalScore = score.clamp(0.0, 100.0);
    
    return MineRisk(
      mineId: mineId,
      score: finalScore,
      level: MineRisk.calculateLevel(finalScore),
      factors: factors,
      updatedAt: DateTime.now(),
    );
  }
}
