import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/inspections/presentation/pages/inspection_list_page.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_sync_status_provider.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';

void main() {
  testWidgets('InspectionListPage shows empty view when no inspections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionListProvider.overrideWith(() => MockInspectionListNotifier(const AsyncValue.data([]))),
          inspectionSyncStatusProvider.overrideWith((ref, id) => Stream.value(null)),
        ],
        child: const MaterialApp(home: InspectionListPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('No inspections found. Start by creating a new one.'), findsOneWidget);
  });

  testWidgets('InspectionListPage shows list of inspections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionListProvider.overrideWith(() => MockInspectionListNotifier(AsyncValue.data([
            Inspection(
              localId: '1',
              mineId: 'mine1',
              inspectorId: 'user1',
              status: InspectionStatus.draft,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          ]))),
          inspectionSyncStatusProvider.overrideWith((ref, id) => Stream.value(null)),
        ],
        child: const MaterialApp(home: InspectionListPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(InspectionCard), findsOneWidget);
  });
}

class MockInspectionListNotifier extends InspectionListNotifier {
  final AsyncValue<List<Inspection>> _initialState;

  MockInspectionListNotifier(this._initialState);

  @override
  AsyncValue<List<Inspection>> build() {
    return _initialState;
  }

  @override
  Future<void> loadInspections() async {}
}
