import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';

abstract class SensorRepository {
  List<SensorReading> getLiveReadingsForMine(String mineId);
  void triggerDemoCriticalValues(String mineId);
  void resetToNormalValues(String mineId);
  void updateSensorValue(String mineId, SensorType type, double value, SensorStatus status);
  Stream<Map<String, List<SensorReading>>> watchAllReadings();
}
