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

part 'local_database.g.dart';

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
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DriftDatabase(tables: [Users, Mines, SyncQueue, Inspections, InspectionFindings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Visible for testing
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
