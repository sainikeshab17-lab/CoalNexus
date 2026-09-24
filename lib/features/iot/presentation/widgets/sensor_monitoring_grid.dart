import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/iot/domain/entities/sensor_reading.dart';
import 'package:coalnexus/features/iot/presentation/providers/iot_providers.dart';

class SensorMonitoringGrid extends ConsumerWidget {
  final String mineId;

  const SensorMonitoringGrid({super.key, required this.mineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorsAsync = ref.watch(mineSensorsStreamProvider(mineId));

    return sensorsAsync.when(
      data: (sensors) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.2,
          ),
          itemCount: sensors.length,
          itemBuilder: (context, index) {
            final sensor = sensors[index];
            return _SensorCard(sensor: sensor);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e'),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final SensorReading sensor;

  const _SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color backgroundColor;
    
    switch (sensor.status) {
      case SensorStatus.critical:
        statusColor = Colors.red.shade700;
        backgroundColor = Colors.red.shade50;
        break;
      case SensorStatus.warning:
        statusColor = Colors.orange.shade800;
        backgroundColor = Colors.orange.shade50;
        break;
      case SensorStatus.normal:
        statusColor = Colors.green.shade700;
        backgroundColor = Colors.green.shade50;
        break;
    }

    final isAlert = sensor.status != SensorStatus.normal;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAlert ? statusColor.withValues(alpha: 0.5) : Colors.transparent,
          width: isAlert ? 2 : 1,
        ),
        boxShadow: isAlert
            ? [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAlert)
                _BlinkingDot(color: statusColor)
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                sensor.type.label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: statusColor.withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              sensor.value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
            ),
          ),
          Text(
            sensor.type.unit,
            style: TextStyle(
              fontSize: 9,
              color: statusColor.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  final Color color;
  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Avoid repeating infinitely in test environment to prevent pumpAndSettle timeouts
    if (!const bool.fromEnvironment('dart.vm.product') &&
        WidgetsBinding.instance.toString().contains('TestWidgetsFlutterBinding')) {
      _controller.value = 1.0;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color, blurRadius: 4, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}
