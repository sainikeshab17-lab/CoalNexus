import 'package:coalnexus/features/mines/domain/entities/mine.dart';

abstract class MineRepository {
  Future<List<Mine>> getCachedMines();
  Future<Mine?> getMineById(String id);
  Future<List<Mine>> searchMines(String query);
  Future<void> refreshMines();
  Future<void> createMine(Mine mine);
  Future<void> updateMine(Mine mine);
  Future<void> deleteMine(String id);
}
