import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/domain/repositories/sensor_repository.dart';
import 'package:coalnexus/features/risk/application/safety_incident_simulation_service.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';

class MockSensorRepository implements SensorRepository {
  final List<Map<String, dynamic>> calls = [];
  bool resetCalled = false;

  @override
  List<SensorReading> getLiveReadingsForMine(String mineId) => [];

  @override
  void triggerDemoCriticalValues(String mineId) {}

  @override
  void resetToNormalValues(String mineId) {
    resetCalled = true;
  }

  @override
  void updateSensorValue(String mineId, SensorType type, double value, SensorStatus status) {
    calls.add({
      'mineId': mineId,
      'type': type,
      'value': value,
      'status': status,
    });
  }

  @override
  Stream<Map<String, List<SensorReading>>> watchAllReadings() => const Stream.empty();
}

void main() {
  late MockSensorRepository mockRepository;
  late SafetyIncidentSimulationService service;
  late ProviderContainer container;
  const mineId = 'seed_m1';

  setUp(() {
    mockRepository = MockSensorRepository();
    container = ProviderContainer(
      overrides: [
        safetySimulationProvider.overrideWith(SafetyIncidentSimulationService.new),
      ],
    );
    service = container.read(safetySimulationProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('SafetyIncidentSimulationService', () {
    test('initial state is idle', () {
      final state = container.read(safetySimulationProvider);
      expect(state.currentStep, SimulationStep.idle);
      expect(state.timeline, isEmpty);
      expect(state.isBusy, isFalse);
      expect(state.isActive, isFalse);
    });

    test('runSimulation executes all steps and updates repository', () async {
      final simulationFuture = service.runSimulation(mineId, mockRepository);
      
      expect(container.read(safetySimulationProvider).isBusy, isTrue);
      
      await simulationFuture;

      final state = container.read(safetySimulationProvider);
      expect(state.currentStep, SimulationStep.alertGenerated);
      expect(state.timeline, isNotEmpty);
      expect(state.timeline.any((e) => e.message.contains('completed')), isTrue);
      expect(state.isBusy, isFalse);

      // Verify repository calls
      expect(mockRepository.calls.length, equals(4));
      
      // Methane Increasing
      expect(mockRepository.calls[0]['type'], SensorType.methane);
      expect(mockRepository.calls[0]['status'], SensorStatus.warning);
      
      // Dust Warning
      expect(mockRepository.calls[1]['type'], SensorType.dust);
      expect(mockRepository.calls[1]['status'], SensorStatus.warning);
      
      // Vibration Warning
      expect(mockRepository.calls[2]['type'], SensorType.vibration);
      expect(mockRepository.calls[2]['status'], SensorStatus.warning);
      
      // Methane Critical
      expect(mockRepository.calls[3]['type'], SensorType.methane);
      expect(mockRepository.calls[3]['status'], SensorStatus.critical);
    });

    test('resetSimulation clears state and calls repository reset', () {
      service.resetSimulation(mineId, mockRepository);

      final state = container.read(safetySimulationProvider);
      expect(state.currentStep, SimulationStep.idle);
      expect(state.timeline, isEmpty);
      expect(mockRepository.resetCalled, isTrue);
    });

    test('multiple runSimulation calls are ignored while busy', () async {
      final firstRun = service.runSimulation(mineId, mockRepository);
      final secondRun = service.runSimulation(mineId, mockRepository);

      await firstRun;
      await secondRun;

      // Repository should only have calls from one simulation run
      expect(mockRepository.calls.length, equals(4));
    });
  });
}
