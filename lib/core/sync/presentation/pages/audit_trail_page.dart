import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/widgets/audit_timeline.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';

final allAuditTrailsProvider = StreamProvider<List<AuditTrail>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.auditTrails)
        ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
      .watch()
      .map((rows) => rows.map((row) => AuditTrail(
            localId: row.localId,
            serverId: row.serverId,
            entityType: row.entityType,
            entityId: row.entityId,
            action: row.action,
            previousState: row.previousState,
            newState: row.newState,
            actorId: row.actorId,
            timestamp: row.timestamp,
            comment: row.comment,
          )).toList());
});

class AuditTrailPage extends ConsumerWidget {
  const AuditTrailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(allAuditTrailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Audit Trail'),
      ),
      body: auditAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const AppEmptyView(
              message: 'No audit records found.',
              icon: Icons.history_toggle_off,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AuditTimeline(events: events),
          );
        },
        loading: () => const AppLoadingIndicator(),
        error: (e, st) => AppErrorView(message: e.toString()),
      ),
    );
  }
}
