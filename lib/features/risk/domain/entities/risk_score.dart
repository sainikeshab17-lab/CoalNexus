import 'package:flutter/foundation.dart';

enum RiskLevel {
  low,
  medium,
  high,
  critical;

  String get label => name.toUpperCase();
}

@immutable
class RiskFactor {
  final String title;
  final String description;
  final double weight;

  const RiskFactor({
    required this.title,
    required this.description,
    required this.weight,
  });
}

@immutable
class MineRisk {
  final String mineId;
  final double score;
  final RiskLevel level;
  final List<RiskFactor> factors;
  final DateTime updatedAt;

  const MineRisk({
    required this.mineId,
    required this.score,
    required this.level,
    required this.factors,
    required this.updatedAt,
  });

  static RiskLevel calculateLevel(double score) {
    if (score >= 80) return RiskLevel.critical;
    if (score >= 50) return RiskLevel.high;
    if (score >= 20) return RiskLevel.medium;
    return RiskLevel.low;
  }
}
