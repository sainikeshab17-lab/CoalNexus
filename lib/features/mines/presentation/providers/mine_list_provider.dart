import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';

final mineListProvider = NotifierProvider<MineListNotifier, AsyncValue<List<Mine>>>(MineListNotifier.new);

class MineListNotifier extends Notifier<AsyncValue<List<Mine>>> {
  String _query = '';

  @override
  AsyncValue<List<Mine>> build() {
    loadMines();
    return const AsyncValue.loading();
  }

  Future<void> loadMines() async {
    state = const AsyncValue.loading();
    try {
      final mines = _query.isEmpty
          ? await ref.read(getCachedMinesProvider)()
          : await ref.read(searchMinesProvider)(_query);
      state = AsyncValue.data(mines);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _query = query.trim();
    loadMines();
  }

  void addLocalMine(Mine mine) {
    state.whenData((list) {
      state = AsyncValue.data([mine, ...list]);
    });
  }

  void updateLocalMine(Mine mine) {
    state.whenData((list) {
      state = AsyncValue.data(
        list.map((m) => m.localId == mine.localId ? mine : m).toList(),
      );
    });
  }
}
