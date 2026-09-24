import 'dart:async';
import 'dart:math';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/domain/repositories/sensor_repository.dart';

class SensorRepositoryImpl implements SensorRepository {
  final Map<String, List<SensorReading>> _currentReadings = {};
  final _controller = StreamController<Map<String, List<SensorReading>>>.broadcast();
  final _random = Random();
  Timer? _timer;

  SensorRepositoryImpl() {
    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _updateReadings();
    });
  }

  void _updateReadings() {
    for (final mineId in _currentReadings.keys) {
      final readings = _currentReadings[mineId]!;
      for (int i = 0; i < readings.length; i++) {
        final r = readings[i];
        // Slight fluctuation
        double newValue = r.value + (_random.nextDouble() - 0.5) * (r.value * 0.05);
        
        // Ensure values stay within reasonable bounds for normal simulation
        if (r.status == SensorStatus.normal) {
          newValue = _clampToNormal(r.type, newValue);
        }

        readings[i] = r.copyWith(
          value: newValue,
          timestamp: DateTime.now(),
        );
      }
    }
    _controller.add(Map.from(_currentReadings));
  }

  double _clampToNormal(SensorType type, double value) {
    switch (type) {
      case SensorType.methane: return value.clamp(0.1, 0.8);
      case SensorType.carbonMonoxide: return value.clamp(5.0, 15.0);
      case SensorType.temperature: return value.clamp(25.0, 32.0);
      case SensorType.humidity: return value.clamp(40.0, 70.0);
      case SensorType.oxygen: return value.clamp(19.5, 20.9);
      case SensorType.dust: return value.clamp(20.0, 50.0);
      case SensorType.vibration: return value.clamp(0.1, 0.3);
    }
  }

  @override
  List<SensorReading> getLiveReadingsForMine(String mineId) {
    if (!_currentReadings.containsKey(mineId)) {
      _currentReadings[mineId] = _generateInitialReadings(mineId);
    }
    return _currentReadings[mineId]!;
  }

  List<SensorReading> _generateInitialReadings(String mineId) {
    return [
      SensorReading(mineId: mineId, type: SensorType.methane, value: 0.2, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.carbonMonoxide, value: 10.0, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.temperature, value: 28.5, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.humidity, value: 60.0, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.oxygen, value: 20.8, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.dust, value: 35.0, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.vibration, value: 0.15, status: SensorStatus.normal, timestamp: DateTime.now()),
    ];
  }

  @override
  void triggerDemoCriticalValues(String mineId) {
    _currentReadings[mineId] = [
      SensorReading(mineId: mineId, type: SensorType.methane, value: 2.5, status: SensorStatus.critical, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.carbonMonoxide, value: 45.0, status: SensorStatus.warning, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.temperature, value: 38.0, status: SensorStatus.warning, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.humidity, value: 65.0, status: SensorStatus.normal, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.oxygen, value: 18.5, status: SensorStatus.critical, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.dust, value: 120.0, status: SensorStatus.critical, timestamp: DateTime.now()),
      SensorReading(mineId: mineId, type: SensorType.vibration, value: 0.85, status: SensorStatus.warning, timestamp: DateTime.now()),
    ];
    _controller.add(Map.from(_currentReadings));
  }

  @override
  void resetToNormalValues(String mineId) {
    _currentReadings[mineId] = _generateInitialReadings(mineId);
    _controller.add(Map.from(_currentReadings));
  }

  @override
  void updateSensorValue(String mineId, SensorType type, double value, SensorStatus status) {
    final readings = _currentReadings[mineId];
    if (readings != null) {
      for (int i = 0; i < readings.length; i++) {
        if (readings[i].type == type) {
          readings[i] = readings[i].copyWith(
            value: value,
            status: status,
            timestamp: DateTime.now(),
          );
          break;
        }
      }
      _controller.add(Map.from(_currentReadings));
    }
  }

  @override
  Stream<Map<String, List<SensorReading>>> watchAllReadings() => _controller.stream;

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
