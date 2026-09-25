import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';
import 'package:coalnexus/core/sync/domain/repositories/audit_repository.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/sync_models.dart';

class AuditRepositoryImpl implements AuditRepository {
  final AppDatabase _database;
  final SyncRepository _syncRepository;
  final String _currentUserId = 'u1'; // In real app, get from auth provider

  AuditRepositoryImpl(this._database, this._syncRepository);

  @override
  Future<void> logAction({
    required String entityType,
    required String entityId,
    required String action,
    String? previousState,
    required String newState,
    String? comment,
  }) async {
    final localId = const Uuid().v4();
    final timestamp = DateTime.now();

    final companion = AuditTrailsCompanion.insert(
      localId: localId,
      entityType: entityType,
      entityId: entityId,
      action: action,
      previousState: Value(previousState),
      newState: newState,
      actorId: _currentUserId,
      timestamp: Value(timestamp),
      comment: Value(comment),
    );

    await _database.into(_database.auditTrails).insert(companion);

    // Enqueue for sync
    final syncItem = SyncQueueItem(
      localId: localId,
      featureName: 'AuditTrail',
      actionType: 'CREATE',
      payloadJson: jsonEncode({
        'localId': localId,
        'entityType': entityType,
        'entityId': entityId,
        'action': action,
        'previousState': previousState,
        'newState': newState,
        'actorId': _currentUserId,
        'timestamp': timestamp.toIso8601String(),
        'comment': comment,
      }),
      syncStatus: SyncStatus.pending,
      retryCount: 0,
      localVersion: 1,
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    await _syncRepository.enqueue(syncItem);
  }

  @override
  Future<List<AuditTrail>> getAuditTrail(String entityId) async {
    final query = _database.select(_database.auditTrails)
      ..where((t) => t.entityId.equals(entityId))
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]);
    
    final rows = await query.get();
    return rows.map((row) => AuditTrail(
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
    )).toList();
  }
}
