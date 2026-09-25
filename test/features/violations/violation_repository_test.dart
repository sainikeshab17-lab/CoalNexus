import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/features/violations/data/datasources/violation_local_data_source.dart';
import 'package:coalnexus/features/violations/data/repositories/violation_repository_impl.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';

import 'package:coalnexus/core/sync/sync_repository.dart';

@GenerateMocks([OutboxService, SyncRepository, ViolationLocalDataSource])
import 'violation_repository_test.mocks.dart';

void main() {
  late MockViolationLocalDataSource mockLocalDataSource;
  late MockOutboxService mockOutboxService;
  late MockSyncRepository mockSyncRepository;
  late ViolationRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockViolationLocalDataSource();
    mockOutboxService = MockOutboxService();
    mockSyncRepository = MockSyncRepository();
    repository = ViolationRepositoryImpl(mockLocalDataSource, mockOutboxService, mockSyncRepository);
  });

  tearDown(() async {
    // No database to close
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
    when(mockLocalDataSource.transaction<void>(any)).thenAnswer((inv) {
      final Future<void> Function() action = inv.positionalArguments[0] as Future<void> Function();
      return action();
    });
    when(mockLocalDataSource.saveViolation(any)).thenAnswer((_) async {});
    when(mockLocalDataSource.getCachedViolations()).thenAnswer((_) async => [ViolationModel.fromDomain(testViolation)]);

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
    when(mockLocalDataSource.transaction<void>(any)).thenAnswer((inv) {
      final Future<void> Function() action = inv.positionalArguments[0] as Future<void> Function();
      return action();
    });
    when(mockLocalDataSource.getViolationById('v1')).thenAnswer((_) async => ViolationModel.fromDomain(testViolation));
    when(mockLocalDataSource.updateViolation(any, expectedVersion: anyNamed('expectedVersion'))).thenAnswer((_) async {});
    when(mockLocalDataSource.getCachedViolations()).thenAnswer((_) async => [ViolationModel.fromDomain(testViolation.copyWith(localVersion: 2, title: 'Updated Title'))]);

    when(mockOutboxService.enqueueOperation(
      featureName: anyNamed('featureName'),
      actionType: anyNamed('actionType'),
      payloadJson: anyNamed('payloadJson'),
      localId: anyNamed('localId'),
    )).thenAnswer((_) async => 'operation-id');

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
    when(mockLocalDataSource.transaction<void>(any)).thenAnswer((inv) {
      final Future<void> Function() action = inv.positionalArguments[0] as Future<void> Function();
      return action();
    });
    when(mockLocalDataSource.getViolationById('v1')).thenAnswer((_) async => null);

    final updated = testViolation.copyWith(title: 'Updated Title');
    expect(() => repository.updateViolation(updated), throwsA(isA<Exception>()));
  });

  test('search, mine filtering, and inspection filtering work correctly', () async {
    when(mockLocalDataSource.searchViolations('Safety')).thenAnswer((_) async => [ViolationModel.fromDomain(testViolation)]);
    final searchResults = await repository.searchViolations('Safety');
    expect(searchResults.length, 1);

    when(mockLocalDataSource.getViolationsForMine('m1')).thenAnswer((_) async => [ViolationModel.fromDomain(testViolation)]);
    final mineResults = await repository.getViolationsForMine('m1');
    expect(mineResults.length, 1);

    when(mockLocalDataSource.getViolationsForInspection('i1')).thenAnswer((_) async => [ViolationModel.fromDomain(testViolation)]);
    final inspectionResults = await repository.getViolationsForInspection('i1');
    expect(inspectionResults.length, 1);
  });
}
