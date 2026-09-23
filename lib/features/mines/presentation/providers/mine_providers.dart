import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/data/repositories/mine_repository_impl.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_cached_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_mine_by_id.dart';
import 'package:coalnexus/features/mines/domain/usecases/search_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/refresh_mines.dart';

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
  return MineRepositoryImpl(localDataSource);
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
