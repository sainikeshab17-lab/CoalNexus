import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';

class RiskOverviewWidget extends ConsumerWidget {
  const RiskOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRisksAsync = ref.watch(allMinesRiskProvider);
    final overviewAsync = ref.watch(riskOverviewProvider);

    return allRisksAsync.when(
      loading: () => const AppLoadingIndicator(message: 'Calculating Intelligence Risk...'),
      error: (err, stack) => AppErrorView(message: 'Error computing risk: $err'),
      data: (risks) {
        if (risks.isEmpty) {
          return const AppEmptyView(message: 'No mine risk data available.');
        }

        // Calculate average risk score
        final averageScore = risks.map((r) => r.score).reduce((a, b) => a + b) / risks.length;
        final systemLevel = MineRisk.calculateLevel(averageScore);

        // Find highest risk mine for insights
        final highestRiskMine = risks.reduce((a, b) => a.score > b.score ? a : b);

        Color levelColor;
        switch (systemLevel) {
          case RiskLevel.critical:
            levelColor = Colors.red;
            break;
          case RiskLevel.high:
            levelColor = Colors.orange;
            break;
          case RiskLevel.medium:
            levelColor = Colors.amber;
            break;
          case RiskLevel.low:
            levelColor = Colors.green;
            break;
        }

        final overview = overviewAsync.value ?? {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fleet Safety Risk Index',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  averageScore.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: levelColor,
                                      ),
                                ),
                                Text(
                                  ' / 100',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppStatusChip(label: systemLevel.label, color: levelColor),
                          const SizedBox(height: 4),
                          Text(
                            'AI AGGREGATED',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Progress indicator of overall risk
                  LinearProgressIndicator(
                    value: averageScore / 100,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Distribution stats
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDistributionItem(context, 'CRITICAL', overview[RiskLevel.critical] ?? 0, Colors.red),
                        _buildDistributionItem(context, 'HIGH', overview[RiskLevel.high] ?? 0, Colors.orange),
                        _buildDistributionItem(context, 'MEDIUM', overview[RiskLevel.medium] ?? 0, Colors.amber),
                        _buildDistributionItem(context, 'LOW', overview[RiskLevel.low] ?? 0, Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // AI Risk Insights Card
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 20, color: Colors.blue),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'AI Safety Insights',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (highestRiskMine.score > 20) ...[
                    Text(
                      'Primary Risk Drivers (Peak: Mine ID ${highestRiskMine.mineId})',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...highestRiskMine.factors.take(3).map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${f.title}: ${f.description}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ] else
                    _buildInsightRow(context, Icons.check_circle, 'All mines are currently operating within safe regulatory parameters.'),
                  const Divider(height: 24),
                  _buildInsightRow(context, Icons.analytics_outlined, 'Deterministic safety score recalculates instantly on finding edits.'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDistributionItem(BuildContext context, String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildInsightRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
