import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class SyncStatuses {
  static const pending = 'pendiente';
  static const syncing = 'sincronizando';
  static const synced = 'sincronizado';
  static const error = 'error';
}

/// Helpers for legacy agricultural labels stored before normalization.
///
/// Examples:
/// - "Lote 1" -> "1"
/// - "Red 2" -> "2"
/// - "R2" -> "2"
/// - "Sector 15" -> "15"
class AgroLocalValueFormatters {
  const AgroLocalValueFormatters._();

  static String compactAgronomicNumber(String? value) {
    final raw = value?.trim() ?? '';

    if (raw.isEmpty) {
      return '';
    }

    final normalized = raw
        .replaceAll(
          RegExp(r'^(lote|lot|red|sector)\s+', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'^r\s*', caseSensitive: false), '')
        .trim();

    final numericMatch = RegExp(r'\d+(?:[\.,]\d+)?').firstMatch(normalized);

    if (numericMatch != null &&
        normalized.replaceAll(RegExp(r'[\d\.,]'), '').trim().isEmpty) {
      return numericMatch.group(0)!.replaceAll(',', '.');
    }

    return normalized;
  }

  static String compactLot(String? value) => compactAgronomicNumber(value);

  static String compactNetwork(String? value) => compactAgronomicNumber(value);

  static String compactSector(String? value) => compactAgronomicNumber(value);
}

