import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/domain/repositories/sensor_repository.dart';
import 'package:coalnexus/features/iot/data/repositories/sensor_repository_impl.dart';

final sensorRepositoryProvider = Provider<SensorRepository>((ref) {
  final repository = SensorRepositoryImpl();
  ref.onDispose(() => (repository ).dispose());
  return repository;
});

final allSensorsStreamProvider = StreamProvider<Map<String, List<SensorReading>>>((ref) {
  final repository = ref.watch(sensorRepositoryProvider);
  return repository.watchAllReadings();
});

final mineSensorsProvider = Provider.family<List<SensorReading>, String>((ref, mineId) {
  final repository = ref.watch(sensorRepositoryProvider);
  // This initializes readings if they don't exist
  return repository.getLiveReadingsForMine(mineId);
});

final mineSensorsStreamProvider = StreamProvider.family<List<SensorReading>, String>((ref, mineId) {
  final allReadingsAsync = ref.watch(allSensorsStreamProvider);
  return allReadingsAsync.value != null
      ? Stream.value(allReadingsAsync.value![mineId] ?? ref.read(sensorRepositoryProvider).getLiveReadingsForMine(mineId))
      : const Stream.empty();
});
