class ReportFilters {
  const ReportFilters({
    this.dateFrom,
    this.dateTo,
    this.weekNumber,
    this.departmentId,
    this.cropId,
    this.taskId,
    this.leaderOperatorId,
    this.createdByUserId,
    this.lot,
    this.network,
    this.sector,
    this.diningRoomId,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? weekNumber;
  final String? departmentId;
  final String? cropId;
  final String? taskId;
  final String? leaderOperatorId;
  final String? createdByUserId;
  final String? lot;
  final String? network;
  final String? sector;
  final String? diningRoomId;

  ReportFilters copyWith({
    DateTime? dateFrom,
    bool clearDateFrom = false,
    DateTime? dateTo,
    bool clearDateTo = false,
    int? weekNumber,
    bool clearWeekNumber = false,
    String? departmentId,
    bool clearDepartmentId = false,
    String? cropId,
    bool clearCropId = false,
    String? taskId,
    bool clearTaskId = false,
    String? leaderOperatorId,
    bool clearLeaderOperatorId = false,
    String? createdByUserId,
    bool clearCreatedByUserId = false,
    String? lot,
    bool clearLot = false,
    String? network,
    bool clearNetwork = false,
    String? sector,
    bool clearSector = false,
    String? diningRoomId,
    bool clearDiningRoomId = false,
  }) {
    return ReportFilters(
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      weekNumber: clearWeekNumber ? null : weekNumber ?? this.weekNumber,
      departmentId: clearDepartmentId
          ? null
          : departmentId ?? this.departmentId,
      cropId: clearCropId ? null : cropId ?? this.cropId,
      taskId: clearTaskId ? null : taskId ?? this.taskId,
      leaderOperatorId: clearLeaderOperatorId
          ? null
          : leaderOperatorId ?? this.leaderOperatorId,
      createdByUserId: clearCreatedByUserId
          ? null
          : createdByUserId ?? this.createdByUserId,
      lot: clearLot ? null : lot ?? this.lot,
      network: clearNetwork ? null : network ?? this.network,
      sector: clearSector ? null : sector ?? this.sector,
      diningRoomId: clearDiningRoomId
          ? null
          : diningRoomId ?? this.diningRoomId,
    );
  }
}

class ReportRow {
  const ReportRow({
    required this.recordId,
    required this.recordLocationId,
    required this.date,
    required this.week,
    required this.departmentId,
    required this.departmentName,
    required this.createdByUserId,
    required this.createdByUserCode,
    required this.createdByUserName,
    required this.leaderOperatorId,
    required this.leaderName,
    required this.leaderCode,
    required this.taskId,
    required this.taskCode,
    required this.taskName,
    required this.cropId,
    required this.cropName,
    required this.lot,
    required this.network,
    required this.sector,
    required this.haSector,
    required this.haTotal,
    required this.scheduledWage,
    required this.realWage,
    required this.ratio,
    required this.diningRoomId,
    required this.diningRoom,
    required this.observation,
  });

  final String recordId;
  final String? recordLocationId;
  final DateTime date;
  final int week;

  final String departmentId;
  final String departmentName;

  final String createdByUserId;
  final String createdByUserCode;
  final String createdByUserName;

  final String? leaderOperatorId;
  final String leaderName;
  final String leaderCode;

  final String? taskId;
  final String taskCode;
  final String taskName;

  final String? cropId;
  final String cropName;

  final String lot;
  final String network;
  final String sector;

  final double haSector;
  final double haTotal;
  final double? scheduledWage;
  final double? realWage;
  final double? ratio;

  final String? diningRoomId;
  final String diningRoom;
  final String observation;

  Object? valueForColumn(ReportColumn column) {
    switch (column) {
      case ReportColumn.date:
        return _formatDate(date);
      case ReportColumn.week:
        return week;
      case ReportColumn.department:
        return departmentName;
      case ReportColumn.createdByUser:
        return createdByUserName;
      case ReportColumn.leader:
        return leaderName;
      case ReportColumn.leaderCode:
        return leaderCode;
      case ReportColumn.taskCode:
        return taskCode;
      case ReportColumn.task:
        return taskName;
      case ReportColumn.crop:
        return cropName;
      case ReportColumn.lot:
        return lot;
      case ReportColumn.network:
        return network;
      case ReportColumn.sector:
        return sector;
      case ReportColumn.haSector:
        return haSector;
      case ReportColumn.haTotal:
        return haTotal;
      case ReportColumn.scheduledWage:
        return scheduledWage;
      case ReportColumn.realWage:
        return realWage;
      case ReportColumn.ratio:
        return ratio;
      case ReportColumn.diningRoom:
        return diningRoom;
      case ReportColumn.observation:
        return observation;
    }
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

enum ReportColumn {
  date,
  week,
  department,
  createdByUser,
  leader,
  leaderCode,
  taskCode,
  task,
  crop,
  lot,
  network,
  sector,
  haSector,
  haTotal,
  scheduledWage,
  realWage,
  ratio,
  diningRoom,
  observation,
}

extension ReportColumnLabel on ReportColumn {
  String get label {
    switch (this) {
      case ReportColumn.date:
        return 'Fecha';
      case ReportColumn.week:
        return 'Semana';
      case ReportColumn.department:
        return 'Departamento';
      case ReportColumn.createdByUser:
        return 'Usuario registrador';
      case ReportColumn.leader:
        return 'Líder';
      case ReportColumn.leaderCode:
        return 'Código líder';
      case ReportColumn.taskCode:
        return 'Código labor';
      case ReportColumn.task:
        return 'Labor';
      case ReportColumn.crop:
        return 'Cultivo';
      case ReportColumn.lot:
        return 'Lote';
      case ReportColumn.network:
        return 'Red';
      case ReportColumn.sector:
        return 'Sector';
      case ReportColumn.haSector:
        return 'Ha sector';
      case ReportColumn.haTotal:
        return 'Ha total';
      case ReportColumn.scheduledWage:
        return 'Jornal Programado';
      case ReportColumn.realWage:
        return 'Jornal Real';
      case ReportColumn.ratio:
        return 'Ratio';
      case ReportColumn.diningRoom:
        return 'Comedor';
      case ReportColumn.observation:
        return 'Observación';
    }
  }
}

const defaultReportColumns = <ReportColumn>[
  ReportColumn.date,
  ReportColumn.week,
  ReportColumn.department,
  ReportColumn.createdByUser,
  ReportColumn.leader,
  ReportColumn.leaderCode,
  ReportColumn.taskCode,
  ReportColumn.task,
  ReportColumn.crop,
  ReportColumn.lot,
  ReportColumn.network,
  ReportColumn.sector,
  ReportColumn.haSector,
  ReportColumn.haTotal,
  ReportColumn.scheduledWage,
  ReportColumn.realWage,
  ReportColumn.ratio,
  ReportColumn.diningRoom,
  ReportColumn.observation,
];
