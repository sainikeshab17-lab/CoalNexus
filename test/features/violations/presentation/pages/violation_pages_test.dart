import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/violations/presentation/pages/create_violation_page.dart';
import 'package:coalnexus/features/violations/presentation/pages/violation_detail_page.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_sync_status_provider.dart';
import 'package:coalnexus/features/violations/domain/usecases/get_violation_by_id.dart';
import 'package:coalnexus/features/violations/domain/usecases/create_violation.dart';
import 'package:coalnexus/features/violations/domain/usecases/update_violation.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<GetViolationById>(),
  MockSpec<CreateViolation>(),
  MockSpec<UpdateViolation>(),
])
import 'violation_pages_test.mocks.dart';

void main() {
  late MockGetViolationById mockGetViolationById;
  late MockCreateViolation mockCreateViolation;

  final now = DateTime.now();
  final testViolation = Violation(
    localId: 'v1',
    inspectionId: 'i1',
    findingId: 'f1',
    mineId: 'm1',
    title: 'Safety Violation',
    description: 'Ventilation issue',
    severity: ViolationSeverity.critical,
    status: ViolationStatus.detected,
    detectedAt: now,
    createdAt: now,
    updatedAt: now,
    localVersion: 1,
  );

  setUp(() {
    mockGetViolationById = MockGetViolationById();
    mockCreateViolation = MockCreateViolation();
  });

  testWidgets('CreateViolationPage validation triggers on empty fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createViolationProvider.overrideWithValue(mockCreateViolation),
        ],
        child: const MaterialApp(
          home: CreateViolationPage(),
        ),
      ),
    );

    final buttonFinder = find.byType(ElevatedButton);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsAtLeastNWidgets(2));
  });

  testWidgets('ViolationDetailPage displays content correctly', (tester) async {
    when(mockGetViolationById.call('v1')).thenAnswer((_) async => testViolation);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getViolationByIdProvider.overrideWithValue(mockGetViolationById),
          violationSyncStatusProvider('v1').overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          home: ViolationDetailPage(violationId: 'v1'),
        ),
      ),
    );

    await tester.pump(); // Start the future
    await tester.pump(); // Handle the future result
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Safety Violation'), findsOneWidget);
    expect(find.text('Ventilation issue'), findsOneWidget);
    expect(find.text('CRITICAL'), findsOneWidget);
  });
}
