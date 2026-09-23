import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class RefreshMines {
  final MineRepository _repository;

  RefreshMines(this._repository);

  Future<void> call() async {
    return await _repository.refreshMines();
  }
}
