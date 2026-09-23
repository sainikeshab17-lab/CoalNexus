import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/data/models/mine_model.dart';
import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/data/repositories/mine_repository_impl.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_cached_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_mine_by_id.dart';
import 'package:coalnexus/features/mines/domain/usecases/search_mines.dart';

class FakeMineLocalDataSource implements MineLocalDataSource {
  final Map<String, MineModel> _mines = {};

  @override
  Future<List<MineModel>> getCachedMines() async {
    return _mines.values.toList();
  }

  @override
  Future<MineModel?> getMineById(String id) async {
    return _mines[id];
  }

  @override
  Future<List<MineModel>> searchMines(String query) async {
    return _mines.values
        .where((m) => m.name.contains(query) || m.mineCode.contains(query))
        .toList();
  }

  @override
  Future<void> saveMine(Mine mine) async {
    _mines[mine.localId] = MineModel.fromDomain(mine);
  }

  @override
  Future<void> deleteMine(String id) async {
    _mines.remove(id);
  }

  @override
  Future<void> clearAllMines() async {
    _mines.clear();
  }
}

void main() {
  late FakeMineLocalDataSource localDataSource;
  late MineRepositoryImpl repository;
  final testDate = DateTime(2023, 1, 1);

  final tMine = Mine(
    localId: 'loc123',
    serverId: 'srv123',
    name: 'Dhanbad Coal Mine',
    mineCode: 'DHN001',
    latitude: 23.7957,
    longitude: 86.4304,
    status: MineStatus.active,
    createdAt: testDate,
    updatedAt: testDate,
  );

  setUp(() {
    localDataSource = FakeMineLocalDataSource();
    repository = MineRepositoryImpl(localDataSource);
  });

  group('Mine Repository & Use Cases Data Flow', () {
    test('should save and retrieve cached mines', () async {
      await repository.saveMine(tMine);

      final useCase = GetCachedMines(repository);
      final result = await useCase();

      expect(result, hasLength(1));
      expect(result.first, equals(tMine));
    });

    test('should get mine by ID', () async {
      await repository.saveMine(tMine);

      final useCase = GetMineById(repository);
      final result = await useCase('loc123');

      expect(result, equals(tMine));
    });

    test('should return null when getting mine by non-existent ID', () async {
      final useCase = GetMineById(repository);
      final result = await useCase('non_existent');

      expect(result, isNull);
    });

    test('should search mines matching query', () async {
      await repository.saveMine(tMine);
      await repository.saveMine(Mine(
        localId: 'loc456',
        name: 'Ranchi Mine',
        mineCode: 'RNC002',
        latitude: 23.3441,
        longitude: 85.3096,
        status: MineStatus.inactive,
        createdAt: testDate,
        updatedAt: testDate,
      ));

      final useCase = SearchMines(repository);
      final result = await useCase('Dhanbad');

      expect(result, hasLength(1));
      expect(result.first.name, equals('Dhanbad Coal Mine'));
    });
  });
}
