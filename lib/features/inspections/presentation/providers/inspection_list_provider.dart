import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';

final inspectionListProvider = NotifierProvider<InspectionListNotifier, AsyncValue<List<Inspection>>>(InspectionListNotifier.new);

class InspectionListNotifier extends Notifier<AsyncValue<List<Inspection>>> {
  @override
  AsyncValue<List<Inspection>> build() {
    loadInspections();
    return const AsyncValue.loading();
  }

  Future<void> loadInspections() async {
    state = const AsyncValue.loading();
    try {
      final getCachedInspections = ref.read(getCachedInspectionsProvider);
      final inspections = await getCachedInspections();
      state = AsyncValue.data(inspections);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addLocalInspection(Inspection inspection) {
    state.whenData((list) {
      state = AsyncValue.data([inspection, ...list]);
    });
  }
}
