import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/violations/data/mappers/violation_mapper.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';

void main() {
  group('ViolationMapper', () {
    final now = DateTime.now();
    final violation = Violation(
      localId: 'v1',
      serverId: 's1',
      inspectionId: 'i1',
      findingId: 'f1',
      mineId: 'm1',
      title: 'Title',
      description: 'Desc',
      severity: ViolationSeverity.high,
      status: ViolationStatus.recorded,
      assignedTo: 'user1',
      dueDate: now.add(const Duration(days: 7)),
      detectedAt: now,
      createdAt: now,
      updatedAt: now,
      localVersion: 1,
    );

    test('toEntity should map Violation to ViolationEntity', () {
      final entity = ViolationMapper.toEntity(violation);

      expect(entity.localId, violation.localId);
      expect(entity.serverId, violation.serverId);
      expect(entity.inspectionId, violation.inspectionId);
      expect(entity.findingId, violation.findingId);
      expect(entity.mineId, violation.mineId);
      expect(entity.title, violation.title);
      expect(entity.description, violation.description);
      expect(entity.severity, violation.severity);
      expect(entity.status, violation.status);
      expect(entity.assignedTo, violation.assignedTo);
      expect(entity.dueDate, violation.dueDate);
      expect(entity.detectedAt, violation.detectedAt);
      expect(entity.createdAt, violation.createdAt);
      expect(entity.updatedAt, violation.updatedAt);
      expect(entity.localVersion, violation.localVersion);
    });

    test('fromEntity should map ViolationEntity to ViolationModel', () {
      final entity = ViolationEntity(
        localId: 'v1',
        serverId: 's1',
        inspectionId: 'i1',
        findingId: 'f1',
        mineId: 'm1',
        title: 'Title',
        description: 'Desc',
        severity: ViolationSeverity.high,
        status: ViolationStatus.recorded,
        assignedTo: 'user1',
        dueDate: now.add(const Duration(days: 7)),
        detectedAt: now,
        createdAt: now,
        updatedAt: now,
        localVersion: 1,
      );

      final model = ViolationMapper.fromEntity(entity);

      expect(model.localId, entity.localId);
      expect(model.serverId, entity.serverId);
      expect(model.inspectionId, entity.inspectionId);
      expect(model.findingId, entity.findingId);
      expect(model.mineId, entity.mineId);
      expect(model.title, entity.title);
      expect(model.description, entity.description);
      expect(model.severity, entity.severity);
      expect(model.status, entity.status);
      expect(model.assignedTo, entity.assignedTo);
      expect(model.dueDate, entity.dueDate);
      expect(model.detectedAt, entity.detectedAt);
      expect(model.createdAt, entity.createdAt);
      expect(model.updatedAt, entity.updatedAt);
      expect(model.localVersion, entity.localVersion);
    });
  });

  group('ViolationModel', () {
    final now = DateTime.now();
    final model = ViolationModel(
      localId: 'v1',
      serverId: 's1',
      inspectionId: 'i1',
      findingId: 'f1',
      mineId: 'm1',
      title: 'Title',
      description: 'Desc',
      severity: ViolationSeverity.high,
      status: ViolationStatus.recorded,
      assignedTo: 'user1',
      dueDate: now.add(const Duration(days: 7)),
      detectedAt: now,
      createdAt: now,
      updatedAt: now,
      localVersion: 1,
    );

    test('toJson should return valid map', () {
      final json = model.toJson();
      expect(json['localId'], 'v1');
      expect(json['severity'], 'high');
      expect(json['status'], 'recorded');
    });

    test('fromJson should return valid ViolationModel', () {
      final json = model.toJson();
      final fromJson = ViolationModel.fromJson(json);
      expect(fromJson.localId, model.localId);
      expect(fromJson.severity, model.severity);
      expect(fromJson.status, model.status);
    });
  });
}
