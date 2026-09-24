import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';

class RiskCalculatorService {
  MineRisk calculateMineRisk(
    String mineId,
    List<Violation> violations,
    List<Inspection> inspections,
  ) {
    double score = 0;
    final List<RiskFactor> factors = [];

    // 1. Violation Severity Contribution (Active only)
    final activeViolations = violations.where((v) => 
      v.mineId == mineId && v.status != ViolationStatus.closed
    ).toList();

    double severityScore = 0;
    int criticalCount = 0;
    
    for (final v in activeViolations) {
      switch (v.severity) {
        case ViolationSeverity.critical:
          severityScore += 40;
          criticalCount++;
          break;
        case ViolationSeverity.high:
          severityScore += 25;
          break;
        case ViolationSeverity.medium:
          severityScore += 10;
          break;
        case ViolationSeverity.low:
          severityScore += 5;
          break;
      }
    }
    
    if (severityScore > 0) {
      score += severityScore;
      factors.add(RiskFactor(
        title: 'Active Violations',
        description: '${activeViolations.length} active violations detected, including $criticalCount critical.',
        weight: severityScore,
      ));
    }

    // 2. Recurring Violations Penalty
    final titleCounts = <String, int>{};
    for (final v in activeViolations) {
      titleCounts[v.title] = (titleCounts[v.title] ?? 0) + 1;
    }
    
    double recurringPenalty = 0;
    titleCounts.forEach((title, count) {
      if (count > 1) {
        recurringPenalty += (count - 1) * 15;
      }
    });

    if (recurringPenalty > 0) {
      score += recurringPenalty;
      factors.add(RiskFactor(
        title: 'Recurring Issues',
        description: 'Repeated safety violations of the same type identified.',
        weight: recurringPenalty,
      ));
    }

    // 3. Inspection Frequency
    final mineInspections = inspections.where((i) => i.mineId == mineId).toList();
    if (mineInspections.isEmpty) {
      score += 20;
      factors.add(const RiskFactor(
        title: 'No Recent Inspections',
        description: 'No recorded inspections found for this mine.',
        weight: 20,
      ));
    } else {
      mineInspections.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final lastInspection = mineInspections.first.createdAt;
      final daysSince = DateTime.now().difference(lastInspection).inDays;
      
      if (daysSince > 30) {
        score += 15;
        factors.add(RiskFactor(
          title: 'Delayed Inspection',
          description: 'Last inspection was $daysSince days ago.',
          weight: 15,
        ));
      }
    }

    // Cap score at 100
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
