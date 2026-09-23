import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/inspections/presentation/pages/create_inspection_page.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_cached_mines.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<GetCachedMines>()])
import 'create_inspection_page_test.mocks.dart';

void main() {
  testWidgets('CreateInspectionPage validation triggers on empty selection', (tester) async {
    final mockGetCachedMines = MockGetCachedMines();
    
    when(mockGetCachedMines.call()).thenAnswer((_) async => [
      Mine(
        localId: 'mine-1',
        name: 'Coal Mine One',
        mineCode: 'CM01',
        latitude: 12.34,
        longitude: 56.78,
        status: MineStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getCachedMinesProvider.overrideWithValue(mockGetCachedMines),
        ],
        child: const MaterialApp(home: CreateInspectionPage()),
      ),
    );

    await tester.pumpAndSettle();

    final buttonFinder = find.text('Start Inspection');
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Please select a mine'), findsOneWidget);
  });
}
