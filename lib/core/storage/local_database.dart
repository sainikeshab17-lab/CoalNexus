import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:coalnexus/shared/domain/entities/user.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/core/sync/sync_models.dart';

import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';

part 'local_database.g.dart';

@DataClassName('ViolationEntity')
class Violations extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get inspectionId => text()();
  TextColumn get findingId => text()();
  TextColumn get mineId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get severity => text().map(const EnumNameConverter(ViolationSeverity.values))();
  TextColumn get status => text().map(const EnumNameConverter(ViolationStatus.values))();
  TextColumn get assignedTo => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('CorrectiveActionEntity')
class CorrectiveActions extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get violationId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get assignedTo => text()();
  TextColumn get priority => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text().map(const EnumNameConverter(CorrectiveActionStatus.values))();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  TextColumn get evidence => text().nullable()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('AuditTrailEntity')
class AuditTrails extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get action => text()();
  TextColumn get previousState => text().nullable()();
  TextColumn get newState => text()();
  TextColumn get actorId => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get comment => text().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text().map(const EnumNameConverter(UserRole.values))();
  TextColumn get permissions => text()(); // Store as comma-separated or JSON
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MineEntity')
class Mines extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get mineCode => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get status => text().map(const EnumNameConverter(MineStatus.values))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('SyncQueueEntity')
class SyncQueue extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get featureName => text()();
  TextColumn get actionType => text()();
  TextColumn get payloadJson => text()();
  TextColumn get syncStatus => text().map(const EnumNameConverter(SyncStatus.values))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('InspectionEntity')
