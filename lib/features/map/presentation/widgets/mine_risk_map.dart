import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_list_provider.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:go_router/go_router.dart';

class MineRiskMap extends ConsumerWidget {
  final double height;
  const MineRiskMap({super.key, this.height = 300});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minesAsync = ref.watch(mineListProvider);
    final risksAsync = ref.watch(allMinesRiskProvider);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: risksAsync.when(
        data: (risks) => minesAsync.when(
          data: (mines) {
            if (mines.isEmpty) {
              return const Center(child: Text('No mines available for mapping.'));
            }

            return Stack(
              children: [
                // Mock Map Background (Topographic/Satellite style)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: CustomPaint(
                      painter: _MapBackgroundPainter(),
                    ),
                  ),
                ),
                // Interactive Markers
                ...mines.map((mine) {
                  final risk = risks.firstWhere((r) => r.mineId == mine.localId,
                      orElse: () => MineRisk(
                            mineId: mine.localId,
                            score: 0,
                            level: RiskLevel.low,
                            factors: [],
                            updatedAt: DateTime.now(),
                          ));

                  return _MineMapMarker(
                    mineName: mine.name,
                    lat: mine.latitude,
                    lng: mine.longitude,
                    riskLevel: risk.level,
                    onTap: () => context.push('/mines/${mine.localId}'),
                  );
                }),
                // Legend
                Positioned(
                  bottom: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: _MapLegend(),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _MineMapMarker extends StatelessWidget {
  final String mineName;
  final double lat;
  final double lng;
  final RiskLevel riskLevel;
  final VoidCallback onTap;

  const _MineMapMarker({
    required this.mineName,
    required this.lat,
    required this.lng,
    required this.riskLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (riskLevel) {
      case RiskLevel.critical:
        color = Colors.red;
        break;
      case RiskLevel.high:
        color = Colors.orange;
        break;
      case RiskLevel.medium:
        color = Colors.amber;
        break;
      case RiskLevel.low:
        color = Colors.green;
        break;
    }

    // Pseudo-random positioning based on lat/lng within the container
    // In a real app, this would use a projection like Mercator
    final x = (lng + 180) % 100 * 3.0; // Very simple normalization for demo
    final y = (lat + 90) % 100 * 2.5;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                mineName,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 9, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                if (riskLevel == RiskLevel.critical || riskLevel == RiskLevel.high)
                  _BlinkingAura(color: color),
                Icon(Icons.location_on, color: color, size: 28),
                const Icon(Icons.location_on_outlined, color: Colors.white54, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlinkingAura extends StatefulWidget {
  final Color color;
  const _BlinkingAura({required this.color});

  @override
  State<_BlinkingAura> createState() => _BlinkingAuraState();
}

class _BlinkingAuraState extends State<_BlinkingAura> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    
    // Safety check for tests
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color, blurRadius: 10, spreadRadius: 4),
          ],
        ),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          _LegendItem(color: Colors.red, label: 'CRITICAL'),
          const SizedBox(width: 8),
          _LegendItem(color: Colors.orange, label: 'HIGH'),
          const SizedBox(width: 8),
          _LegendItem(color: Colors.amber, label: 'MEDIUM'),
          const SizedBox(width: 8),
          _LegendItem(color: Colors.green, label: 'LOW'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(
          label, 
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.3),
        ),
      ],
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw some random grid lines and "topographic" curves
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(Offset(0, i * size.height / 10), Offset(size.width, i * size.height / 10), paint);
      canvas.drawLine(Offset(i * size.width / 10, 0), Offset(i * size.width / 10, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
