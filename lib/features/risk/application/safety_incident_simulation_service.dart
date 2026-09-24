import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/domain/repositories/sensor_repository.dart';

enum SimulationStep {
  idle('Ready', 'Initial state: All systems normal.'),
  methaneIncreasing('Telemetry Anomaly', 'Methane levels beginning to rise in Sector 7.'),
  dustWarning('Dust Warning', 'Airborne dust concentration reaching warning thresholds.'),
  vibrationWarning('Vibration Warning', 'Equipment vibration detected above safety limits.'),
  methaneCritical('Methane Critical', 'Methane concentration reached CRITICAL levels.'),
  riskRecalculated('Risk Recalculated', 'Safety Risk Intelligence engine updating mine status.'),
  alertGenerated('Alert Generated', 'System-wide safety alert issued for WCL Umrer.');

  final String title;
  final String description;
  const SimulationStep(this.title, this.description);
}

class SimulationEvent {
  final DateTime timestamp;
  final String message;

  SimulationEvent(this.message) : timestamp = DateTime.now();
}

class SimulationState {
  final SimulationStep currentStep;
  final List<SimulationEvent> timeline;
  final bool isBusy;

  SimulationState({
    this.currentStep = SimulationStep.idle,
    this.timeline = const [],
    this.isBusy = false,
  });

  bool get isActive => currentStep != SimulationStep.idle;

  SimulationState copyWith({
    SimulationStep? currentStep,
    List<SimulationEvent>? timeline,
    bool? isBusy,
  }) {
    return SimulationState(
      currentStep: currentStep ?? this.currentStep,
      timeline: timeline ?? this.timeline,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

class SafetyIncidentSimulationService extends Notifier<SimulationState> {
  late final SensorRepository _sensorRepository;
  
  @override
  SimulationState build() {
    // Note: In a real Notifier, we should watch the provider here
    // but for simplicity in this migration we'll handle it if needed
    // or assume it's injected/available.
    return SimulationState();
  }

  void init(SensorRepository repository) {
    _sensorRepository = repository;
  }

  Future<void> runSimulation(String mineId, SensorRepository repository) async {
    if (state.isBusy) return;
    _sensorRepository = repository;
    state = state.copyWith(isBusy: true, timeline: []);

    try {
      // Step 1: Methane Increasing
      _updateStep(SimulationStep.methaneIncreasing);
      _sensorRepository.updateSensorValue(mineId, SensorType.methane, 1.2, SensorStatus.warning);
      await Future.delayed(const Duration(seconds: 2));

      // Step 2: Dust Warning
      _updateStep(SimulationStep.dustWarning);
      _sensorRepository.updateSensorValue(mineId, SensorType.dust, 85.0, SensorStatus.warning);
      await Future.delayed(const Duration(seconds: 2));

      // Step 3: Vibration Warning
      _updateStep(SimulationStep.vibrationWarning);
      _sensorRepository.updateSensorValue(mineId, SensorType.vibration, 0.55, SensorStatus.warning);
      await Future.delayed(const Duration(seconds: 2));

      // Step 4: Methane Critical
      _updateStep(SimulationStep.methaneCritical);
      _sensorRepository.updateSensorValue(mineId, SensorType.methane, 2.8, SensorStatus.critical);
      await Future.delayed(const Duration(seconds: 2));

      // Step 5 & 6: Risk Recalculated
      _updateStep(SimulationStep.riskRecalculated);
      await Future.delayed(const Duration(seconds: 2));

      // Step 7: Alert Generated
      _updateStep(SimulationStep.alertGenerated);
      
      final updatedTimeline = List<SimulationEvent>.from(state.timeline);
      updatedTimeline.insert(0, SimulationEvent('CRITICAL: Emergency response protocols initiated for WCL Umrer.'));
      updatedTimeline.insert(0, SimulationEvent('Simulation completed. System in High Alert.'));
      state = state.copyWith(timeline: updatedTimeline);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void _updateStep(SimulationStep step) {
    final updatedTimeline = List<SimulationEvent>.from(state.timeline);
    updatedTimeline.insert(0, SimulationEvent(step.description));
    state = state.copyWith(
      currentStep: step,
      timeline: updatedTimeline,
    );
  }

  void resetSimulation(String mineId, SensorRepository repository) {
    _sensorRepository = repository;
    state = SimulationState();
    _sensorRepository.resetToNormalValues(mineId);
    
    // Notify risk providers or clear alerts if necessary? 
    // Usually providers will react to repository changes.
  }
}
