import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';

final violationListProvider = NotifierProvider<ViolationListNotifier, AsyncValue<List<Violation>>>(ViolationListNotifier.new);

class ViolationListNotifier extends Notifier<AsyncValue<List<Violation>>> {
  String _query = '';

  @override
  AsyncValue<List<Violation>> build() {
    loadViolations();
    return const AsyncValue.loading();
  }

  Future<void> loadViolations() async {
    state = const AsyncValue.loading();
    try {
      final violations = _query.isEmpty
          ? await ref.read(getCachedViolationsProvider)()
          : await ref.read(searchViolationsProvider)(_query);
      state = AsyncValue.data(violations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _query = query.trim();
    loadViolations();
  }

  void addLocalViolation(Violation violation) {
    state.whenData((list) {
      state = AsyncValue.data([violation, ...list]);
    });
  }

  void updateLocalViolation(Violation violation) {
    state.whenData((list) {
      state = AsyncValue.data(
        list.map((v) => v.localId == violation.localId ? violation : v).toList(),
      );
    });
  }
}
