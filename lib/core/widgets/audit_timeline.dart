import 'package:flutter/material.dart';
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class AuditTimeline extends StatelessWidget {
  final List<AuditTrail> events;
  final bool shrinkWrap;

  const AuditTimeline({
    super.key,
    required this.events,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('No audit history available.'));
    }

    final sortedEvents = List<AuditTrail>.from(events)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isLast = index == sortedEvents.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.action.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            DateFormat('MMM dd, HH:mm').format(event.timestamp),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'By: ${event.actorId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (event.previousState != null || event.newState.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            '${event.previousState ?? "N/A"} → ${event.newState}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                      if (event.comment != null && event.comment!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.comment!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