@DataClassName('LocalRole')
class Roles extends Table {
  @override
  String get tableName => 'roles';

  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isAdmin => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalUser')
class Users extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get code => text().withLength(min: 6, max: 6).unique()();
  TextColumn get fullName => text()();
  TextColumn get passwordPin => text().withLength(min: 6, max: 6)();
  TextColumn get roleId => text().references(Roles, #id)();
  TextColumn get operatorId => text().nullable().references(Operators, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Department')
class Departments extends Table {
  @override
  String get tableName => 'departments';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get cropId => text().nullable().references(Crops, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserDepartment')
class UserDepartments extends Table {
  @override
  String get tableName => 'user_departments';

  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get departmentId => text().references(Departments, #id)();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OperatorPosition')
class Positions extends Table {
  @override
  String get tableName => 'positions';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text().unique()();
  BoolColumn get canBeLeader => boolean().withDefault(const Constant(false))();
  BoolColumn get canLogin => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmOperator')
class Operators extends Table {
  @override
  String get tableName => 'operators';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get code => text().withLength(min: 6, max: 6).unique()();
  TextColumn get fullName => text()();
  TextColumn get departmentId =>
      text().nullable().references(Departments, #id)();
  TextColumn get positionId => text().nullable().references(Positions, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Crop')
class Crops extends Table {
  @override
  String get tableName => 'crops';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmTask')
class Tasks extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get departmentId =>
      text().nullable().references(Departments, #id)();
  TextColumn get cropId => text().nullable().references(Crops, #id)();
  TextColumn get code => text().nullable()();
  TextColumn get name => text()();
  TextColumn get defaultDetail => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocationEntry')
class Locations extends Table {
  @override
  String get tableName => 'locations';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get cropId => text().references(Crops, #id)();
  TextColumn get lot => text()();
  TextColumn get network => text()();
  TextColumn get sector => text()();
  TextColumn get farmType => text().nullable()();
  RealColumn get ha => real()();
  TextColumn get suggestedDiningRoom => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiningRoom')
class DiningRooms extends Table {
  @override
  String get tableName => 'dining_rooms';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get cropId => text().references(Crops, #id)();
  TextColumn get name => text()();
  TextColumn get lot => text().nullable()();
  TextColumn get network => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmRecord')
class Records extends Table {
  @override
  String get tableName => 'records';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();

  DateTimeColumn get recordDate => dateTime()();
  IntColumn get weekNumber => integer()();

  TextColumn get departmentId => text().references(Departments, #id)();
  TextColumn get createdByUserId => text().references(Users, #id)();
  TextColumn get userCode => text()();

  @ReferenceName('programmedOperatorRecords')
  TextColumn get operatorId => text().nullable().references(Operators, #id)();
  TextColumn get operatorNameSnapshot => text().nullable()();

  // Explicit leader fields. The legacy operatorId/operatorNameSnapshot are
  // kept for backward compatibility with the current UI and old records.
  @ReferenceName('leaderRecords')
  TextColumn get leaderOperatorId =>
      text().nullable().references(Operators, #id)();
  TextColumn get leaderCodeSnapshot => text().nullable()();
  TextColumn get leaderNameSnapshot => text().nullable()();

  TextColumn get cropId => text().nullable().references(Crops, #id)();
  TextColumn get cropNameSnapshot => text().nullable()();

  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get taskCodeSnapshot => text().nullable()();
  TextColumn get taskNameSnapshot => text().nullable()();
  TextColumn get taskDetail => text().nullable()();

  TextColumn get lot => text().nullable()();
  TextColumn get network => text().nullable()();

  RealColumn get scheduledWage => real().nullable()();
  RealColumn get realWage => real().nullable()();
  RealColumn get ha => real().withDefault(const Constant(0))();
  RealColumn get ratio => real().nullable()();

  TextColumn get diningRoomId =>
      text().nullable().references(DiningRooms, #id)();
  TextColumn get diningRoom => text().nullable()();
  TextColumn get observation => text().nullable()();

  TextColumn get extraFieldsJson => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FarmRecordLocation')
class RecordLocations extends Table {
  @override
  String get tableName => 'record_locations';

  TextColumn get id => text()();
  TextColumn get recordId => text().references(Records, #id)();
  TextColumn get locationId => text().references(Locations, #id)();

  TextColumn get cropNameSnapshot => text()();
  TextColumn get lotSnapshot => text()();
  TextColumn get networkSnapshot => text()();
  TextColumn get sectorSnapshot => text()();
  RealColumn get haSnapshot => real()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FormFieldConfig')
class FormFieldConfigs extends Table {
  @override
  String get tableName => 'form_field_configs';

  TextColumn get id => text()();
  TextColumn get departmentId => text().references(Departments, #id)();
  TextColumn get fieldKey => text()();
  TextColumn get label => text()();
  TextColumn get fieldType => text()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get optionsJson => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TableColumnConfig')
class TableColumnConfigs extends Table {
  @override
  String get tableName => 'table_column_configs';

  TextColumn get id => text()();
  TextColumn get departmentId =>
      text().nullable().references(Departments, #id)();
  TextColumn get tableKey => text()();
  TextColumn get columnKey => text()();
  TextColumn get label => text()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  BoolColumn get isExportable => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.synced))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncQueueItem')
class SyncQueueItems extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  TextColumn get status =>
      text().withDefault(const Constant(SyncStatuses.pending))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant(SyncStatuses.pending))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Roles,
    Crops,
    Positions,
    Departments,
    Operators,
    Users,
    UserDepartments,
    Tasks,
    Locations,
    DiningRooms,
    Records,
    RecordLocations,
    FormFieldConfigs,
    TableColumnConfigs,
    SyncQueueItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _ensureCoreCatalogData();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _upgradeFrom1To2(m);
      }
      if (from < 3) {
        await m.addColumn(locations, locations.farmType);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _ensureCoreCatalogData();
    },
  );

  Future<void> _upgradeFrom1To2(Migrator m) async {
    await m.createTable(positions);
    await m.createTable(diningRooms);
    await _ensureDefaultPositions();

    await m.addColumn(users, users.operatorId);
    await m.addColumn(departments, departments.cropId);
    await m.addColumn(operators, operators.positionId);
    await m.addColumn(tasks, tasks.cropId);
    await m.addColumn(tasks, tasks.code);
    await m.addColumn(records, records.leaderOperatorId);
    await m.addColumn(records, records.leaderCodeSnapshot);
    await m.addColumn(records, records.leaderNameSnapshot);
    await m.addColumn(records, records.taskCodeSnapshot);
    await m.addColumn(records, records.diningRoomId);

    await customStatement('''
      UPDATE departments
      SET crop_id = 'crop_arandano'
      WHERE crop_id IS NULL
        AND EXISTS (SELECT 1 FROM crops WHERE id = 'crop_arandano')
        AND (name LIKE '%Arándano%' OR name LIKE '%Arandano%')
    ''');

    await customStatement('''
      UPDATE departments
      SET crop_id = 'crop_palto'
      WHERE crop_id IS NULL
        AND EXISTS (SELECT 1 FROM crops WHERE id = 'crop_palto')
        AND name LIKE '%Palto%'
    ''');

    await customStatement('''
      UPDATE tasks
      SET crop_id = (
        SELECT crop_id
        FROM departments
        WHERE departments.id = tasks.department_id
      )
      WHERE crop_id IS NULL
        AND department_id IS NOT NULL
        AND EXISTS (
          SELECT 1
          FROM departments
          WHERE departments.id = tasks.department_id
            AND departments.crop_id IS NOT NULL
        )
    ''');

    await customStatement('''
      UPDATE records
      SET leader_operator_id = operator_id,
          leader_name_snapshot = operator_name_snapshot
      WHERE leader_operator_id IS NULL
        AND operator_id IS NOT NULL
    ''');

    await customStatement('''
      UPDATE records
      SET leader_code_snapshot = (
        SELECT code
        FROM operators
        WHERE operators.id = records.operator_id
      )
      WHERE leader_code_snapshot IS NULL
        AND operator_id IS NOT NULL
        AND EXISTS (
          SELECT 1
          FROM operators
          WHERE operators.id = records.operator_id
        )
    ''');

    await customStatement('''
      UPDATE records
      SET task_code_snapshot = (
        SELECT code
        FROM tasks
        WHERE tasks.id = records.task_id
      )
      WHERE task_code_snapshot IS NULL
        AND task_id IS NOT NULL
        AND EXISTS (
          SELECT 1
          FROM tasks
          WHERE tasks.id = records.task_id
            AND tasks.code IS NOT NULL
        )
    ''');

    await customStatement('''
      UPDATE operators
      SET position_id = 'position_lider'
      WHERE position_id IS NULL
        AND EXISTS (
          SELECT 1
          FROM records
          WHERE records.operator_id = operators.id
             OR records.leader_operator_id = operators.id
        )
    ''');

    await customStatement('''
      UPDATE operators
      SET position_id = 'position_operario'
      WHERE position_id IS NULL
    ''');
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'agro_labores_local_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  Future<void> _ensureCoreCatalogData() async {
    await into(roles).insert(
      RolesCompanion.insert(
        id: 'role_admin',
        name: 'admin',
        isAdmin: const Value(true),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await into(roles).insert(
      RolesCompanion.insert(
        id: 'role_user',
        name: 'supervisor',
        isAdmin: const Value(false),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await _ensureDefaultPositions();
  }

  Future<void> _ensureDefaultPositions() async {
    final now = DateTime.now();

    await into(positions).insert(
      PositionsCompanion.insert(
        id: 'position_lider',
        name: 'líder',
        canBeLeader: const Value(true),
        canLogin: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await into(positions).insert(
      PositionsCompanion.insert(
        id: 'position_supervisor',
        name: 'supervisor',
        canBeLeader: const Value(false),
        canLogin: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await into(positions).insert(
      PositionsCompanion.insert(
        id: 'position_operario',
        name: 'operario',
        canBeLeader: const Value(false),
        canLogin: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    await into(positions).insert(
      PositionsCompanion.insert(
        id: 'position_otro',
        name: 'otro',
        canBeLeader: const Value(false),
        canLogin: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> seedDevelopmentData() async {
    await transaction(() async {
      await _ensureCoreCatalogData();

      await into(crops).insertOnConflictUpdate(
        CropsCompanion.insert(id: 'crop_arandano', name: 'Arándano'),
      );

      await into(crops).insertOnConflictUpdate(
        CropsCompanion.insert(id: 'crop_palto', name: 'Palto'),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_labores_arandano',
          name: 'Labores Arándano',
          cropId: const Value('crop_arandano'),
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_cosecha_arandano',
          name: 'Cosecha Arándano',
          cropId: const Value('crop_arandano'),
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_palto_fondo_01',
          name: 'Palto, Fundo 1',
          cropId: const Value('crop_palto'),
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_palto_fondo_02',
          name: 'Palto, Fundo 2',
          cropId: const Value('crop_palto'),
        ),
      );

      await into(users).insertOnConflictUpdate(
        UsersCompanion.insert(
          id: 'user_admin',
          code: '999999',
          fullName: 'Administrador',
          passwordPin: '123456',
          roleId: 'role_admin',
        ),
      );

      // Garantiza que el usuario local de desarrollo pueda volver a iniciar
      // sesión aunque la base SQLite previa tenga otro PIN, esté inactivo
      // o haya quedado marcado como eliminado.
      await (update(users)..where((tbl) => tbl.code.equals('999999'))).write(
        UsersCompanion(
          fullName: const Value('Administrador'),
          passwordPin: const Value('123456'),
          roleId: const Value('role_admin'),
          isActive: const Value(true),
          deletedAt: const Value<DateTime?>(null),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await into(operators).insertOnConflictUpdate(
        OperatorsCompanion.insert(
          id: 'op_ramos',
          code: '422519',
          fullName: 'Ramos',
          departmentId: const Value('dep_palto_fondo_02'),
          positionId: const Value('position_lider'),
        ),
      );

      await into(operators).insertOnConflictUpdate(
        OperatorsCompanion.insert(
          id: 'op_apolinario',
          code: '416737',
          fullName: 'Apolinario',
          departmentId: const Value('dep_palto_fondo_02'),
          positionId: const Value('position_lider'),
        ),
      );

      await into(operators).insertOnConflictUpdate(
        OperatorsCompanion.insert(
          id: 'op_angelo',
          code: '376810',
          fullName: 'Angelo',
          departmentId: const Value('dep_labores_arandano'),
          positionId: const Value('position_lider'),
        ),
      );

      final sampleLocations = <LocationsCompanion>[
        LocationsCompanion.insert(
          id: 'loc_ar_7_2_13',
          cropId: 'crop_arandano',
          lot: '7',
          network: '2',
          sector: '13',
          ha: 3.19,
          suggestedDiningRoom: const Value('Comedor Arándano 7'),
        ),
        LocationsCompanion.insert(
          id: 'loc_ar_7_2_14',
          cropId: 'crop_arandano',
          lot: '7',
          network: '2',
          sector: '14',
          ha: 2.79,
          suggestedDiningRoom: const Value('Comedor Arándano 7'),
        ),
        LocationsCompanion.insert(
          id: 'loc_ar_7_2_15',
          cropId: 'crop_arandano',
          lot: '7',
          network: '2',
          sector: '15',
          ha: 1.76,
          suggestedDiningRoom: const Value('Comedor Arándano 7'),
        ),
        LocationsCompanion.insert(
          id: 'loc_pa_16_5_55',
          cropId: 'crop_palto',
          lot: '16',
          network: '5',
          sector: '55',
          farmType: const Value('Fundo 1'),
          ha: 1.80,
          suggestedDiningRoom: const Value('Comedor Palto 16'),
        ),
        LocationsCompanion.insert(
          id: 'loc_pa_16_5_56',
          cropId: 'crop_palto',
          lot: '16',
          network: '5',
          sector: '56',
          farmType: const Value('Fundo 1'),
          ha: 0.39,
          suggestedDiningRoom: const Value('Comedor Palto 16'),
        ),
        LocationsCompanion.insert(
          id: 'loc_pa_16_5_57',
          cropId: 'crop_palto',
          lot: '16',
          network: '5',
          sector: '57',
          farmType: const Value('Fundo 2'),
          ha: 2.82,
          suggestedDiningRoom: const Value('Comedor Palto 16'),
        ),
      ];

      for (final location in sampleLocations) {
        await into(locations).insertOnConflictUpdate(location);
      }

      await into(diningRooms).insertOnConflictUpdate(
        DiningRoomsCompanion.insert(
          id: 'dining_arandano_7_2',
          cropId: 'crop_arandano',
          name: 'Comedor Arándano 7',
          lot: const Value('7'),
          network: const Value('2'),
        ),
      );

      await into(diningRooms).insertOnConflictUpdate(
        DiningRoomsCompanion.insert(
          id: 'dining_palto_16_5',
          cropId: 'crop_palto',
          name: 'Comedor Palto 16',
          lot: const Value('16'),
          network: const Value('5'),
        ),
      );
    });
  }

  Future<LocalUser?> getUserByCodeIncludingInactive(String code) {
    return (select(
      users,
    )..where((tbl) => tbl.code.equals(code))).getSingleOrNull();
  }

  Future<LocalUser?> getUserByCode(String code) {
    return (select(users)..where(
          (tbl) =>
              tbl.code.equals(code) &
              tbl.isActive.equals(true) &
              tbl.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<LocalRole?> getRoleById(String roleId) {
    return (select(roles)
          ..where((tbl) => tbl.id.equals(roleId) & tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<List<Department>> getDepartmentsForUserCode(String userCode) async {
    final query =
        select(departments).join([
            innerJoin(
              userDepartments,
              userDepartments.departmentId.equalsExp(departments.id),
            ),
            innerJoin(users, users.id.equalsExp(userDepartments.userId)),
          ])
          ..where(
            users.code.equals(userCode) &
                users.isActive.equals(true) &
                users.deletedAt.isNull() &
                departments.isActive.equals(true) &
                departments.deletedAt.isNull() &
                userDepartments.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(departments.name)]);

    final rows = await query.get();

    return rows.map((row) => row.readTable(departments)).toList();
  }

  Future<List<Crop>> getActiveCrops() {
    return (select(crops)
          ..where((tbl) => tbl.isActive.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<FarmTask>> getActiveTasksByDepartment(String departmentId) {
    return (select(tasks)
          ..where(
            (tbl) =>
                tbl.isActive.equals(true) &
                tbl.deletedAt.isNull() &
                tbl.departmentId.equals(departmentId),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<LocationEntry>> getLocationsByCrop(String cropId) {
    return getLocationsByCropAndFarmType(cropId: cropId);
  }

  Future<List<LocationEntry>> getLocationsByCropAndFarmType({
    required String cropId,
    String? farmType,
  }) {
    final query = select(locations)
      ..where(
        (tbl) =>
            tbl.cropId.equals(cropId) &
            tbl.isActive.equals(true) &
            tbl.deletedAt.isNull(),
      )
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.lot),
        (tbl) => OrderingTerm.asc(tbl.network),
        (tbl) => OrderingTerm.asc(tbl.sector),
      ]);

    final cleanFarmType = farmType?.trim();

    if (cleanFarmType != null && cleanFarmType.isNotEmpty) {
      query.where((tbl) => tbl.farmType.equals(cleanFarmType));
    }

    return query.get();
  }

  Future<List<DiningRoom>> getActiveDiningRoomsByCropLotNetwork({
    required String cropId,
    required String lot,
    required String network,
  }) {
    final cleanLot = AgroLocalValueFormatters.compactLot(lot);
    final cleanNetwork = AgroLocalValueFormatters.compactNetwork(network);

    return (select(diningRooms)
          ..where(
            (tbl) =>
                tbl.cropId.equals(cropId) &
                tbl.lot.equals(cleanLot) &
                tbl.network.equals(cleanNetwork) &
                tbl.isActive.equals(true) &
                tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<int> countUsers() async {
    final countExpression = users.id.count();
    final query = selectOnly(users)..addColumns([countExpression]);
    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }

  Future<int> countDepartments() async {
    final countExpression = departments.id.count();
    final query = selectOnly(departments)..addColumns([countExpression]);
    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }

  Future<int> countLocations() async {
    final countExpression = locations.id.count();
    final query = selectOnly(locations)..addColumns([countExpression]);
    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }

  Future<int> countSyncQueueItems() async {
    final countExpression = syncQueueItems.id.count();
    final query = selectOnly(syncQueueItems)..addColumns([countExpression]);
    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }
}
