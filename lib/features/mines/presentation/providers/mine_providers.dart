import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/data/repositories/mine_repository_impl.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_cached_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_mine_by_id.dart';
import 'package:coalnexus/features/mines/domain/usecases/search_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/refresh_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/create_mine.dart';
import 'package:coalnexus/features/mines/domain/usecases/update_mine.dart';
import 'package:coalnexus/features/notifications/data/repositories/alert_repository_impl.dart';
import 'package:coalnexus/features/notifications/domain/repositories/alert_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final mineLocalDataSourceProvider = Provider<MineLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MineLocalDataSourceImpl(db);
});

final mineRepositoryProvider = Provider<MineRepository>((ref) {
  final localDataSource = ref.watch(mineLocalDataSourceProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  return MineRepositoryImpl(localDataSource, outboxService, syncRepository);
});

final getCachedMinesProvider = Provider<GetCachedMines>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return GetCachedMines(repository);
});

final getMineByIdProvider = Provider<GetMineById>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return GetMineById(repository);
});

final searchMinesProvider = Provider<SearchMines>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return SearchMines(repository);
});

final refreshMinesProvider = Provider<RefreshMines>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return RefreshMines(repository);
});

final createMineProvider = Provider<CreateMine>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return CreateMine(repository);
});

final updateMineProvider = Provider<UpdateMine>((ref) {
  final repository = ref.watch(mineRepositoryProvider);
  return UpdateMine(repository);
});

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final outbox = ref.watch(outboxServiceProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  return AlertRepositoryImpl(db, outbox, syncRepository);
});

final alertsStreamProvider = StreamProvider<List<AlertEntity>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.alerts).watch();
});

final criticalAlertsStreamProvider = StreamProvider<List<AlertEntity>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.alerts)..where((t) => t.severity.equals('CRITICAL'))).watch();
});
