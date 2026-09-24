import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:drift/native.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/features/violations/data/datasources/violation_local_data_source.dart';
import 'package:coalnexus/features/violations/data/repositories/violation_repository_impl.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';

@GenerateMocks([OutboxService])
import 'violation_repository_test.mocks.dart';

void main() {
  late AppDatabase database;
  late ViolationLocalDataSource localDataSource;
  late MockOutboxService mockOutboxService;
  late ViolationRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    localDataSource = ViolationLocalDataSourceImpl(database);
    mockOutboxService = MockOutboxService();
    repository = ViolationRepositoryImpl(localDataSource, mockOutboxService);
  });

  tearDown(() async {
    await database.close();
  });

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

  test('createViolation should save locally and enqueue to outbox', () async {
    when(mockOutboxService.enqueueOperation(
      featureName: anyNamed('featureName'),
      actionType: anyNamed('actionType'),
      payloadJson: anyNamed('payloadJson'),
      localId: anyNamed('localId'),
    )).thenAnswer((_) async => 'operation-id');

    await repository.createViolation(testViolation);

    final cached = await repository.getCachedViolations();
    expect(cached.length, 1);
    expect(cached.first.localId, 'v1');

    verify(mockOutboxService.enqueueOperation(
      featureName: 'violations',
      actionType: 'CREATE_VIOLATION',
      payloadJson: anyNamed('payloadJson'),
      localId: 'v1',
    )).called(1);
  });

  test('updateViolation should increment localVersion and enqueue to outbox', () async {
    when(mockOutboxService.enqueueOperation(
      featureName: anyNamed('featureName'),
      actionType: anyNamed('actionType'),
      payloadJson: anyNamed('payloadJson'),
      localId: anyNamed('localId'),
    )).thenAnswer((_) async => 'operation-id');

    await repository.createViolation(testViolation);

    final updated = testViolation.copyWith(title: 'Updated Title');
    await repository.updateViolation(updated);

    final cached = await repository.getCachedViolations();
    expect(cached.first.title, 'Updated Title');
    expect(cached.first.localVersion, 2);

    verify(mockOutboxService.enqueueOperation(
      featureName: 'violations',
      actionType: 'UPDATE_VIOLATION',
      payloadJson: anyNamed('payloadJson'),
      localId: 'v1',
    )).called(1);
  });

  test('updateViolation should throw conflict error if version mismatch or not found', () async {
    final updated = testViolation.copyWith(title: 'Updated Title');
    expect(() => repository.updateViolation(updated), throwsA(isA<Exception>()));
  });

  test('search, mine filtering, and inspection filtering work correctly', () async {
    when(mockOutboxService.enqueueOperation(
      featureName: anyNamed('featureName'),
      actionType: anyNamed('actionType'),
      payloadJson: anyNamed('payloadJson'),
      localId: anyNamed('localId'),
    )).thenAnswer((_) async => 'operation-id');

    await repository.createViolation(testViolation);

    final searchResults = await repository.searchViolations('Safety');
    expect(searchResults.length, 1);

    final mineResults = await repository.getViolationsForMine('m1');
    expect(mineResults.length, 1);

    final inspectionResults = await repository.getViolationsForInspection('i1');
    expect(inspectionResults.length, 1);
  });
}
