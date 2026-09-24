import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class CreateMine {
  final MineRepository _repository;

  CreateMine(this._repository);

  Future<void> call(Mine mine) async {
    return await _repository.createMine(mine);
  }
}
