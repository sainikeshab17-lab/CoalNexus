import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/notifications/data/models/alert_model.dart';
import 'package:coalnexus/features/notifications/domain/repositories/alert_repository.dart';
import 'package:drift/drift.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AppDatabase _db;
  final OutboxService _outboxService;
  final SyncRepository _syncRepository;

  AlertRepositoryImpl(this._db, this._outboxService, this._syncRepository);

  @override
  Future<void> refreshAlerts() async {
    try {
      final response = await _outboxService.apiClient.get('/alerts');
      if (response.isSuccess) {
        final List<dynamic> data = response.data;
        final models = data.map((json) => AlertModel.fromJson(json)).toList();

        await _db.transaction(() async {
          for (final model in models) {
            final hasPending = await _syncRepository.hasPendingMutations(model.localId);
            if (hasPending) continue;

            final query = _db.select(_db.alerts)..where((t) => t.localId.equals(model.localId));
            final existing = await query.getSingleOrNull();

            if (existing == null) {
              await _db.into(_db.alerts).insert(AlertsCompanion.insert(
                localId: model.localId,
                serverId: Value(model.serverId),
                mineId: model.mineId,
                title: model.title,
                message: model.message,
                severity: model.severity,
                createdAt: Value(DateTime.parse(model.createdAt)),
                isRead: Value(model.isRead),
              ));
            } else {
              await (_db.update(_db.alerts)..where((t) => t.localId.equals(model.localId)))
                  .write(AlertsCompanion(
                serverId: Value(model.serverId),
                isRead: Value(model.isRead),
              ));
            }
          }
        });
      }
    } catch (e) {
      print('Failed to refresh alerts: $e');
    }
  }
}
