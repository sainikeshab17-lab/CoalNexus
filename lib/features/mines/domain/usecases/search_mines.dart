import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class SearchMines {
  final MineRepository _repository;

  SearchMines(this._repository);

  Future<List<Mine>> call(String query) async {
    return await _repository.searchMines(query);
  }
}
