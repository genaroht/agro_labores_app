import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import 'report_models.dart';

class ReportRepository {
  const ReportRepository(this._database);

  final AppDatabase _database;

  Future<List<Department>> getDepartments() {
    return (_database.select(_database.departments)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<Crop>> getCrops() {
    return (_database.select(_database.crops)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<FarmTask>> getTasks() {
    return (_database.select(_database.tasks)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
            (tbl) => OrderingTerm.asc(tbl.code),
          ]))
        .get();
  }

  Future<List<FarmOperator>> getOperators() {
    return (_database.select(_database.operators)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  Future<List<LocalUser>> getUsers() {
    return (_database.select(_database.users)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  Future<List<DiningRoom>> getDiningRooms() {
    return (_database.select(_database.diningRooms)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.name),
            (tbl) => OrderingTerm.asc(tbl.lot),
            (tbl) => OrderingTerm.asc(tbl.network),
          ]))
        .get();
  }

  Future<List<String>> getLots() async {
    final values = <String>{};

    final locations =
        await (_database.select(_database.locations)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();
    values.addAll(locations.map((item) => _compactLot(item.lot)));

    final recordLocations = await (_database.select(
      _database.recordLocations,
    )..where((tbl) => tbl.deletedAt.isNull())).get();
    values.addAll(recordLocations.map((item) => _compactLot(item.lotSnapshot)));

    final records =
        await (_database.select(_database.records)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();
    values.addAll(records.map((item) => _compactLot(item.lot)));

    return _sortedValues(values);
  }

  Future<List<String>> getNetworks() async {
    final values = <String>{};

    final locations =
        await (_database.select(_database.locations)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();
    values.addAll(locations.map((item) => _compactNetwork(item.network)));

    final recordLocations = await (_database.select(
      _database.recordLocations,
    )..where((tbl) => tbl.deletedAt.isNull())).get();
    values.addAll(
      recordLocations.map((item) => _compactNetwork(item.networkSnapshot)),
    );

    final records =
        await (_database.select(_database.records)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();
    values.addAll(records.map((item) => _compactNetwork(item.network)));

    return _sortedValues(values);
  }

  Future<List<String>> getSectors() async {
    final values = <String>{};

    final locations =
        await (_database.select(_database.locations)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();
    values.addAll(locations.map((item) => _compactSector(item.sector)));

    final recordLocations = await (_database.select(
      _database.recordLocations,
    )..where((tbl) => tbl.deletedAt.isNull())).get();
    values.addAll(
      recordLocations.map((item) => _compactSector(item.sectorSnapshot)),
    );

    return _sortedValues(values);
  }

  Future<List<ReportRow>> getReportRows(ReportFilters filters) async {
    final query = _database.select(_database.records)
      ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.recordDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    if (filters.departmentId != null) {
      query.where((tbl) => tbl.departmentId.equals(filters.departmentId!));
    }

    if (filters.cropId != null) {
      query.where((tbl) => tbl.cropId.equals(filters.cropId!));
    }

    if (filters.taskId != null) {
      query.where((tbl) => tbl.taskId.equals(filters.taskId!));
    }

    if (filters.createdByUserId != null) {
      query.where(
        (tbl) => tbl.createdByUserId.equals(filters.createdByUserId!),
      );
    }

    if (filters.leaderOperatorId != null) {
      query.where(
        (tbl) =>
            tbl.leaderOperatorId.equals(filters.leaderOperatorId!) |
            tbl.operatorId.equals(filters.leaderOperatorId!),
      );
    }

    if (filters.weekNumber != null) {
      query.where((tbl) => tbl.weekNumber.equals(filters.weekNumber!));
    }

    final records = await query.get();
    final departments = await getDepartments();
    final crops = await getCrops();
    final tasks = await getTasks();
    final operators = await getOperators();
    final users = await getUsers();
    final diningRooms = await getDiningRooms();

    final departmentById = {for (final item in departments) item.id: item};
    final cropById = {for (final item in crops) item.id: item};
    final taskById = {for (final item in tasks) item.id: item};
    final operatorById = {for (final item in operators) item.id: item};
    final userById = {for (final item in users) item.id: item};
    final diningRoomById = {for (final item in diningRooms) item.id: item};

    final selectedDiningRoomName = filters.diningRoomId == null
        ? null
        : diningRoomById[filters.diningRoomId!]?.name;

    final rows = <ReportRow>[];

    for (final record in records) {
      if (!_matchesDateFilters(record.recordDate, filters)) {
        continue;
      }

      final recordLocations =
          await (_database.select(_database.recordLocations)
                ..where(
                  (tbl) =>
                      tbl.recordId.equals(record.id) & tbl.deletedAt.isNull(),
                )
                ..orderBy([
                  (tbl) => OrderingTerm.asc(tbl.lotSnapshot),
                  (tbl) => OrderingTerm.asc(tbl.networkSnapshot),
                  (tbl) => OrderingTerm.asc(tbl.sectorSnapshot),
                ]))
              .get();

      if (recordLocations.isEmpty) {
        final row = _buildRowWithoutSector(
          record: record,
          departmentById: departmentById,
          cropById: cropById,
          taskById: taskById,
          operatorById: operatorById,
          userById: userById,
          diningRoomById: diningRoomById,
        );

        if (_matchesRowFilters(row, filters, selectedDiningRoomName)) {
          rows.add(row);
        }

        continue;
      }

      for (final location in recordLocations) {
        final row = _buildRowWithSector(
          record: record,
          location: location,
          departmentById: departmentById,
          cropById: cropById,
          taskById: taskById,
          operatorById: operatorById,
          userById: userById,
          diningRoomById: diningRoomById,
        );

        if (_matchesRowFilters(row, filters, selectedDiningRoomName)) {
          rows.add(row);
        }
      }
    }

    return rows;
  }

  bool _matchesDateFilters(DateTime date, ReportFilters filters) {
    final recordDate = DateTime(date.year, date.month, date.day);

    if (filters.dateFrom != null) {
      final from = DateTime(
        filters.dateFrom!.year,
        filters.dateFrom!.month,
        filters.dateFrom!.day,
      );

      if (recordDate.isBefore(from)) {
        return false;
      }
    }

    if (filters.dateTo != null) {
      final to = DateTime(
        filters.dateTo!.year,
        filters.dateTo!.month,
        filters.dateTo!.day,
      );

      if (recordDate.isAfter(to)) {
        return false;
      }
    }

    return true;
  }

  bool _matchesRowFilters(
    ReportRow row,
    ReportFilters filters,
    String? selectedDiningRoomName,
  ) {
    if (filters.lot != null && row.lot != filters.lot) {
      return false;
    }

    if (filters.network != null && row.network != filters.network) {
      return false;
    }

    if (filters.sector != null && row.sector != filters.sector) {
      return false;
    }

    if (filters.diningRoomId != null) {
      final matchesId = row.diningRoomId == filters.diningRoomId;
      final matchesLegacyName =
          selectedDiningRoomName != null &&
          row.diningRoom.trim().toLowerCase() ==
              selectedDiningRoomName.trim().toLowerCase();

      if (!matchesId && !matchesLegacyName) {
        return false;
      }
    }

    return true;
  }

  ReportRow _buildRowWithSector({
    required FarmRecord record,
    required FarmRecordLocation location,
    required Map<String, Department> departmentById,
    required Map<String, Crop> cropById,
    required Map<String, FarmTask> taskById,
    required Map<String, FarmOperator> operatorById,
    required Map<String, LocalUser> userById,
    required Map<String, DiningRoom> diningRoomById,
  }) {
    final lot = _compactLot(location.lotSnapshot);
    final network = _compactNetwork(location.networkSnapshot);
    final sector = _compactSector(location.sectorSnapshot);

    return _buildBaseRow(
      record: record,
      recordLocationId: location.id,
      lot: lot,
      network: network,
      sector: sector,
      haSector: location.haSnapshot,
      departmentById: departmentById,
      cropById: cropById,
      taskById: taskById,
      operatorById: operatorById,
      userById: userById,
      diningRoomById: diningRoomById,
    );
  }

  ReportRow _buildRowWithoutSector({
    required FarmRecord record,
    required Map<String, Department> departmentById,
    required Map<String, Crop> cropById,
    required Map<String, FarmTask> taskById,
    required Map<String, FarmOperator> operatorById,
    required Map<String, LocalUser> userById,
    required Map<String, DiningRoom> diningRoomById,
  }) {
    return _buildBaseRow(
      record: record,
      recordLocationId: null,
      lot: _compactLot(record.lot),
      network: _compactNetwork(record.network),
      sector: '-',
      haSector: record.ha,
      departmentById: departmentById,
      cropById: cropById,
      taskById: taskById,
      operatorById: operatorById,
      userById: userById,
      diningRoomById: diningRoomById,
    );
  }

  ReportRow _buildBaseRow({
    required FarmRecord record,
    required String? recordLocationId,
    required String lot,
    required String network,
    required String sector,
    required double haSector,
    required Map<String, Department> departmentById,
    required Map<String, Crop> cropById,
    required Map<String, FarmTask> taskById,
    required Map<String, FarmOperator> operatorById,
    required Map<String, LocalUser> userById,
    required Map<String, DiningRoom> diningRoomById,
  }) {
    final user = userById[record.createdByUserId];
    final task = record.taskId == null ? null : taskById[record.taskId!];
    final leaderId = record.leaderOperatorId ?? record.operatorId;
    final leader = leaderId == null ? null : operatorById[leaderId];
    final crop = record.cropId == null ? null : cropById[record.cropId!];
    final diningRoom = record.diningRoomId == null
        ? null
        : diningRoomById[record.diningRoomId!];

    final leaderCode = record.leaderCodeSnapshot?.trim().isNotEmpty == true
        ? record.leaderCodeSnapshot!.trim()
        : leader?.code ?? '-';
    final leaderName = record.leaderNameSnapshot?.trim().isNotEmpty == true
        ? record.leaderNameSnapshot!.trim()
        : record.operatorNameSnapshot?.trim().isNotEmpty == true
        ? record.operatorNameSnapshot!.trim()
        : leader?.fullName ?? '-';
    final taskCode = record.taskCodeSnapshot?.trim().isNotEmpty == true
        ? record.taskCodeSnapshot!.trim()
        : task?.code?.trim().isNotEmpty == true
        ? task!.code!.trim()
        : '-';
    final taskName = record.taskNameSnapshot?.trim().isNotEmpty == true
        ? record.taskNameSnapshot!.trim()
        : task?.name ?? '-';
    final cropName = record.cropNameSnapshot?.trim().isNotEmpty == true
        ? record.cropNameSnapshot!.trim()
        : crop?.name ?? '-';
    final diningRoomName = record.diningRoom?.trim().isNotEmpty == true
        ? record.diningRoom!.trim()
        : diningRoom?.name ?? '-';
    final userLabel = user == null
        ? record.userCode
        : '${user.code} - ${user.fullName}';

    return ReportRow(
      recordId: record.id,
      recordLocationId: recordLocationId,
      date: record.recordDate,
      week: record.weekNumber,
      departmentId: record.departmentId,
      departmentName:
          departmentById[record.departmentId]?.name ?? record.departmentId,
      createdByUserId: record.createdByUserId,
      createdByUserCode: user?.code ?? record.userCode,
      createdByUserName: userLabel,
      leaderOperatorId: leaderId,
      leaderName: leaderName,
      leaderCode: leaderCode,
      taskId: record.taskId,
      taskCode: taskCode,
      taskName: taskName,
      cropId: record.cropId,
      cropName: cropName,
      lot: lot.isEmpty ? '-' : lot,
      network: network.isEmpty ? '-' : network,
      sector: sector.isEmpty ? '-' : sector,
      haSector: haSector,
      haTotal: record.ha,
      scheduledWage: record.scheduledWage,
      realWage: record.realWage,
      ratio: record.ratio,
      diningRoomId: record.diningRoomId,
      diningRoom: diningRoomName,
      observation: record.observation?.trim().isNotEmpty == true
          ? record.observation!.trim()
          : '',
    );
  }

  List<String> _sortedValues(Set<String> values) {
    final result = values.where((item) => item.trim().isNotEmpty).toList();
    result.sort(_compareAgronomicValues);
    return result;
  }

  int _compareAgronomicValues(String a, String b) {
    final aNumber = double.tryParse(a);
    final bNumber = double.tryParse(b);

    if (aNumber != null && bNumber != null) {
      return aNumber.compareTo(bNumber);
    }

    return a.compareTo(b);
  }

  String _compactLot(String? value) =>
      AgroLocalValueFormatters.compactLot(value);

  String _compactNetwork(String? value) =>
      AgroLocalValueFormatters.compactNetwork(value);

  String _compactSector(String? value) =>
      AgroLocalValueFormatters.compactSector(value);
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ReportRepository(database);
});
