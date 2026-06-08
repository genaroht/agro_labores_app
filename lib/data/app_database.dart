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
  TextColumn get code => text().unique()();
  TextColumn get fullName => text()();
  TextColumn get passwordPin => text()();
  TextColumn get roleId => text().references(Roles, #id)();
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

@DataClassName('FarmOperator')
class Operators extends Table {
  @override
  String get tableName => 'operators';

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get code => text()();
  TextColumn get fullName => text()();
  TextColumn get departmentId =>
      text().nullable().references(Departments, #id)();
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

  TextColumn get operatorId => text().nullable().references(Operators, #id)();
  TextColumn get operatorNameSnapshot => text().nullable()();

  TextColumn get cropId => text().nullable().references(Crops, #id)();
  TextColumn get cropNameSnapshot => text().nullable()();

  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get taskNameSnapshot => text().nullable()();
  TextColumn get taskDetail => text().nullable()();

  TextColumn get lot => text().nullable()();
  TextColumn get network => text().nullable()();

  RealColumn get scheduledWage => real().nullable()();
  RealColumn get realWage => real().nullable()();
  RealColumn get ha => real().withDefault(const Constant(0))();
  RealColumn get ratio => real().nullable()();

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
    Users,
    Departments,
    UserDepartments,
    Operators,
    Crops,
    Tasks,
    Locations,
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
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'agro_labores_local_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  Future<void> seedDemoData() async {
    await transaction(() async {
      await into(roles).insertOnConflictUpdate(
        RolesCompanion.insert(
          id: 'role_admin',
          name: 'admin',
          isAdmin: const Value(true),
        ),
      );

      await into(roles).insertOnConflictUpdate(
        RolesCompanion.insert(
          id: 'role_user',
          name: 'usuario',
          isAdmin: const Value(false),
        ),
      );

      await into(users).insertOnConflictUpdate(
        UsersCompanion.insert(
          id: 'user_001',
          code: '001',
          fullName: 'Usuario Demo',
          passwordPin: '123456',
          roleId: 'role_user',
        ),
      );

      await into(users).insertOnConflictUpdate(
        UsersCompanion.insert(
          id: 'user_admin',
          code: 'admin',
          fullName: 'Administrador Demo',
          passwordPin: '123456',
          roleId: 'role_admin',
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_labores_arandano',
          name: 'Labores Arándano',
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_cosecha_arandano',
          name: 'Cosecha Arándano',
        ),
      );

      await into(departments).insertOnConflictUpdate(
        DepartmentsCompanion.insert(
          id: 'dep_palto_fondo_01',
          name: 'Palto Fondo 01',
        ),
      );

      await into(userDepartments).insertOnConflictUpdate(
        UserDepartmentsCompanion.insert(
          id: 'user_001_dep_labores',
          userId: 'user_001',
          departmentId: 'dep_labores_arandano',
        ),
      );

      await into(userDepartments).insertOnConflictUpdate(
        UserDepartmentsCompanion.insert(
          id: 'user_001_dep_cosecha',
          userId: 'user_001',
          departmentId: 'dep_cosecha_arandano',
        ),
      );

      await into(userDepartments).insertOnConflictUpdate(
        UserDepartmentsCompanion.insert(
          id: 'admin_dep_labores',
          userId: 'user_admin',
          departmentId: 'dep_labores_arandano',
        ),
      );

      await into(userDepartments).insertOnConflictUpdate(
        UserDepartmentsCompanion.insert(
          id: 'admin_dep_cosecha',
          userId: 'user_admin',
          departmentId: 'dep_cosecha_arandano',
        ),
      );

      await into(userDepartments).insertOnConflictUpdate(
        UserDepartmentsCompanion.insert(
          id: 'admin_dep_palto',
          userId: 'user_admin',
          departmentId: 'dep_palto_fondo_01',
        ),
      );

      await into(operators).insertOnConflictUpdate(
        OperatorsCompanion.insert(
          id: 'op_001',
          code: 'OP001',
          fullName: 'Operario Demo 01',
          departmentId: const Value('dep_labores_arandano'),
        ),
      );

      await into(crops).insertOnConflictUpdate(
        CropsCompanion.insert(id: 'crop_arandano', name: 'Arándano'),
      );

      await into(crops).insertOnConflictUpdate(
        CropsCompanion.insert(id: 'crop_palto', name: 'Palto'),
      );

      await into(tasks).insertOnConflictUpdate(
        TasksCompanion.insert(
          id: 'task_poda',
          departmentId: const Value('dep_labores_arandano'),
          name: 'Poda',
          defaultDetail: const Value('Poda general'),
        ),
      );

      await into(tasks).insertOnConflictUpdate(
        TasksCompanion.insert(
          id: 'task_cosecha',
          departmentId: const Value('dep_cosecha_arandano'),
          name: 'Cosecha',
          defaultDetail: const Value('Cosecha manual'),
        ),
      );

      await into(locations).insertOnConflictUpdate(
        LocationsCompanion.insert(
          id: 'loc_ar_l1_r1_s1',
          cropId: 'crop_arandano',
          lot: 'Lote 01',
          network: 'Red 01',
          sector: 'Sector 01',
          ha: 1.25,
          suggestedDiningRoom: const Value('Comedor 1'),
        ),
      );

      await into(locations).insertOnConflictUpdate(
        LocationsCompanion.insert(
          id: 'loc_ar_l1_r1_s2',
          cropId: 'crop_arandano',
          lot: 'Lote 01',
          network: 'Red 01',
          sector: 'Sector 02',
          ha: 1.40,
          suggestedDiningRoom: const Value('Comedor 1'),
        ),
      );

      await into(locations).insertOnConflictUpdate(
        LocationsCompanion.insert(
          id: 'loc_pa_l5_r2_s3',
          cropId: 'crop_palto',
          lot: 'Lote 05',
          network: 'Red 02',
          sector: 'Sector 03',
          ha: 2.10,
          suggestedDiningRoom: const Value('Comedor 2'),
        ),
      );

      await into(formFieldConfigs).insertOnConflictUpdate(
        FormFieldConfigsCompanion.insert(
          id: 'field_labores_fecha',
          departmentId: 'dep_labores_arandano',
          fieldKey: 'recordDate',
          label: 'Fecha',
          fieldType: 'date',
          isRequired: const Value(true),
          sortOrder: const Value(1),
        ),
      );

      await into(formFieldConfigs).insertOnConflictUpdate(
        FormFieldConfigsCompanion.insert(
          id: 'field_labores_cultivo',
          departmentId: 'dep_labores_arandano',
          fieldKey: 'cropId',
          label: 'Cultivo',
          fieldType: 'select',
          isRequired: const Value(true),
          sortOrder: const Value(2),
        ),
      );

      await into(formFieldConfigs).insertOnConflictUpdate(
        FormFieldConfigsCompanion.insert(
          id: 'field_labores_labor',
          departmentId: 'dep_labores_arandano',
          fieldKey: 'taskId',
          label: 'Labor',
          fieldType: 'select',
          isRequired: const Value(true),
          sortOrder: const Value(3),
        ),
      );

      await into(tableColumnConfigs).insertOnConflictUpdate(
        TableColumnConfigsCompanion.insert(
          id: 'column_records_fecha',
          departmentId: const Value(null),
          tableKey: 'records',
          columnKey: 'recordDate',
          label: 'Fecha',
          sortOrder: const Value(1),
        ),
      );

      await into(tableColumnConfigs).insertOnConflictUpdate(
        TableColumnConfigsCompanion.insert(
          id: 'column_records_semana',
          departmentId: const Value(null),
          tableKey: 'records',
          columnKey: 'weekNumber',
          label: 'Semana',
          sortOrder: const Value(2),
        ),
      );

      await into(tableColumnConfigs).insertOnConflictUpdate(
        TableColumnConfigsCompanion.insert(
          id: 'column_records_ratio',
          departmentId: const Value(null),
          tableKey: 'records',
          columnKey: 'ratio',
          label: 'Ratio',
          sortOrder: const Value(3),
        ),
      );
    });
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

  Future<List<LocationEntry>> getLotsByCrop(String cropId) {
    return (select(locations)
          ..where(
            (tbl) =>
                tbl.cropId.equals(cropId) &
                tbl.isActive.equals(true) &
                tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.lot)]))
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