class Inspections extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get mineId => text()();
  TextColumn get inspectorId => text()();
  TextColumn get status => text().map(const EnumNameConverter(InspectionStatus.values))();
  TextColumn get category => text().map(const EnumNameConverter(InspectionCategory.values)).withDefault(const Constant('other'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('InspectionFindingEntity')
class InspectionFindings extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get inspectionId => text()();
  TextColumn get requirementId => text()();
  TextColumn get description => text()();
  TextColumn get status => text().map(const EnumNameConverter(FindingStatus.values))();
  TextColumn get severity => text().map(const EnumNameConverter(FindingSeverity.values)).withDefault(const Constant('medium'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DataClassName('AlertEntity')
class Alerts extends Table {
  TextColumn get localId => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get mineId => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get severity => text()(); // 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DriftDatabase(tables: [Users, Mines, SyncQueue, Inspections, InspectionFindings, Violations, Alerts, CorrectiveActions, AuditTrails])
class AppDatabase extends _$AppDatabase {
  final bool _shouldSeed;

  AppDatabase() : _shouldSeed = true, super(_openConnection());

  // Visible for testing
  AppDatabase.forTesting(super.e, {bool seed = false}) : _shouldSeed = seed;

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // For prototype, we ensure all tables exist.
        if (from < 2) {
          await m.createTable(inspections);
          await m.createTable(inspectionFindings);
        }
        if (from < 3) {
          await m.createTable(violations);
        }
        if (from < 4) {
          await m.createTable(alerts);
        }
        if (from < 5) {
          await m.addColumn(inspections, inspections.category);
          await m.addColumn(inspectionFindings, inspectionFindings.severity);
          await m.createTable(correctiveActions);
          await m.createTable(auditTrails);
        }
      },
      beforeOpen: (details) async {
        if (_shouldSeed) {
          // Ensure we have some basic demo data for the prototype
          final count = await select(mines).get();
          if (count.isEmpty) {
            await _seedDemoData();
          }
        }
      },
    );
  }

  Future<void> markAlertAsRead(String localId) {
    return (update(alerts)..where((t) => t.localId.equals(localId)))
        .write(const AlertsCompanion(isRead: Value(true)));
  }

  Future<void> _seedDemoData() async {
    // We'll implement this to populate the DB with realistic data
    final now = DateTime.now();

    // 1. Seed Mines
    final mineIds = ['seed_m1', 'seed_m2', 'seed_m3', 'seed_m4', 'seed_m5'];
    final mineNames = [
      'WCL Umrer',
      'Raniganj Mine',
      'Korba East Block',
      'Singrauli Main',
      'Talcher Open Cast'
    ];
    
    for (int i = 0; i < mineIds.length; i++) {
      await into(mines).insert(MinesCompanion.insert(
        localId: mineIds[i],
        name: mineNames[i],
        mineCode: 'MN-00${i + 1}',
        latitude: 23.79 + (i * 0.1),
        longitude: 86.41 + (i * 0.1),
        status: MineStatus.active,
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    }

    // 2. Seed Inspections
    final inspectionIds = ['seed_i1', 'seed_i2', 'seed_i3', 'seed_i4', 'seed_i5', 'seed_i6'];
    for (int i = 0; i < inspectionIds.length; i++) {
      await into(inspections).insert(InspectionsCompanion.insert(
        localId: inspectionIds[i],
        mineId: mineIds[i % mineIds.length],
        inspectorId: 'u1',
        status: i % 2 == 0 ? InspectionStatus.submitted : InspectionStatus.completed,
        createdAt: Value(now.subtract(Duration(days: i))),
        updatedAt: Value(now.subtract(Duration(days: i))),
      ));
      
      // Seed some findings for each inspection
      await into(inspectionFindings).insert(InspectionFindingsCompanion.insert(
        localId: 'seed_f${i}_1',
        inspectionId: inspectionIds[i],
        requirementId: 'SEC-001',
        description: 'Ventilation systems check',
        status: FindingStatus.compliant,
      ));
      
      if (i % 2 != 0) {
        await into(inspectionFindings).insert(InspectionFindingsCompanion.insert(
          localId: 'seed_f${i}_2',
          inspectionId: inspectionIds[i],
          requirementId: 'SAF-002',
          description: 'Roof support stability',
          status: FindingStatus.nonCompliant,
        ));
      }
    }

    // 3. Seed Violations
    final violationTitles = [
      'Inadequate Roof Support',
      'Methane Sensor Fault',
      'Missing Safety Gear',
      'Dust Suppression Inactive',
      'Emergency Exit Blocked',
      'Improper Explosive Storage',
      'Poor Illumination',
      'Overloading of Haul Trucks',
      'Ventilation Fan Vibration',
      'Unauthorized Personnel in Zone B'
    ];

    for (int i = 0; i < violationTitles.length; i++) {
      final severity = ViolationSeverity.values[i % ViolationSeverity.values.length];
      await into(violations).insert(ViolationsCompanion.insert(
        localId: 'seed_v$i',
        mineId: mineIds[i % mineIds.length],
        inspectionId: inspectionIds[i % inspectionIds.length],
        findingId: 'seed_f${i % inspectionIds.length}_2',
        title: violationTitles[i],
        description: 'Detailed report for ${violationTitles[i]} at site.',
        severity: severity,
        status: ViolationStatus.values[i % ViolationStatus.values.length],
        detectedAt: now.subtract(Duration(days: i)),
        createdAt: Value(now.subtract(Duration(days: i))),
        updatedAt: Value(now.subtract(Duration(days: i))),
      ));
    }

    // 4. Seed Alerts
    final alertsData = [
      {'title': 'High Methane Level', 'msg': 'Methane levels exceeding 1.2% in Shaft 3', 'sev': 'CRITICAL'},
      {'title': 'Roof Instability', 'msg': 'Micro-seismic activity detected in Block C', 'sev': 'HIGH'},
      {'title': 'Equipment Overheat', 'msg': 'Conveyor belt motor 4 reaching critical temp', 'sev': 'MEDIUM'},
      {'title': 'Personnel Alert', 'msg': 'Worker entered restricted zone D without permit', 'sev': 'HIGH'},
      {'title': 'Weekly Report', 'msg': 'System summary for week 34 available', 'sev': 'LOW'},
    ];

    for (int i = 0; i < alertsData.length; i++) {
      await into(alerts).insert(AlertsCompanion.insert(
        localId: 'seed_a$i',
        mineId: mineIds[i % mineIds.length],
        title: alertsData[i]['title']!,
        message: alertsData[i]['msg']!,
        severity: alertsData[i]['sev']!,
        createdAt: Value(now.subtract(Duration(hours: i * 2))),
      ));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
