import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/mines/data/mappers/mine_mapper.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';

void main() {
  final testDate = DateTime(2023, 1, 1);
  
  final tMineEntity = MineEntity(
    localId: 'loc1',
    serverId: 'srv1',
    name: 'Test Mine',
    mineCode: 'M001',
    latitude: 23.5,
    longitude: 85.2,
    status: MineStatus.active,
    createdAt: testDate,
    updatedAt: testDate,
    localVersion: 1,
  );

  final tMineDomain = Mine(
    localId: 'loc1',
    serverId: 'srv1',
    name: 'Test Mine',
    mineCode: 'M001',
    latitude: 23.5,
    longitude: 85.2,
    status: MineStatus.active,
    createdAt: testDate,
    updatedAt: testDate,
  );

  group('MineMapper', () {
    test('should map MineEntity to MineModel/Domain', () {
      final model = MineMapper.fromEntity(tMineEntity);
      final domain = model.toDomain();

      expect(domain, equals(tMineDomain));
      expect(model.localVersion, equals(1));
    });

    test('should map Mine domain to MineEntity', () {
      final entity = MineMapper.toEntity(tMineDomain, localVersion: 2);

      expect(entity.localId, equals(tMineDomain.localId));
      expect(entity.name, equals(tMineDomain.name));
      expect(entity.localVersion, equals(2));
    });
  });
}
