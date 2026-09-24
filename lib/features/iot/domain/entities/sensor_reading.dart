import 'package:flutter/foundation.dart';

enum SensorStatus {
  normal,
  warning,
  critical;

  String get label => name.toUpperCase();
}

enum SensorType {
  methane('CH4', '%'),
  carbonMonoxide('CO', 'ppm'),
  temperature('Temp', '°C'),
  humidity('Humidity', '%'),
  oxygen('O2', '%'),
  dust('Dust', 'µg/m³'),
  vibration('Vib', 'g');

  final String label;
  final String unit;
  const SensorType(this.label, this.unit);
}

@immutable
class SensorReading {
  final String mineId;
  final SensorType type;
  final double value;
  final SensorStatus status;
  final DateTime timestamp;

  const SensorReading({
    required this.mineId,
    required this.type,
    required this.value,
    required this.status,
    required this.timestamp,
  });

  SensorReading copyWith({
    double? value,
    SensorStatus? status,
    DateTime? timestamp,
  }) {
    return SensorReading(
      mineId: mineId,
      type: type,
      value: value ?? this.value,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
