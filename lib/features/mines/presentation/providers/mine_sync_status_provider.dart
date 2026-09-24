import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';

final mineSyncStatusProvider = StreamProvider.family<SyncStatus?, String>((ref, localId) {
  final db = ref.watch(appDatabaseProvider);
  
  return (db.select(db.syncQueue)..where((t) => t.localId.equals(localId)))
      .watchSingleOrNull()
      .map((row) => row?.syncStatus);
});
