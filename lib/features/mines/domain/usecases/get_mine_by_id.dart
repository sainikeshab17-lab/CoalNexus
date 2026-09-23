import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class GetMineById {
  final MineRepository _repository;

  GetMineById(this._repository);

  Future<Mine?> call(String id) async {
    return await _repository.getMineById(id);
  }
}
