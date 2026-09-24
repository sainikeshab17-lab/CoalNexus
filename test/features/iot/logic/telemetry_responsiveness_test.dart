import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/iot/presentation/widgets/sensor_monitoring_grid.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/presentation/providers/iot_providers.dart';

void main() {
  group('SensorMonitoringGrid Viewport & Logic Tests', () {
    testWidgets('Sensor grid handles small viewports without overflow', (tester) async {
      // Set a very small viewport (iPhone SE style or smaller)
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mineSensorsStreamProvider('test-mine').overrideWith(
              (ref) => Stream.value([
                SensorReading(
                  mineId: 'test-mine',
                  type: SensorType.methane,
                  value: 1.2,
                  status: SensorStatus.normal,
                  timestamp: DateTime.now(),
                ),
                SensorReading(
                  mineId: 'test-mine',
                  type: SensorType.temperature,
                  value: 28.5,
                  status: SensorStatus.warning,
                  timestamp: DateTime.now(),
                ),
                SensorReading(
                  mineId: 'test-mine',
                  type: SensorType.oxygen,
                  value: 19.5,
                  status: SensorStatus.critical,
                  timestamp: DateTime.now(),
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SensorMonitoringGrid(mineId: 'test-mine'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no overflow errors were thrown
      expect(tester.takeException(), isNull);
      
      // Verify labels are present even if small
      expect(find.text('CH4'), findsOneWidget);
      expect(find.text('TEMP'), findsOneWidget);
      expect(find.text('O2'), findsOneWidget);
    });

    testWidgets('Sensor grid shows correct status colors', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mineSensorsStreamProvider('test-mine').overrideWith(
              (ref) => Stream.value([
                SensorReading(
                  mineId: 'test-mine',
                  type: SensorType.methane,
                  value: 5.5,
                  status: SensorStatus.critical,
                  timestamp: DateTime.now(),
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SensorMonitoringGrid(mineId: 'test-mine'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the sensor card container that has the background color
      final sensorTypeLabel = find.text('CH4');
      expect(sensorTypeLabel, findsOneWidget);
      
      final textWidget = tester.widget<Text>(sensorTypeLabel);
      // Status color for critical is red.shade700
      expect(textWidget.style?.color, isNotNull);
      expect(textWidget.style?.color?.value, equals(Colors.red.shade700.withValues(alpha: 0.8).value));
    });
  });
}
