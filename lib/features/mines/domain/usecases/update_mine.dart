import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class UpdateMine {
  final MineRepository _repository;

  UpdateMine(this._repository);

  Future<void> call(Mine mine) async {
    return await _repository.updateMine(mine);
  }
}
