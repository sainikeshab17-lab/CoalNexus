import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class GetCachedMines {
  final MineRepository _repository;

  GetCachedMines(this._repository);

  Future<List<Mine>> call() async {
    return await _repository.getCachedMines();
  }
}
