// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RolesTable extends Roles with TableInfo<$RolesTable, LocalRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAdminMeta = const VerificationMeta(
    'isAdmin',
  );
  @override
  late final GeneratedColumn<bool> isAdmin = GeneratedColumn<bool>(
    'is_admin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_admin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isAdmin,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_admin')) {
      context.handle(
        _isAdminMeta,
        isAdmin.isAcceptableOrUnknown(data['is_admin']!, _isAdminMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRole(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isAdmin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_admin'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class LocalRole extends DataClass implements Insertable<LocalRole> {
  final String id;
  final String name;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const LocalRole({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_admin'] = Variable<bool>(isAdmin);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      name: Value(name),
      isAdmin: Value(isAdmin),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRole(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isAdmin: serializer.fromJson<bool>(json['isAdmin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isAdmin': serializer.toJson<bool>(isAdmin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocalRole copyWith({
    String? id,
    String? name,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => LocalRole(
    id: id ?? this.id,
    name: name ?? this.name,
    isAdmin: isAdmin ?? this.isAdmin,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LocalRole copyWithCompanion(RolesCompanion data) {
    return LocalRole(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isAdmin: data.isAdmin.present ? data.isAdmin.value : this.isAdmin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRole(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    isAdmin,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRole &&
          other.id == this.id &&
          other.name == this.name &&
          other.isAdmin == this.isAdmin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class RolesCompanion extends UpdateCompanion<LocalRole> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isAdmin;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesCompanion.insert({
    required String id,
    required String name,
    this.isAdmin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<LocalRole> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isAdmin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isAdmin != null) 'is_admin': isAdmin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isAdmin,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isAdmin.present) {
      map['is_admin'] = Variable<bool>(isAdmin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CropsTable extends Crops with TableInfo<$CropsTable, Crop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    name,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crops';
  @override
  VerificationContext validateIntegrity(
    Insertable<Crop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Crop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Crop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $CropsTable createAlias(String alias) {
    return $CropsTable(attachedDatabase, alias);
  }
}

class Crop extends DataClass implements Insertable<Crop> {
  final String id;
  final String? serverId;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const Crop({
    required this.id,
    this.serverId,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CropsCompanion toCompanion(bool nullToAbsent) {
    return CropsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Crop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Crop(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Crop copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? name,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => Crop(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Crop copyWithCompanion(CropsCompanion data) {
    return Crop(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Crop(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    name,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crop &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class CropsCompanion extends UpdateCompanion<Crop> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CropsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CropsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Crop> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CropsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? name,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return CropsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, OperatorPosition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _canBeLeaderMeta = const VerificationMeta(
    'canBeLeader',
  );
  @override
  late final GeneratedColumn<bool> canBeLeader = GeneratedColumn<bool>(
    'can_be_leader',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_be_leader" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _canLoginMeta = const VerificationMeta(
    'canLogin',
  );
  @override
  late final GeneratedColumn<bool> canLogin = GeneratedColumn<bool>(
    'can_login',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_login" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    name,
    canBeLeader,
    canLogin,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<OperatorPosition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('can_be_leader')) {
      context.handle(
        _canBeLeaderMeta,
        canBeLeader.isAcceptableOrUnknown(
          data['can_be_leader']!,
          _canBeLeaderMeta,
        ),
      );
    }
    if (data.containsKey('can_login')) {
      context.handle(
        _canLoginMeta,
        canLogin.isAcceptableOrUnknown(data['can_login']!, _canLoginMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperatorPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperatorPosition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      canBeLeader: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}can_be_leader'],
      )!,
      canLogin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}can_login'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class OperatorPosition extends DataClass
    implements Insertable<OperatorPosition> {
  final String id;
  final String? serverId;
  final String name;
  final bool canBeLeader;
  final bool canLogin;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const OperatorPosition({
    required this.id,
    this.serverId,
    required this.name,
    required this.canBeLeader,
    required this.canLogin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['can_be_leader'] = Variable<bool>(canBeLeader);
    map['can_login'] = Variable<bool>(canLogin);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      canBeLeader: Value(canBeLeader),
      canLogin: Value(canLogin),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory OperatorPosition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperatorPosition(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      canBeLeader: serializer.fromJson<bool>(json['canBeLeader']),
      canLogin: serializer.fromJson<bool>(json['canLogin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'canBeLeader': serializer.toJson<bool>(canBeLeader),
      'canLogin': serializer.toJson<bool>(canLogin),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  OperatorPosition copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? name,
    bool? canBeLeader,
    bool? canLogin,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => OperatorPosition(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    canBeLeader: canBeLeader ?? this.canBeLeader,
    canLogin: canLogin ?? this.canLogin,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  OperatorPosition copyWithCompanion(PositionsCompanion data) {
    return OperatorPosition(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      canBeLeader: data.canBeLeader.present
          ? data.canBeLeader.value
          : this.canBeLeader,
      canLogin: data.canLogin.present ? data.canLogin.value : this.canLogin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperatorPosition(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('canBeLeader: $canBeLeader, ')
          ..write('canLogin: $canLogin, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    name,
    canBeLeader,
    canLogin,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperatorPosition &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.canBeLeader == this.canBeLeader &&
          other.canLogin == this.canLogin &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class PositionsCompanion extends UpdateCompanion<OperatorPosition> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<bool> canBeLeader;
  final Value<bool> canLogin;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.canBeLeader = const Value.absent(),
    this.canLogin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PositionsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String name,
    this.canBeLeader = const Value.absent(),
    this.canLogin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<OperatorPosition> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<bool>? canBeLeader,
    Expression<bool>? canLogin,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (canBeLeader != null) 'can_be_leader': canBeLeader,
      if (canLogin != null) 'can_login': canLogin,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PositionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? name,
    Value<bool>? canBeLeader,
    Value<bool>? canLogin,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return PositionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      canBeLeader: canBeLeader ?? this.canBeLeader,
      canLogin: canLogin ?? this.canLogin,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (canBeLeader.present) {
      map['can_be_leader'] = Variable<bool>(canBeLeader.value);
    }
    if (canLogin.present) {
      map['can_login'] = Variable<bool>(canLogin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('canBeLeader: $canBeLeader, ')
          ..write('canLogin: $canLogin, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<String> cropId = GeneratedColumn<String>(
    'crop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    name,
    cropId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final String? serverId;
  final String name;
  final String? cropId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const Department({
    required this.id,
    this.serverId,
    required this.name,
    this.cropId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || cropId != null) {
      map['crop_id'] = Variable<String>(cropId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      cropId: cropId == null && nullToAbsent
          ? const Value.absent()
          : Value(cropId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      cropId: serializer.fromJson<String?>(json['cropId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'cropId': serializer.toJson<String?>(cropId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Department copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? name,
    Value<String?> cropId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => Department(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    cropId: cropId.present ? cropId.value : this.cropId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('cropId: $cropId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    name,
    cropId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.cropId == this.cropId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<String?> cropId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.cropId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String name,
    this.cropId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? cropId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (cropId != null) 'crop_id': cropId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? name,
    Value<String?>? cropId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      cropId: cropId ?? this.cropId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<String>(cropId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('cropId: $cropId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OperatorsTable extends Operators
    with TableInfo<$OperatorsTable, FarmOperator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperatorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 6,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _positionIdMeta = const VerificationMeta(
    'positionId',
  );
  @override
  late final GeneratedColumn<String> positionId = GeneratedColumn<String>(
    'position_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES positions (id)',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    code,
    fullName,
    departmentId,
    positionId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operators';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmOperator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('position_id')) {
      context.handle(
        _positionIdMeta,
        positionId.isAcceptableOrUnknown(data['position_id']!, _positionIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmOperator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmOperator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      ),
      positionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $OperatorsTable createAlias(String alias) {
    return $OperatorsTable(attachedDatabase, alias);
  }
}

class FarmOperator extends DataClass implements Insertable<FarmOperator> {
  final String id;
  final String? serverId;
  final String code;
  final String fullName;
  final String? departmentId;
  final String? positionId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const FarmOperator({
    required this.id,
    this.serverId,
    required this.code,
    required this.fullName,
    this.departmentId,
    this.positionId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['code'] = Variable<String>(code);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    if (!nullToAbsent || positionId != null) {
      map['position_id'] = Variable<String>(positionId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  OperatorsCompanion toCompanion(bool nullToAbsent) {
    return OperatorsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      code: Value(code),
      fullName: Value(fullName),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      positionId: positionId == null && nullToAbsent
          ? const Value.absent()
          : Value(positionId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory FarmOperator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmOperator(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      code: serializer.fromJson<String>(json['code']),
      fullName: serializer.fromJson<String>(json['fullName']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      positionId: serializer.fromJson<String?>(json['positionId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'code': serializer.toJson<String>(code),
      'fullName': serializer.toJson<String>(fullName),
      'departmentId': serializer.toJson<String?>(departmentId),
      'positionId': serializer.toJson<String?>(positionId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FarmOperator copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? code,
    String? fullName,
    Value<String?> departmentId = const Value.absent(),
    Value<String?> positionId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => FarmOperator(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    code: code ?? this.code,
    fullName: fullName ?? this.fullName,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    positionId: positionId.present ? positionId.value : this.positionId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FarmOperator copyWithCompanion(OperatorsCompanion data) {
    return FarmOperator(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      code: data.code.present ? data.code.value : this.code,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      positionId: data.positionId.present
          ? data.positionId.value
          : this.positionId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmOperator(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('code: $code, ')
          ..write('fullName: $fullName, ')
          ..write('departmentId: $departmentId, ')
          ..write('positionId: $positionId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    code,
    fullName,
    departmentId,
    positionId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmOperator &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.code == this.code &&
          other.fullName == this.fullName &&
          other.departmentId == this.departmentId &&
          other.positionId == this.positionId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class OperatorsCompanion extends UpdateCompanion<FarmOperator> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> code;
  final Value<String> fullName;
  final Value<String?> departmentId;
  final Value<String?> positionId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const OperatorsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.code = const Value.absent(),
    this.fullName = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.positionId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OperatorsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String code,
    required String fullName,
    this.departmentId = const Value.absent(),
    this.positionId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       fullName = Value(fullName);
  static Insertable<FarmOperator> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? code,
    Expression<String>? fullName,
    Expression<String>? departmentId,
    Expression<String>? positionId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (code != null) 'code': code,
      if (fullName != null) 'full_name': fullName,
      if (departmentId != null) 'department_id': departmentId,
      if (positionId != null) 'position_id': positionId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OperatorsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? code,
    Value<String>? fullName,
    Value<String?>? departmentId,
    Value<String?>? positionId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return OperatorsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      departmentId: departmentId ?? this.departmentId,
      positionId: positionId ?? this.positionId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<String>(positionId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperatorsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('code: $code, ')
          ..write('fullName: $fullName, ')
          ..write('departmentId: $departmentId, ')
          ..write('positionId: $positionId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 6,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordPinMeta = const VerificationMeta(
    'passwordPin',
  );
  @override
  late final GeneratedColumn<String> passwordPin = GeneratedColumn<String>(
    'password_pin',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 6,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
    'role_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES roles (id)',
    ),
  );
  static const VerificationMeta _operatorIdMeta = const VerificationMeta(
    'operatorId',
  );
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
    'operator_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES operators (id)',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    code,
    fullName,
    passwordPin,
    roleId,
    operatorId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('password_pin')) {
      context.handle(
        _passwordPinMeta,
        passwordPin.isAcceptableOrUnknown(
          data['password_pin']!,
          _passwordPinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordPinMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
        _operatorIdMeta,
        operatorId.isAcceptableOrUnknown(data['operator_id']!, _operatorIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      passwordPin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_pin'],
      )!,
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_id'],
      )!,
      operatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String? serverId;
  final String code;
  final String fullName;
  final String passwordPin;
  final String roleId;
  final String? operatorId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const LocalUser({
    required this.id,
    this.serverId,
    required this.code,
    required this.fullName,
    required this.passwordPin,
    required this.roleId,
    this.operatorId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['code'] = Variable<String>(code);
    map['full_name'] = Variable<String>(fullName);
    map['password_pin'] = Variable<String>(passwordPin);
    map['role_id'] = Variable<String>(roleId);
    if (!nullToAbsent || operatorId != null) {
      map['operator_id'] = Variable<String>(operatorId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      code: Value(code),
      fullName: Value(fullName),
      passwordPin: Value(passwordPin),
      roleId: Value(roleId),
      operatorId: operatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(operatorId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      code: serializer.fromJson<String>(json['code']),
      fullName: serializer.fromJson<String>(json['fullName']),
      passwordPin: serializer.fromJson<String>(json['passwordPin']),
      roleId: serializer.fromJson<String>(json['roleId']),
      operatorId: serializer.fromJson<String?>(json['operatorId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'code': serializer.toJson<String>(code),
      'fullName': serializer.toJson<String>(fullName),
      'passwordPin': serializer.toJson<String>(passwordPin),
      'roleId': serializer.toJson<String>(roleId),
      'operatorId': serializer.toJson<String?>(operatorId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocalUser copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? code,
    String? fullName,
    String? passwordPin,
    String? roleId,
    Value<String?> operatorId = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => LocalUser(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    code: code ?? this.code,
    fullName: fullName ?? this.fullName,
    passwordPin: passwordPin ?? this.passwordPin,
    roleId: roleId ?? this.roleId,
    operatorId: operatorId.present ? operatorId.value : this.operatorId,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LocalUser copyWithCompanion(UsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      code: data.code.present ? data.code.value : this.code,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      passwordPin: data.passwordPin.present
          ? data.passwordPin.value
          : this.passwordPin,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      operatorId: data.operatorId.present
          ? data.operatorId.value
          : this.operatorId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('code: $code, ')
          ..write('fullName: $fullName, ')
          ..write('passwordPin: $passwordPin, ')
          ..write('roleId: $roleId, ')
          ..write('operatorId: $operatorId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    code,
    fullName,
    passwordPin,
    roleId,
    operatorId,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.code == this.code &&
          other.fullName == this.fullName &&
          other.passwordPin == this.passwordPin &&
          other.roleId == this.roleId &&
          other.operatorId == this.operatorId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class UsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> code;
  final Value<String> fullName;
  final Value<String> passwordPin;
  final Value<String> roleId;
  final Value<String?> operatorId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.code = const Value.absent(),
    this.fullName = const Value.absent(),
    this.passwordPin = const Value.absent(),
    this.roleId = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String code,
    required String fullName,
    required String passwordPin,
    required String roleId,
    this.operatorId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       fullName = Value(fullName),
       passwordPin = Value(passwordPin),
       roleId = Value(roleId);
  static Insertable<LocalUser> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? code,
    Expression<String>? fullName,
    Expression<String>? passwordPin,
    Expression<String>? roleId,
    Expression<String>? operatorId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (code != null) 'code': code,
      if (fullName != null) 'full_name': fullName,
      if (passwordPin != null) 'password_pin': passwordPin,
      if (roleId != null) 'role_id': roleId,
      if (operatorId != null) 'operator_id': operatorId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? code,
    Value<String>? fullName,
    Value<String>? passwordPin,
    Value<String>? roleId,
    Value<String?>? operatorId,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      passwordPin: passwordPin ?? this.passwordPin,
      roleId: roleId ?? this.roleId,
      operatorId: operatorId ?? this.operatorId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (passwordPin.present) {
      map['password_pin'] = Variable<String>(passwordPin.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('code: $code, ')
          ..write('fullName: $fullName, ')
          ..write('passwordPin: $passwordPin, ')
          ..write('roleId: $roleId, ')
          ..write('operatorId: $operatorId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserDepartmentsTable extends UserDepartments
    with TableInfo<$UserDepartmentsTable, UserDepartment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserDepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    departmentId,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserDepartment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserDepartment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserDepartment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UserDepartmentsTable createAlias(String alias) {
    return $UserDepartmentsTable(attachedDatabase, alias);
  }
}

class UserDepartment extends DataClass implements Insertable<UserDepartment> {
  final String id;
  final String userId;
  final String departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const UserDepartment({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['department_id'] = Variable<String>(departmentId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  UserDepartmentsCompanion toCompanion(bool nullToAbsent) {
    return UserDepartmentsCompanion(
      id: Value(id),
      userId: Value(userId),
      departmentId: Value(departmentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory UserDepartment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserDepartment(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'departmentId': serializer.toJson<String>(departmentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  UserDepartment copyWith({
    String? id,
    String? userId,
    String? departmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => UserDepartment(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    departmentId: departmentId ?? this.departmentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  UserDepartment copyWithCompanion(UserDepartmentsCompanion data) {
    return UserDepartment(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserDepartment(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('departmentId: $departmentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    departmentId,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDepartment &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.departmentId == this.departmentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class UserDepartmentsCompanion extends UpdateCompanion<UserDepartment> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> departmentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const UserDepartmentsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserDepartmentsCompanion.insert({
    required String id,
    required String userId,
    required String departmentId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       departmentId = Value(departmentId);
  static Insertable<UserDepartment> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? departmentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (departmentId != null) 'department_id': departmentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserDepartmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? departmentId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return UserDepartmentsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserDepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('departmentId: $departmentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, FarmTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<String> cropId = GeneratedColumn<String>(
    'crop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultDetailMeta = const VerificationMeta(
    'defaultDetail',
  );
  @override
  late final GeneratedColumn<String> defaultDetail = GeneratedColumn<String>(
    'default_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    departmentId,
    cropId,
    code,
    name,
    defaultDetail,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_detail')) {
      context.handle(
        _defaultDetailMeta,
        defaultDetail.isAcceptableOrUnknown(
          data['default_detail']!,
          _defaultDetailMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      ),
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_detail'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class FarmTask extends DataClass implements Insertable<FarmTask> {
  final String id;
  final String? serverId;
  final String? departmentId;
  final String? cropId;
  final String? code;
  final String name;
  final String? defaultDetail;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const FarmTask({
    required this.id,
    this.serverId,
    this.departmentId,
    this.cropId,
    this.code,
    required this.name,
    this.defaultDetail,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    if (!nullToAbsent || cropId != null) {
      map['crop_id'] = Variable<String>(cropId);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || defaultDetail != null) {
      map['default_detail'] = Variable<String>(defaultDetail);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      cropId: cropId == null && nullToAbsent
          ? const Value.absent()
          : Value(cropId),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      defaultDetail: defaultDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultDetail),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory FarmTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmTask(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      cropId: serializer.fromJson<String?>(json['cropId']),
      code: serializer.fromJson<String?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      defaultDetail: serializer.fromJson<String?>(json['defaultDetail']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'departmentId': serializer.toJson<String?>(departmentId),
      'cropId': serializer.toJson<String?>(cropId),
      'code': serializer.toJson<String?>(code),
      'name': serializer.toJson<String>(name),
      'defaultDetail': serializer.toJson<String?>(defaultDetail),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FarmTask copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    Value<String?> departmentId = const Value.absent(),
    Value<String?> cropId = const Value.absent(),
    Value<String?> code = const Value.absent(),
    String? name,
    Value<String?> defaultDetail = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => FarmTask(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    cropId: cropId.present ? cropId.value : this.cropId,
    code: code.present ? code.value : this.code,
    name: name ?? this.name,
    defaultDetail: defaultDetail.present
        ? defaultDetail.value
        : this.defaultDetail,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FarmTask copyWithCompanion(TasksCompanion data) {
    return FarmTask(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      defaultDetail: data.defaultDetail.present
          ? data.defaultDetail.value
          : this.defaultDetail,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmTask(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('departmentId: $departmentId, ')
          ..write('cropId: $cropId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('defaultDetail: $defaultDetail, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    departmentId,
    cropId,
    code,
    name,
    defaultDetail,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmTask &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.departmentId == this.departmentId &&
          other.cropId == this.cropId &&
          other.code == this.code &&
          other.name == this.name &&
          other.defaultDetail == this.defaultDetail &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class TasksCompanion extends UpdateCompanion<FarmTask> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String?> departmentId;
  final Value<String?> cropId;
  final Value<String?> code;
  final Value<String> name;
  final Value<String?> defaultDetail;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultDetail = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.code = const Value.absent(),
    required String name,
    this.defaultDetail = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<FarmTask> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? departmentId,
    Expression<String>? cropId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? defaultDetail,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (departmentId != null) 'department_id': departmentId,
      if (cropId != null) 'crop_id': cropId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (defaultDetail != null) 'default_detail': defaultDetail,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String?>? departmentId,
    Value<String?>? cropId,
    Value<String?>? code,
    Value<String>? name,
    Value<String?>? defaultDetail,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      departmentId: departmentId ?? this.departmentId,
      cropId: cropId ?? this.cropId,
      code: code ?? this.code,
      name: name ?? this.name,
      defaultDetail: defaultDetail ?? this.defaultDetail,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<String>(cropId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultDetail.present) {
      map['default_detail'] = Variable<String>(defaultDetail.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('departmentId: $departmentId, ')
          ..write('cropId: $cropId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('defaultDetail: $defaultDetail, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, LocationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<String> cropId = GeneratedColumn<String>(
    'crop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _lotMeta = const VerificationMeta('lot');
  @override
  late final GeneratedColumn<String> lot = GeneratedColumn<String>(
    'lot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
    'sector',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmTypeMeta = const VerificationMeta(
    'farmType',
  );
  @override
  late final GeneratedColumn<String> farmType = GeneratedColumn<String>(
    'farm_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _haMeta = const VerificationMeta('ha');
  @override
  late final GeneratedColumn<double> ha = GeneratedColumn<double>(
    'ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suggestedDiningRoomMeta =
      const VerificationMeta('suggestedDiningRoom');
  @override
  late final GeneratedColumn<String> suggestedDiningRoom =
      GeneratedColumn<String>(
        'suggested_dining_room',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    cropId,
    lot,
    network,
    sector,
    farmType,
    ha,
    suggestedDiningRoom,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cropIdMeta);
    }
    if (data.containsKey('lot')) {
      context.handle(
        _lotMeta,
        lot.isAcceptableOrUnknown(data['lot']!, _lotMeta),
      );
    } else if (isInserting) {
      context.missing(_lotMeta);
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('sector')) {
      context.handle(
        _sectorMeta,
        sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta),
      );
    } else if (isInserting) {
      context.missing(_sectorMeta);
    }
    if (data.containsKey('farm_type')) {
      context.handle(
        _farmTypeMeta,
        farmType.isAcceptableOrUnknown(data['farm_type']!, _farmTypeMeta),
      );
    }
    if (data.containsKey('ha')) {
      context.handle(_haMeta, ha.isAcceptableOrUnknown(data['ha']!, _haMeta));
    } else if (isInserting) {
      context.missing(_haMeta);
    }
    if (data.containsKey('suggested_dining_room')) {
      context.handle(
        _suggestedDiningRoomMeta,
        suggestedDiningRoom.isAcceptableOrUnknown(
          data['suggested_dining_room']!,
          _suggestedDiningRoomMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_id'],
      )!,
      lot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot'],
      )!,
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      sector: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector'],
      )!,
      farmType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farm_type'],
      ),
      ha: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ha'],
      )!,
      suggestedDiningRoom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_dining_room'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class LocationEntry extends DataClass implements Insertable<LocationEntry> {
  final String id;
  final String? serverId;
  final String cropId;
  final String lot;
  final String network;
  final String sector;
  final String? farmType;
  final double ha;
  final String? suggestedDiningRoom;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const LocationEntry({
    required this.id,
    this.serverId,
    required this.cropId,
    required this.lot,
    required this.network,
    required this.sector,
    this.farmType,
    required this.ha,
    this.suggestedDiningRoom,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['crop_id'] = Variable<String>(cropId);
    map['lot'] = Variable<String>(lot);
    map['network'] = Variable<String>(network);
    map['sector'] = Variable<String>(sector);
    if (!nullToAbsent || farmType != null) {
      map['farm_type'] = Variable<String>(farmType);
    }
    map['ha'] = Variable<double>(ha);
    if (!nullToAbsent || suggestedDiningRoom != null) {
      map['suggested_dining_room'] = Variable<String>(suggestedDiningRoom);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      cropId: Value(cropId),
      lot: Value(lot),
      network: Value(network),
      sector: Value(sector),
      farmType: farmType == null && nullToAbsent
          ? const Value.absent()
          : Value(farmType),
      ha: Value(ha),
      suggestedDiningRoom: suggestedDiningRoom == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedDiningRoom),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationEntry(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      cropId: serializer.fromJson<String>(json['cropId']),
      lot: serializer.fromJson<String>(json['lot']),
      network: serializer.fromJson<String>(json['network']),
      sector: serializer.fromJson<String>(json['sector']),
      farmType: serializer.fromJson<String?>(json['farmType']),
      ha: serializer.fromJson<double>(json['ha']),
      suggestedDiningRoom: serializer.fromJson<String?>(
        json['suggestedDiningRoom'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'cropId': serializer.toJson<String>(cropId),
      'lot': serializer.toJson<String>(lot),
      'network': serializer.toJson<String>(network),
      'sector': serializer.toJson<String>(sector),
      'farmType': serializer.toJson<String?>(farmType),
      'ha': serializer.toJson<double>(ha),
      'suggestedDiningRoom': serializer.toJson<String?>(suggestedDiningRoom),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocationEntry copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? cropId,
    String? lot,
    String? network,
    String? sector,
    Value<String?> farmType = const Value.absent(),
    double? ha,
    Value<String?> suggestedDiningRoom = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => LocationEntry(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    cropId: cropId ?? this.cropId,
    lot: lot ?? this.lot,
    network: network ?? this.network,
    sector: sector ?? this.sector,
    farmType: farmType.present ? farmType.value : this.farmType,
    ha: ha ?? this.ha,
    suggestedDiningRoom: suggestedDiningRoom.present
        ? suggestedDiningRoom.value
        : this.suggestedDiningRoom,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LocationEntry copyWithCompanion(LocationsCompanion data) {
    return LocationEntry(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      lot: data.lot.present ? data.lot.value : this.lot,
      network: data.network.present ? data.network.value : this.network,
      sector: data.sector.present ? data.sector.value : this.sector,
      farmType: data.farmType.present ? data.farmType.value : this.farmType,
      ha: data.ha.present ? data.ha.value : this.ha,
      suggestedDiningRoom: data.suggestedDiningRoom.present
          ? data.suggestedDiningRoom.value
          : this.suggestedDiningRoom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationEntry(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('cropId: $cropId, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('sector: $sector, ')
          ..write('farmType: $farmType, ')
          ..write('ha: $ha, ')
          ..write('suggestedDiningRoom: $suggestedDiningRoom, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    cropId,
    lot,
    network,
    sector,
    farmType,
    ha,
    suggestedDiningRoom,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationEntry &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.cropId == this.cropId &&
          other.lot == this.lot &&
          other.network == this.network &&
          other.sector == this.sector &&
          other.farmType == this.farmType &&
          other.ha == this.ha &&
          other.suggestedDiningRoom == this.suggestedDiningRoom &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class LocationsCompanion extends UpdateCompanion<LocationEntry> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> cropId;
  final Value<String> lot;
  final Value<String> network;
  final Value<String> sector;
  final Value<String?> farmType;
  final Value<double> ha;
  final Value<String?> suggestedDiningRoom;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.lot = const Value.absent(),
    this.network = const Value.absent(),
    this.sector = const Value.absent(),
    this.farmType = const Value.absent(),
    this.ha = const Value.absent(),
    this.suggestedDiningRoom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String cropId,
    required String lot,
    required String network,
    required String sector,
    this.farmType = const Value.absent(),
    required double ha,
    this.suggestedDiningRoom = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cropId = Value(cropId),
       lot = Value(lot),
       network = Value(network),
       sector = Value(sector),
       ha = Value(ha);
  static Insertable<LocationEntry> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? cropId,
    Expression<String>? lot,
    Expression<String>? network,
    Expression<String>? sector,
    Expression<String>? farmType,
    Expression<double>? ha,
    Expression<String>? suggestedDiningRoom,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (cropId != null) 'crop_id': cropId,
      if (lot != null) 'lot': lot,
      if (network != null) 'network': network,
      if (sector != null) 'sector': sector,
      if (farmType != null) 'farm_type': farmType,
      if (ha != null) 'ha': ha,
      if (suggestedDiningRoom != null)
        'suggested_dining_room': suggestedDiningRoom,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? cropId,
    Value<String>? lot,
    Value<String>? network,
    Value<String>? sector,
    Value<String?>? farmType,
    Value<double>? ha,
    Value<String?>? suggestedDiningRoom,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      cropId: cropId ?? this.cropId,
      lot: lot ?? this.lot,
      network: network ?? this.network,
      sector: sector ?? this.sector,
      farmType: farmType ?? this.farmType,
      ha: ha ?? this.ha,
      suggestedDiningRoom: suggestedDiningRoom ?? this.suggestedDiningRoom,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<String>(cropId.value);
    }
    if (lot.present) {
      map['lot'] = Variable<String>(lot.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (farmType.present) {
      map['farm_type'] = Variable<String>(farmType.value);
    }
    if (ha.present) {
      map['ha'] = Variable<double>(ha.value);
    }
    if (suggestedDiningRoom.present) {
      map['suggested_dining_room'] = Variable<String>(
        suggestedDiningRoom.value,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('cropId: $cropId, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('sector: $sector, ')
          ..write('farmType: $farmType, ')
          ..write('ha: $ha, ')
          ..write('suggestedDiningRoom: $suggestedDiningRoom, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiningRoomsTable extends DiningRooms
    with TableInfo<$DiningRoomsTable, DiningRoom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiningRoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<String> cropId = GeneratedColumn<String>(
    'crop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lotMeta = const VerificationMeta('lot');
  @override
  late final GeneratedColumn<String> lot = GeneratedColumn<String>(
    'lot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    cropId,
    name,
    lot,
    network,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dining_rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiningRoom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cropIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lot')) {
      context.handle(
        _lotMeta,
        lot.isAcceptableOrUnknown(data['lot']!, _lotMeta),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiningRoom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiningRoom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot'],
      ),
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $DiningRoomsTable createAlias(String alias) {
    return $DiningRoomsTable(attachedDatabase, alias);
  }
}

class DiningRoom extends DataClass implements Insertable<DiningRoom> {
  final String id;
  final String? serverId;
  final String cropId;
  final String name;
  final String? lot;
  final String? network;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const DiningRoom({
    required this.id,
    this.serverId,
    required this.cropId,
    required this.name,
    this.lot,
    this.network,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['crop_id'] = Variable<String>(cropId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lot != null) {
      map['lot'] = Variable<String>(lot);
    }
    if (!nullToAbsent || network != null) {
      map['network'] = Variable<String>(network);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  DiningRoomsCompanion toCompanion(bool nullToAbsent) {
    return DiningRoomsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      cropId: Value(cropId),
      name: Value(name),
      lot: lot == null && nullToAbsent ? const Value.absent() : Value(lot),
      network: network == null && nullToAbsent
          ? const Value.absent()
          : Value(network),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory DiningRoom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiningRoom(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      cropId: serializer.fromJson<String>(json['cropId']),
      name: serializer.fromJson<String>(json['name']),
      lot: serializer.fromJson<String?>(json['lot']),
      network: serializer.fromJson<String?>(json['network']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'cropId': serializer.toJson<String>(cropId),
      'name': serializer.toJson<String>(name),
      'lot': serializer.toJson<String?>(lot),
      'network': serializer.toJson<String?>(network),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  DiningRoom copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? cropId,
    String? name,
    Value<String?> lot = const Value.absent(),
    Value<String?> network = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => DiningRoom(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    cropId: cropId ?? this.cropId,
    name: name ?? this.name,
    lot: lot.present ? lot.value : this.lot,
    network: network.present ? network.value : this.network,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  DiningRoom copyWithCompanion(DiningRoomsCompanion data) {
    return DiningRoom(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      name: data.name.present ? data.name.value : this.name,
      lot: data.lot.present ? data.lot.value : this.lot,
      network: data.network.present ? data.network.value : this.network,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiningRoom(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    cropId,
    name,
    lot,
    network,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiningRoom &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.cropId == this.cropId &&
          other.name == this.name &&
          other.lot == this.lot &&
          other.network == this.network &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class DiningRoomsCompanion extends UpdateCompanion<DiningRoom> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> cropId;
  final Value<String> name;
  final Value<String?> lot;
  final Value<String?> network;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const DiningRoomsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.cropId = const Value.absent(),
    this.name = const Value.absent(),
    this.lot = const Value.absent(),
    this.network = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiningRoomsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String cropId,
    required String name,
    this.lot = const Value.absent(),
    this.network = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cropId = Value(cropId),
       name = Value(name);
  static Insertable<DiningRoom> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? cropId,
    Expression<String>? name,
    Expression<String>? lot,
    Expression<String>? network,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (cropId != null) 'crop_id': cropId,
      if (name != null) 'name': name,
      if (lot != null) 'lot': lot,
      if (network != null) 'network': network,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiningRoomsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? cropId,
    Value<String>? name,
    Value<String?>? lot,
    Value<String?>? network,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return DiningRoomsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      cropId: cropId ?? this.cropId,
      name: name ?? this.name,
      lot: lot ?? this.lot,
      network: network ?? this.network,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<String>(cropId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lot.present) {
      map['lot'] = Variable<String>(lot.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiningRoomsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('cropId: $cropId, ')
          ..write('name: $name, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, FarmRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordDateMeta = const VerificationMeta(
    'recordDate',
  );
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
    'record_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _userCodeMeta = const VerificationMeta(
    'userCode',
  );
  @override
  late final GeneratedColumn<String> userCode = GeneratedColumn<String>(
    'user_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatorIdMeta = const VerificationMeta(
    'operatorId',
  );
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
    'operator_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES operators (id)',
    ),
  );
  static const VerificationMeta _operatorNameSnapshotMeta =
      const VerificationMeta('operatorNameSnapshot');
  @override
  late final GeneratedColumn<String> operatorNameSnapshot =
      GeneratedColumn<String>(
        'operator_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _leaderOperatorIdMeta = const VerificationMeta(
    'leaderOperatorId',
  );
  @override
  late final GeneratedColumn<String> leaderOperatorId = GeneratedColumn<String>(
    'leader_operator_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES operators (id)',
    ),
  );
  static const VerificationMeta _leaderCodeSnapshotMeta =
      const VerificationMeta('leaderCodeSnapshot');
  @override
  late final GeneratedColumn<String> leaderCodeSnapshot =
      GeneratedColumn<String>(
        'leader_code_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _leaderNameSnapshotMeta =
      const VerificationMeta('leaderNameSnapshot');
  @override
  late final GeneratedColumn<String> leaderNameSnapshot =
      GeneratedColumn<String>(
        'leader_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cropIdMeta = const VerificationMeta('cropId');
  @override
  late final GeneratedColumn<String> cropId = GeneratedColumn<String>(
    'crop_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES crops (id)',
    ),
  );
  static const VerificationMeta _cropNameSnapshotMeta = const VerificationMeta(
    'cropNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> cropNameSnapshot = GeneratedColumn<String>(
    'crop_name_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _taskCodeSnapshotMeta = const VerificationMeta(
    'taskCodeSnapshot',
  );
  @override
  late final GeneratedColumn<String> taskCodeSnapshot = GeneratedColumn<String>(
    'task_code_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskNameSnapshotMeta = const VerificationMeta(
    'taskNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> taskNameSnapshot = GeneratedColumn<String>(
    'task_name_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskDetailMeta = const VerificationMeta(
    'taskDetail',
  );
  @override
  late final GeneratedColumn<String> taskDetail = GeneratedColumn<String>(
    'task_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lotMeta = const VerificationMeta('lot');
  @override
  late final GeneratedColumn<String> lot = GeneratedColumn<String>(
    'lot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledWageMeta = const VerificationMeta(
    'scheduledWage',
  );
  @override
  late final GeneratedColumn<double> scheduledWage = GeneratedColumn<double>(
    'scheduled_wage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _realWageMeta = const VerificationMeta(
    'realWage',
  );
  @override
  late final GeneratedColumn<double> realWage = GeneratedColumn<double>(
    'real_wage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _haMeta = const VerificationMeta('ha');
  @override
  late final GeneratedColumn<double> ha = GeneratedColumn<double>(
    'ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  @override
  late final GeneratedColumn<double> ratio = GeneratedColumn<double>(
    'ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diningRoomIdMeta = const VerificationMeta(
    'diningRoomId',
  );
  @override
  late final GeneratedColumn<String> diningRoomId = GeneratedColumn<String>(
    'dining_room_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dining_rooms (id)',
    ),
  );
  static const VerificationMeta _diningRoomMeta = const VerificationMeta(
    'diningRoom',
  );
  @override
  late final GeneratedColumn<String> diningRoom = GeneratedColumn<String>(
    'dining_room',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observationMeta = const VerificationMeta(
    'observation',
  );
  @override
  late final GeneratedColumn<String> observation = GeneratedColumn<String>(
    'observation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraFieldsJsonMeta = const VerificationMeta(
    'extraFieldsJson',
  );
  @override
  late final GeneratedColumn<String> extraFieldsJson = GeneratedColumn<String>(
    'extra_fields_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    recordDate,
    weekNumber,
    departmentId,
    createdByUserId,
    userCode,
    operatorId,
    operatorNameSnapshot,
    leaderOperatorId,
    leaderCodeSnapshot,
    leaderNameSnapshot,
    cropId,
    cropNameSnapshot,
    taskId,
    taskCodeSnapshot,
    taskNameSnapshot,
    taskDetail,
    lot,
    network,
    scheduledWage,
    realWage,
    ha,
    ratio,
    diningRoomId,
    diningRoom,
    observation,
    extraFieldsJson,
    isActive,
    isLocked,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('record_date')) {
      context.handle(
        _recordDateMeta,
        recordDate.isAcceptableOrUnknown(data['record_date']!, _recordDateMeta),
      );
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByUserIdMeta);
    }
    if (data.containsKey('user_code')) {
      context.handle(
        _userCodeMeta,
        userCode.isAcceptableOrUnknown(data['user_code']!, _userCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_userCodeMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
        _operatorIdMeta,
        operatorId.isAcceptableOrUnknown(data['operator_id']!, _operatorIdMeta),
      );
    }
    if (data.containsKey('operator_name_snapshot')) {
      context.handle(
        _operatorNameSnapshotMeta,
        operatorNameSnapshot.isAcceptableOrUnknown(
          data['operator_name_snapshot']!,
          _operatorNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('leader_operator_id')) {
      context.handle(
        _leaderOperatorIdMeta,
        leaderOperatorId.isAcceptableOrUnknown(
          data['leader_operator_id']!,
          _leaderOperatorIdMeta,
        ),
      );
    }
    if (data.containsKey('leader_code_snapshot')) {
      context.handle(
        _leaderCodeSnapshotMeta,
        leaderCodeSnapshot.isAcceptableOrUnknown(
          data['leader_code_snapshot']!,
          _leaderCodeSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('leader_name_snapshot')) {
      context.handle(
        _leaderNameSnapshotMeta,
        leaderNameSnapshot.isAcceptableOrUnknown(
          data['leader_name_snapshot']!,
          _leaderNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('crop_id')) {
      context.handle(
        _cropIdMeta,
        cropId.isAcceptableOrUnknown(data['crop_id']!, _cropIdMeta),
      );
    }
    if (data.containsKey('crop_name_snapshot')) {
      context.handle(
        _cropNameSnapshotMeta,
        cropNameSnapshot.isAcceptableOrUnknown(
          data['crop_name_snapshot']!,
          _cropNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('task_code_snapshot')) {
      context.handle(
        _taskCodeSnapshotMeta,
        taskCodeSnapshot.isAcceptableOrUnknown(
          data['task_code_snapshot']!,
          _taskCodeSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('task_name_snapshot')) {
      context.handle(
        _taskNameSnapshotMeta,
        taskNameSnapshot.isAcceptableOrUnknown(
          data['task_name_snapshot']!,
          _taskNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('task_detail')) {
      context.handle(
        _taskDetailMeta,
        taskDetail.isAcceptableOrUnknown(data['task_detail']!, _taskDetailMeta),
      );
    }
    if (data.containsKey('lot')) {
      context.handle(
        _lotMeta,
        lot.isAcceptableOrUnknown(data['lot']!, _lotMeta),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    }
    if (data.containsKey('scheduled_wage')) {
      context.handle(
        _scheduledWageMeta,
        scheduledWage.isAcceptableOrUnknown(
          data['scheduled_wage']!,
          _scheduledWageMeta,
        ),
      );
    }
    if (data.containsKey('real_wage')) {
      context.handle(
        _realWageMeta,
        realWage.isAcceptableOrUnknown(data['real_wage']!, _realWageMeta),
      );
    }
    if (data.containsKey('ha')) {
      context.handle(_haMeta, ha.isAcceptableOrUnknown(data['ha']!, _haMeta));
    }
    if (data.containsKey('ratio')) {
      context.handle(
        _ratioMeta,
        ratio.isAcceptableOrUnknown(data['ratio']!, _ratioMeta),
      );
    }
    if (data.containsKey('dining_room_id')) {
      context.handle(
        _diningRoomIdMeta,
        diningRoomId.isAcceptableOrUnknown(
          data['dining_room_id']!,
          _diningRoomIdMeta,
        ),
      );
    }
    if (data.containsKey('dining_room')) {
      context.handle(
        _diningRoomMeta,
        diningRoom.isAcceptableOrUnknown(data['dining_room']!, _diningRoomMeta),
      );
    }
    if (data.containsKey('observation')) {
      context.handle(
        _observationMeta,
        observation.isAcceptableOrUnknown(
          data['observation']!,
          _observationMeta,
        ),
      );
    }
    if (data.containsKey('extra_fields_json')) {
      context.handle(
        _extraFieldsJsonMeta,
        extraFieldsJson.isAcceptableOrUnknown(
          data['extra_fields_json']!,
          _extraFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      recordDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_date'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      )!,
      userCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_code'],
      )!,
      operatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_id'],
      ),
      operatorNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_name_snapshot'],
      ),
      leaderOperatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_operator_id'],
      ),
      leaderCodeSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_code_snapshot'],
      ),
      leaderNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leader_name_snapshot'],
      ),
      cropId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_id'],
      ),
      cropNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_name_snapshot'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      taskCodeSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_code_snapshot'],
      ),
      taskNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_name_snapshot'],
      ),
      taskDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_detail'],
      ),
      lot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot'],
      ),
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      ),
      scheduledWage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scheduled_wage'],
      ),
      realWage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}real_wage'],
      ),
      ha: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ha'],
      )!,
      ratio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ratio'],
      ),
      diningRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_room_id'],
      ),
      diningRoom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dining_room'],
      ),
      observation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation'],
      ),
      extraFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_fields_json'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class FarmRecord extends DataClass implements Insertable<FarmRecord> {
  final String id;
  final String? serverId;
  final DateTime recordDate;
  final int weekNumber;
  final String departmentId;
  final String createdByUserId;
  final String userCode;
  final String? operatorId;
  final String? operatorNameSnapshot;
  final String? leaderOperatorId;
  final String? leaderCodeSnapshot;
  final String? leaderNameSnapshot;
  final String? cropId;
  final String? cropNameSnapshot;
  final String? taskId;
  final String? taskCodeSnapshot;
  final String? taskNameSnapshot;
  final String? taskDetail;
  final String? lot;
  final String? network;
  final double? scheduledWage;
  final double? realWage;
  final double ha;
  final double? ratio;
  final String? diningRoomId;
  final String? diningRoom;
  final String? observation;
  final String? extraFieldsJson;
  final bool isActive;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const FarmRecord({
    required this.id,
    this.serverId,
    required this.recordDate,
    required this.weekNumber,
    required this.departmentId,
    required this.createdByUserId,
    required this.userCode,
    this.operatorId,
    this.operatorNameSnapshot,
    this.leaderOperatorId,
    this.leaderCodeSnapshot,
    this.leaderNameSnapshot,
    this.cropId,
    this.cropNameSnapshot,
    this.taskId,
    this.taskCodeSnapshot,
    this.taskNameSnapshot,
    this.taskDetail,
    this.lot,
    this.network,
    this.scheduledWage,
    this.realWage,
    required this.ha,
    this.ratio,
    this.diningRoomId,
    this.diningRoom,
    this.observation,
    this.extraFieldsJson,
    required this.isActive,
    required this.isLocked,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['record_date'] = Variable<DateTime>(recordDate);
    map['week_number'] = Variable<int>(weekNumber);
    map['department_id'] = Variable<String>(departmentId);
    map['created_by_user_id'] = Variable<String>(createdByUserId);
    map['user_code'] = Variable<String>(userCode);
    if (!nullToAbsent || operatorId != null) {
      map['operator_id'] = Variable<String>(operatorId);
    }
    if (!nullToAbsent || operatorNameSnapshot != null) {
      map['operator_name_snapshot'] = Variable<String>(operatorNameSnapshot);
    }
    if (!nullToAbsent || leaderOperatorId != null) {
      map['leader_operator_id'] = Variable<String>(leaderOperatorId);
    }
    if (!nullToAbsent || leaderCodeSnapshot != null) {
      map['leader_code_snapshot'] = Variable<String>(leaderCodeSnapshot);
    }
    if (!nullToAbsent || leaderNameSnapshot != null) {
      map['leader_name_snapshot'] = Variable<String>(leaderNameSnapshot);
    }
    if (!nullToAbsent || cropId != null) {
      map['crop_id'] = Variable<String>(cropId);
    }
    if (!nullToAbsent || cropNameSnapshot != null) {
      map['crop_name_snapshot'] = Variable<String>(cropNameSnapshot);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || taskCodeSnapshot != null) {
      map['task_code_snapshot'] = Variable<String>(taskCodeSnapshot);
    }
    if (!nullToAbsent || taskNameSnapshot != null) {
      map['task_name_snapshot'] = Variable<String>(taskNameSnapshot);
    }
    if (!nullToAbsent || taskDetail != null) {
      map['task_detail'] = Variable<String>(taskDetail);
    }
    if (!nullToAbsent || lot != null) {
      map['lot'] = Variable<String>(lot);
    }
    if (!nullToAbsent || network != null) {
      map['network'] = Variable<String>(network);
    }
    if (!nullToAbsent || scheduledWage != null) {
      map['scheduled_wage'] = Variable<double>(scheduledWage);
    }
    if (!nullToAbsent || realWage != null) {
      map['real_wage'] = Variable<double>(realWage);
    }
    map['ha'] = Variable<double>(ha);
    if (!nullToAbsent || ratio != null) {
      map['ratio'] = Variable<double>(ratio);
    }
    if (!nullToAbsent || diningRoomId != null) {
      map['dining_room_id'] = Variable<String>(diningRoomId);
    }
    if (!nullToAbsent || diningRoom != null) {
      map['dining_room'] = Variable<String>(diningRoom);
    }
    if (!nullToAbsent || observation != null) {
      map['observation'] = Variable<String>(observation);
    }
    if (!nullToAbsent || extraFieldsJson != null) {
      map['extra_fields_json'] = Variable<String>(extraFieldsJson);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_locked'] = Variable<bool>(isLocked);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      recordDate: Value(recordDate),
      weekNumber: Value(weekNumber),
      departmentId: Value(departmentId),
      createdByUserId: Value(createdByUserId),
      userCode: Value(userCode),
      operatorId: operatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(operatorId),
      operatorNameSnapshot: operatorNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(operatorNameSnapshot),
      leaderOperatorId: leaderOperatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderOperatorId),
      leaderCodeSnapshot: leaderCodeSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderCodeSnapshot),
      leaderNameSnapshot: leaderNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderNameSnapshot),
      cropId: cropId == null && nullToAbsent
          ? const Value.absent()
          : Value(cropId),
      cropNameSnapshot: cropNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(cropNameSnapshot),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      taskCodeSnapshot: taskCodeSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(taskCodeSnapshot),
      taskNameSnapshot: taskNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(taskNameSnapshot),
      taskDetail: taskDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(taskDetail),
      lot: lot == null && nullToAbsent ? const Value.absent() : Value(lot),
      network: network == null && nullToAbsent
          ? const Value.absent()
          : Value(network),
      scheduledWage: scheduledWage == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledWage),
      realWage: realWage == null && nullToAbsent
          ? const Value.absent()
          : Value(realWage),
      ha: Value(ha),
      ratio: ratio == null && nullToAbsent
          ? const Value.absent()
          : Value(ratio),
      diningRoomId: diningRoomId == null && nullToAbsent
          ? const Value.absent()
          : Value(diningRoomId),
      diningRoom: diningRoom == null && nullToAbsent
          ? const Value.absent()
          : Value(diningRoom),
      observation: observation == null && nullToAbsent
          ? const Value.absent()
          : Value(observation),
      extraFieldsJson: extraFieldsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extraFieldsJson),
      isActive: Value(isActive),
      isLocked: Value(isLocked),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory FarmRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmRecord(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      createdByUserId: serializer.fromJson<String>(json['createdByUserId']),
      userCode: serializer.fromJson<String>(json['userCode']),
      operatorId: serializer.fromJson<String?>(json['operatorId']),
      operatorNameSnapshot: serializer.fromJson<String?>(
        json['operatorNameSnapshot'],
      ),
      leaderOperatorId: serializer.fromJson<String?>(json['leaderOperatorId']),
      leaderCodeSnapshot: serializer.fromJson<String?>(
        json['leaderCodeSnapshot'],
      ),
      leaderNameSnapshot: serializer.fromJson<String?>(
        json['leaderNameSnapshot'],
      ),
      cropId: serializer.fromJson<String?>(json['cropId']),
      cropNameSnapshot: serializer.fromJson<String?>(json['cropNameSnapshot']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      taskCodeSnapshot: serializer.fromJson<String?>(json['taskCodeSnapshot']),
      taskNameSnapshot: serializer.fromJson<String?>(json['taskNameSnapshot']),
      taskDetail: serializer.fromJson<String?>(json['taskDetail']),
      lot: serializer.fromJson<String?>(json['lot']),
      network: serializer.fromJson<String?>(json['network']),
      scheduledWage: serializer.fromJson<double?>(json['scheduledWage']),
      realWage: serializer.fromJson<double?>(json['realWage']),
      ha: serializer.fromJson<double>(json['ha']),
      ratio: serializer.fromJson<double?>(json['ratio']),
      diningRoomId: serializer.fromJson<String?>(json['diningRoomId']),
      diningRoom: serializer.fromJson<String?>(json['diningRoom']),
      observation: serializer.fromJson<String?>(json['observation']),
      extraFieldsJson: serializer.fromJson<String?>(json['extraFieldsJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'departmentId': serializer.toJson<String>(departmentId),
      'createdByUserId': serializer.toJson<String>(createdByUserId),
      'userCode': serializer.toJson<String>(userCode),
      'operatorId': serializer.toJson<String?>(operatorId),
      'operatorNameSnapshot': serializer.toJson<String?>(operatorNameSnapshot),
      'leaderOperatorId': serializer.toJson<String?>(leaderOperatorId),
      'leaderCodeSnapshot': serializer.toJson<String?>(leaderCodeSnapshot),
      'leaderNameSnapshot': serializer.toJson<String?>(leaderNameSnapshot),
      'cropId': serializer.toJson<String?>(cropId),
      'cropNameSnapshot': serializer.toJson<String?>(cropNameSnapshot),
      'taskId': serializer.toJson<String?>(taskId),
      'taskCodeSnapshot': serializer.toJson<String?>(taskCodeSnapshot),
      'taskNameSnapshot': serializer.toJson<String?>(taskNameSnapshot),
      'taskDetail': serializer.toJson<String?>(taskDetail),
      'lot': serializer.toJson<String?>(lot),
      'network': serializer.toJson<String?>(network),
      'scheduledWage': serializer.toJson<double?>(scheduledWage),
      'realWage': serializer.toJson<double?>(realWage),
      'ha': serializer.toJson<double>(ha),
      'ratio': serializer.toJson<double?>(ratio),
      'diningRoomId': serializer.toJson<String?>(diningRoomId),
      'diningRoom': serializer.toJson<String?>(diningRoom),
      'observation': serializer.toJson<String?>(observation),
      'extraFieldsJson': serializer.toJson<String?>(extraFieldsJson),
      'isActive': serializer.toJson<bool>(isActive),
      'isLocked': serializer.toJson<bool>(isLocked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FarmRecord copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    DateTime? recordDate,
    int? weekNumber,
    String? departmentId,
    String? createdByUserId,
    String? userCode,
    Value<String?> operatorId = const Value.absent(),
    Value<String?> operatorNameSnapshot = const Value.absent(),
    Value<String?> leaderOperatorId = const Value.absent(),
    Value<String?> leaderCodeSnapshot = const Value.absent(),
    Value<String?> leaderNameSnapshot = const Value.absent(),
    Value<String?> cropId = const Value.absent(),
    Value<String?> cropNameSnapshot = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
    Value<String?> taskCodeSnapshot = const Value.absent(),
    Value<String?> taskNameSnapshot = const Value.absent(),
    Value<String?> taskDetail = const Value.absent(),
    Value<String?> lot = const Value.absent(),
    Value<String?> network = const Value.absent(),
    Value<double?> scheduledWage = const Value.absent(),
    Value<double?> realWage = const Value.absent(),
    double? ha,
    Value<double?> ratio = const Value.absent(),
    Value<String?> diningRoomId = const Value.absent(),
    Value<String?> diningRoom = const Value.absent(),
    Value<String?> observation = const Value.absent(),
    Value<String?> extraFieldsJson = const Value.absent(),
    bool? isActive,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => FarmRecord(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    recordDate: recordDate ?? this.recordDate,
    weekNumber: weekNumber ?? this.weekNumber,
    departmentId: departmentId ?? this.departmentId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    userCode: userCode ?? this.userCode,
    operatorId: operatorId.present ? operatorId.value : this.operatorId,
    operatorNameSnapshot: operatorNameSnapshot.present
        ? operatorNameSnapshot.value
        : this.operatorNameSnapshot,
    leaderOperatorId: leaderOperatorId.present
        ? leaderOperatorId.value
        : this.leaderOperatorId,
    leaderCodeSnapshot: leaderCodeSnapshot.present
        ? leaderCodeSnapshot.value
        : this.leaderCodeSnapshot,
    leaderNameSnapshot: leaderNameSnapshot.present
        ? leaderNameSnapshot.value
        : this.leaderNameSnapshot,
    cropId: cropId.present ? cropId.value : this.cropId,
    cropNameSnapshot: cropNameSnapshot.present
        ? cropNameSnapshot.value
        : this.cropNameSnapshot,
    taskId: taskId.present ? taskId.value : this.taskId,
    taskCodeSnapshot: taskCodeSnapshot.present
        ? taskCodeSnapshot.value
        : this.taskCodeSnapshot,
    taskNameSnapshot: taskNameSnapshot.present
        ? taskNameSnapshot.value
        : this.taskNameSnapshot,
    taskDetail: taskDetail.present ? taskDetail.value : this.taskDetail,
    lot: lot.present ? lot.value : this.lot,
    network: network.present ? network.value : this.network,
    scheduledWage: scheduledWage.present
        ? scheduledWage.value
        : this.scheduledWage,
    realWage: realWage.present ? realWage.value : this.realWage,
    ha: ha ?? this.ha,
    ratio: ratio.present ? ratio.value : this.ratio,
    diningRoomId: diningRoomId.present ? diningRoomId.value : this.diningRoomId,
    diningRoom: diningRoom.present ? diningRoom.value : this.diningRoom,
    observation: observation.present ? observation.value : this.observation,
    extraFieldsJson: extraFieldsJson.present
        ? extraFieldsJson.value
        : this.extraFieldsJson,
    isActive: isActive ?? this.isActive,
    isLocked: isLocked ?? this.isLocked,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FarmRecord copyWithCompanion(RecordsCompanion data) {
    return FarmRecord(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      recordDate: data.recordDate.present
          ? data.recordDate.value
          : this.recordDate,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      userCode: data.userCode.present ? data.userCode.value : this.userCode,
      operatorId: data.operatorId.present
          ? data.operatorId.value
          : this.operatorId,
      operatorNameSnapshot: data.operatorNameSnapshot.present
          ? data.operatorNameSnapshot.value
          : this.operatorNameSnapshot,
      leaderOperatorId: data.leaderOperatorId.present
          ? data.leaderOperatorId.value
          : this.leaderOperatorId,
      leaderCodeSnapshot: data.leaderCodeSnapshot.present
          ? data.leaderCodeSnapshot.value
          : this.leaderCodeSnapshot,
      leaderNameSnapshot: data.leaderNameSnapshot.present
          ? data.leaderNameSnapshot.value
          : this.leaderNameSnapshot,
      cropId: data.cropId.present ? data.cropId.value : this.cropId,
      cropNameSnapshot: data.cropNameSnapshot.present
          ? data.cropNameSnapshot.value
          : this.cropNameSnapshot,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      taskCodeSnapshot: data.taskCodeSnapshot.present
          ? data.taskCodeSnapshot.value
          : this.taskCodeSnapshot,
      taskNameSnapshot: data.taskNameSnapshot.present
          ? data.taskNameSnapshot.value
          : this.taskNameSnapshot,
      taskDetail: data.taskDetail.present
          ? data.taskDetail.value
          : this.taskDetail,
      lot: data.lot.present ? data.lot.value : this.lot,
      network: data.network.present ? data.network.value : this.network,
      scheduledWage: data.scheduledWage.present
          ? data.scheduledWage.value
          : this.scheduledWage,
      realWage: data.realWage.present ? data.realWage.value : this.realWage,
      ha: data.ha.present ? data.ha.value : this.ha,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
      diningRoomId: data.diningRoomId.present
          ? data.diningRoomId.value
          : this.diningRoomId,
      diningRoom: data.diningRoom.present
          ? data.diningRoom.value
          : this.diningRoom,
      observation: data.observation.present
          ? data.observation.value
          : this.observation,
      extraFieldsJson: data.extraFieldsJson.present
          ? data.extraFieldsJson.value
          : this.extraFieldsJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmRecord(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('recordDate: $recordDate, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('departmentId: $departmentId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('userCode: $userCode, ')
          ..write('operatorId: $operatorId, ')
          ..write('operatorNameSnapshot: $operatorNameSnapshot, ')
          ..write('leaderOperatorId: $leaderOperatorId, ')
          ..write('leaderCodeSnapshot: $leaderCodeSnapshot, ')
          ..write('leaderNameSnapshot: $leaderNameSnapshot, ')
          ..write('cropId: $cropId, ')
          ..write('cropNameSnapshot: $cropNameSnapshot, ')
          ..write('taskId: $taskId, ')
          ..write('taskCodeSnapshot: $taskCodeSnapshot, ')
          ..write('taskNameSnapshot: $taskNameSnapshot, ')
          ..write('taskDetail: $taskDetail, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('scheduledWage: $scheduledWage, ')
          ..write('realWage: $realWage, ')
          ..write('ha: $ha, ')
          ..write('ratio: $ratio, ')
          ..write('diningRoomId: $diningRoomId, ')
          ..write('diningRoom: $diningRoom, ')
          ..write('observation: $observation, ')
          ..write('extraFieldsJson: $extraFieldsJson, ')
          ..write('isActive: $isActive, ')
          ..write('isLocked: $isLocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    recordDate,
    weekNumber,
    departmentId,
    createdByUserId,
    userCode,
    operatorId,
    operatorNameSnapshot,
    leaderOperatorId,
    leaderCodeSnapshot,
    leaderNameSnapshot,
    cropId,
    cropNameSnapshot,
    taskId,
    taskCodeSnapshot,
    taskNameSnapshot,
    taskDetail,
    lot,
    network,
    scheduledWage,
    realWage,
    ha,
    ratio,
    diningRoomId,
    diningRoom,
    observation,
    extraFieldsJson,
    isActive,
    isLocked,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmRecord &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.recordDate == this.recordDate &&
          other.weekNumber == this.weekNumber &&
          other.departmentId == this.departmentId &&
          other.createdByUserId == this.createdByUserId &&
          other.userCode == this.userCode &&
          other.operatorId == this.operatorId &&
          other.operatorNameSnapshot == this.operatorNameSnapshot &&
          other.leaderOperatorId == this.leaderOperatorId &&
          other.leaderCodeSnapshot == this.leaderCodeSnapshot &&
          other.leaderNameSnapshot == this.leaderNameSnapshot &&
          other.cropId == this.cropId &&
          other.cropNameSnapshot == this.cropNameSnapshot &&
          other.taskId == this.taskId &&
          other.taskCodeSnapshot == this.taskCodeSnapshot &&
          other.taskNameSnapshot == this.taskNameSnapshot &&
          other.taskDetail == this.taskDetail &&
          other.lot == this.lot &&
          other.network == this.network &&
          other.scheduledWage == this.scheduledWage &&
          other.realWage == this.realWage &&
          other.ha == this.ha &&
          other.ratio == this.ratio &&
          other.diningRoomId == this.diningRoomId &&
          other.diningRoom == this.diningRoom &&
          other.observation == this.observation &&
          other.extraFieldsJson == this.extraFieldsJson &&
          other.isActive == this.isActive &&
          other.isLocked == this.isLocked &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class RecordsCompanion extends UpdateCompanion<FarmRecord> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<DateTime> recordDate;
  final Value<int> weekNumber;
  final Value<String> departmentId;
  final Value<String> createdByUserId;
  final Value<String> userCode;
  final Value<String?> operatorId;
  final Value<String?> operatorNameSnapshot;
  final Value<String?> leaderOperatorId;
  final Value<String?> leaderCodeSnapshot;
  final Value<String?> leaderNameSnapshot;
  final Value<String?> cropId;
  final Value<String?> cropNameSnapshot;
  final Value<String?> taskId;
  final Value<String?> taskCodeSnapshot;
  final Value<String?> taskNameSnapshot;
  final Value<String?> taskDetail;
  final Value<String?> lot;
  final Value<String?> network;
  final Value<double?> scheduledWage;
  final Value<double?> realWage;
  final Value<double> ha;
  final Value<double?> ratio;
  final Value<String?> diningRoomId;
  final Value<String?> diningRoom;
  final Value<String?> observation;
  final Value<String?> extraFieldsJson;
  final Value<bool> isActive;
  final Value<bool> isLocked;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.userCode = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.operatorNameSnapshot = const Value.absent(),
    this.leaderOperatorId = const Value.absent(),
    this.leaderCodeSnapshot = const Value.absent(),
    this.leaderNameSnapshot = const Value.absent(),
    this.cropId = const Value.absent(),
    this.cropNameSnapshot = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskCodeSnapshot = const Value.absent(),
    this.taskNameSnapshot = const Value.absent(),
    this.taskDetail = const Value.absent(),
    this.lot = const Value.absent(),
    this.network = const Value.absent(),
    this.scheduledWage = const Value.absent(),
    this.realWage = const Value.absent(),
    this.ha = const Value.absent(),
    this.ratio = const Value.absent(),
    this.diningRoomId = const Value.absent(),
    this.diningRoom = const Value.absent(),
    this.observation = const Value.absent(),
    this.extraFieldsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required DateTime recordDate,
    required int weekNumber,
    required String departmentId,
    required String createdByUserId,
    required String userCode,
    this.operatorId = const Value.absent(),
    this.operatorNameSnapshot = const Value.absent(),
    this.leaderOperatorId = const Value.absent(),
    this.leaderCodeSnapshot = const Value.absent(),
    this.leaderNameSnapshot = const Value.absent(),
    this.cropId = const Value.absent(),
    this.cropNameSnapshot = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskCodeSnapshot = const Value.absent(),
    this.taskNameSnapshot = const Value.absent(),
    this.taskDetail = const Value.absent(),
    this.lot = const Value.absent(),
    this.network = const Value.absent(),
    this.scheduledWage = const Value.absent(),
    this.realWage = const Value.absent(),
    this.ha = const Value.absent(),
    this.ratio = const Value.absent(),
    this.diningRoomId = const Value.absent(),
    this.diningRoom = const Value.absent(),
    this.observation = const Value.absent(),
    this.extraFieldsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordDate = Value(recordDate),
       weekNumber = Value(weekNumber),
       departmentId = Value(departmentId),
       createdByUserId = Value(createdByUserId),
       userCode = Value(userCode);
  static Insertable<FarmRecord> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<DateTime>? recordDate,
    Expression<int>? weekNumber,
    Expression<String>? departmentId,
    Expression<String>? createdByUserId,
    Expression<String>? userCode,
    Expression<String>? operatorId,
    Expression<String>? operatorNameSnapshot,
    Expression<String>? leaderOperatorId,
    Expression<String>? leaderCodeSnapshot,
    Expression<String>? leaderNameSnapshot,
    Expression<String>? cropId,
    Expression<String>? cropNameSnapshot,
    Expression<String>? taskId,
    Expression<String>? taskCodeSnapshot,
    Expression<String>? taskNameSnapshot,
    Expression<String>? taskDetail,
    Expression<String>? lot,
    Expression<String>? network,
    Expression<double>? scheduledWage,
    Expression<double>? realWage,
    Expression<double>? ha,
    Expression<double>? ratio,
    Expression<String>? diningRoomId,
    Expression<String>? diningRoom,
    Expression<String>? observation,
    Expression<String>? extraFieldsJson,
    Expression<bool>? isActive,
    Expression<bool>? isLocked,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (recordDate != null) 'record_date': recordDate,
      if (weekNumber != null) 'week_number': weekNumber,
      if (departmentId != null) 'department_id': departmentId,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (userCode != null) 'user_code': userCode,
      if (operatorId != null) 'operator_id': operatorId,
      if (operatorNameSnapshot != null)
        'operator_name_snapshot': operatorNameSnapshot,
      if (leaderOperatorId != null) 'leader_operator_id': leaderOperatorId,
      if (leaderCodeSnapshot != null)
        'leader_code_snapshot': leaderCodeSnapshot,
      if (leaderNameSnapshot != null)
        'leader_name_snapshot': leaderNameSnapshot,
      if (cropId != null) 'crop_id': cropId,
      if (cropNameSnapshot != null) 'crop_name_snapshot': cropNameSnapshot,
      if (taskId != null) 'task_id': taskId,
      if (taskCodeSnapshot != null) 'task_code_snapshot': taskCodeSnapshot,
      if (taskNameSnapshot != null) 'task_name_snapshot': taskNameSnapshot,
      if (taskDetail != null) 'task_detail': taskDetail,
      if (lot != null) 'lot': lot,
      if (network != null) 'network': network,
      if (scheduledWage != null) 'scheduled_wage': scheduledWage,
      if (realWage != null) 'real_wage': realWage,
      if (ha != null) 'ha': ha,
      if (ratio != null) 'ratio': ratio,
      if (diningRoomId != null) 'dining_room_id': diningRoomId,
      if (diningRoom != null) 'dining_room': diningRoom,
      if (observation != null) 'observation': observation,
      if (extraFieldsJson != null) 'extra_fields_json': extraFieldsJson,
      if (isActive != null) 'is_active': isActive,
      if (isLocked != null) 'is_locked': isLocked,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<DateTime>? recordDate,
    Value<int>? weekNumber,
    Value<String>? departmentId,
    Value<String>? createdByUserId,
    Value<String>? userCode,
    Value<String?>? operatorId,
    Value<String?>? operatorNameSnapshot,
    Value<String?>? leaderOperatorId,
    Value<String?>? leaderCodeSnapshot,
    Value<String?>? leaderNameSnapshot,
    Value<String?>? cropId,
    Value<String?>? cropNameSnapshot,
    Value<String?>? taskId,
    Value<String?>? taskCodeSnapshot,
    Value<String?>? taskNameSnapshot,
    Value<String?>? taskDetail,
    Value<String?>? lot,
    Value<String?>? network,
    Value<double?>? scheduledWage,
    Value<double?>? realWage,
    Value<double>? ha,
    Value<double?>? ratio,
    Value<String?>? diningRoomId,
    Value<String?>? diningRoom,
    Value<String?>? observation,
    Value<String?>? extraFieldsJson,
    Value<bool>? isActive,
    Value<bool>? isLocked,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return RecordsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      recordDate: recordDate ?? this.recordDate,
      weekNumber: weekNumber ?? this.weekNumber,
      departmentId: departmentId ?? this.departmentId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      userCode: userCode ?? this.userCode,
      operatorId: operatorId ?? this.operatorId,
      operatorNameSnapshot: operatorNameSnapshot ?? this.operatorNameSnapshot,
      leaderOperatorId: leaderOperatorId ?? this.leaderOperatorId,
      leaderCodeSnapshot: leaderCodeSnapshot ?? this.leaderCodeSnapshot,
      leaderNameSnapshot: leaderNameSnapshot ?? this.leaderNameSnapshot,
      cropId: cropId ?? this.cropId,
      cropNameSnapshot: cropNameSnapshot ?? this.cropNameSnapshot,
      taskId: taskId ?? this.taskId,
      taskCodeSnapshot: taskCodeSnapshot ?? this.taskCodeSnapshot,
      taskNameSnapshot: taskNameSnapshot ?? this.taskNameSnapshot,
      taskDetail: taskDetail ?? this.taskDetail,
      lot: lot ?? this.lot,
      network: network ?? this.network,
      scheduledWage: scheduledWage ?? this.scheduledWage,
      realWage: realWage ?? this.realWage,
      ha: ha ?? this.ha,
      ratio: ratio ?? this.ratio,
      diningRoomId: diningRoomId ?? this.diningRoomId,
      diningRoom: diningRoom ?? this.diningRoom,
      observation: observation ?? this.observation,
      extraFieldsJson: extraFieldsJson ?? this.extraFieldsJson,
      isActive: isActive ?? this.isActive,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (userCode.present) {
      map['user_code'] = Variable<String>(userCode.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (operatorNameSnapshot.present) {
      map['operator_name_snapshot'] = Variable<String>(
        operatorNameSnapshot.value,
      );
    }
    if (leaderOperatorId.present) {
      map['leader_operator_id'] = Variable<String>(leaderOperatorId.value);
    }
    if (leaderCodeSnapshot.present) {
      map['leader_code_snapshot'] = Variable<String>(leaderCodeSnapshot.value);
    }
    if (leaderNameSnapshot.present) {
      map['leader_name_snapshot'] = Variable<String>(leaderNameSnapshot.value);
    }
    if (cropId.present) {
      map['crop_id'] = Variable<String>(cropId.value);
    }
    if (cropNameSnapshot.present) {
      map['crop_name_snapshot'] = Variable<String>(cropNameSnapshot.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (taskCodeSnapshot.present) {
      map['task_code_snapshot'] = Variable<String>(taskCodeSnapshot.value);
    }
    if (taskNameSnapshot.present) {
      map['task_name_snapshot'] = Variable<String>(taskNameSnapshot.value);
    }
    if (taskDetail.present) {
      map['task_detail'] = Variable<String>(taskDetail.value);
    }
    if (lot.present) {
      map['lot'] = Variable<String>(lot.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (scheduledWage.present) {
      map['scheduled_wage'] = Variable<double>(scheduledWage.value);
    }
    if (realWage.present) {
      map['real_wage'] = Variable<double>(realWage.value);
    }
    if (ha.present) {
      map['ha'] = Variable<double>(ha.value);
    }
    if (ratio.present) {
      map['ratio'] = Variable<double>(ratio.value);
    }
    if (diningRoomId.present) {
      map['dining_room_id'] = Variable<String>(diningRoomId.value);
    }
    if (diningRoom.present) {
      map['dining_room'] = Variable<String>(diningRoom.value);
    }
    if (observation.present) {
      map['observation'] = Variable<String>(observation.value);
    }
    if (extraFieldsJson.present) {
      map['extra_fields_json'] = Variable<String>(extraFieldsJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('recordDate: $recordDate, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('departmentId: $departmentId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('userCode: $userCode, ')
          ..write('operatorId: $operatorId, ')
          ..write('operatorNameSnapshot: $operatorNameSnapshot, ')
          ..write('leaderOperatorId: $leaderOperatorId, ')
          ..write('leaderCodeSnapshot: $leaderCodeSnapshot, ')
          ..write('leaderNameSnapshot: $leaderNameSnapshot, ')
          ..write('cropId: $cropId, ')
          ..write('cropNameSnapshot: $cropNameSnapshot, ')
          ..write('taskId: $taskId, ')
          ..write('taskCodeSnapshot: $taskCodeSnapshot, ')
          ..write('taskNameSnapshot: $taskNameSnapshot, ')
          ..write('taskDetail: $taskDetail, ')
          ..write('lot: $lot, ')
          ..write('network: $network, ')
          ..write('scheduledWage: $scheduledWage, ')
          ..write('realWage: $realWage, ')
          ..write('ha: $ha, ')
          ..write('ratio: $ratio, ')
          ..write('diningRoomId: $diningRoomId, ')
          ..write('diningRoom: $diningRoom, ')
          ..write('observation: $observation, ')
          ..write('extraFieldsJson: $extraFieldsJson, ')
          ..write('isActive: $isActive, ')
          ..write('isLocked: $isLocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordLocationsTable extends RecordLocations
    with TableInfo<$RecordLocationsTable, FarmRecordLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES records (id)',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _cropNameSnapshotMeta = const VerificationMeta(
    'cropNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> cropNameSnapshot = GeneratedColumn<String>(
    'crop_name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lotSnapshotMeta = const VerificationMeta(
    'lotSnapshot',
  );
  @override
  late final GeneratedColumn<String> lotSnapshot = GeneratedColumn<String>(
    'lot_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkSnapshotMeta = const VerificationMeta(
    'networkSnapshot',
  );
  @override
  late final GeneratedColumn<String> networkSnapshot = GeneratedColumn<String>(
    'network_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectorSnapshotMeta = const VerificationMeta(
    'sectorSnapshot',
  );
  @override
  late final GeneratedColumn<String> sectorSnapshot = GeneratedColumn<String>(
    'sector_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _haSnapshotMeta = const VerificationMeta(
    'haSnapshot',
  );
  @override
  late final GeneratedColumn<double> haSnapshot = GeneratedColumn<double>(
    'ha_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordId,
    locationId,
    cropNameSnapshot,
    lotSnapshot,
    networkSnapshot,
    sectorSnapshot,
    haSnapshot,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarmRecordLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('crop_name_snapshot')) {
      context.handle(
        _cropNameSnapshotMeta,
        cropNameSnapshot.isAcceptableOrUnknown(
          data['crop_name_snapshot']!,
          _cropNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cropNameSnapshotMeta);
    }
    if (data.containsKey('lot_snapshot')) {
      context.handle(
        _lotSnapshotMeta,
        lotSnapshot.isAcceptableOrUnknown(
          data['lot_snapshot']!,
          _lotSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lotSnapshotMeta);
    }
    if (data.containsKey('network_snapshot')) {
      context.handle(
        _networkSnapshotMeta,
        networkSnapshot.isAcceptableOrUnknown(
          data['network_snapshot']!,
          _networkSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_networkSnapshotMeta);
    }
    if (data.containsKey('sector_snapshot')) {
      context.handle(
        _sectorSnapshotMeta,
        sectorSnapshot.isAcceptableOrUnknown(
          data['sector_snapshot']!,
          _sectorSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectorSnapshotMeta);
    }
    if (data.containsKey('ha_snapshot')) {
      context.handle(
        _haSnapshotMeta,
        haSnapshot.isAcceptableOrUnknown(data['ha_snapshot']!, _haSnapshotMeta),
      );
    } else if (isInserting) {
      context.missing(_haSnapshotMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmRecordLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmRecordLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      cropNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_name_snapshot'],
      )!,
      lotSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot_snapshot'],
      )!,
      networkSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_snapshot'],
      )!,
      sectorSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector_snapshot'],
      )!,
      haSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ha_snapshot'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $RecordLocationsTable createAlias(String alias) {
    return $RecordLocationsTable(attachedDatabase, alias);
  }
}

class FarmRecordLocation extends DataClass
    implements Insertable<FarmRecordLocation> {
  final String id;
  final String recordId;
  final String locationId;
  final String cropNameSnapshot;
  final String lotSnapshot;
  final String networkSnapshot;
  final String sectorSnapshot;
  final double haSnapshot;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const FarmRecordLocation({
    required this.id,
    required this.recordId,
    required this.locationId,
    required this.cropNameSnapshot,
    required this.lotSnapshot,
    required this.networkSnapshot,
    required this.sectorSnapshot,
    required this.haSnapshot,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['record_id'] = Variable<String>(recordId);
    map['location_id'] = Variable<String>(locationId);
    map['crop_name_snapshot'] = Variable<String>(cropNameSnapshot);
    map['lot_snapshot'] = Variable<String>(lotSnapshot);
    map['network_snapshot'] = Variable<String>(networkSnapshot);
    map['sector_snapshot'] = Variable<String>(sectorSnapshot);
    map['ha_snapshot'] = Variable<double>(haSnapshot);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  RecordLocationsCompanion toCompanion(bool nullToAbsent) {
    return RecordLocationsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      locationId: Value(locationId),
      cropNameSnapshot: Value(cropNameSnapshot),
      lotSnapshot: Value(lotSnapshot),
      networkSnapshot: Value(networkSnapshot),
      sectorSnapshot: Value(sectorSnapshot),
      haSnapshot: Value(haSnapshot),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory FarmRecordLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmRecordLocation(
      id: serializer.fromJson<String>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      cropNameSnapshot: serializer.fromJson<String>(json['cropNameSnapshot']),
      lotSnapshot: serializer.fromJson<String>(json['lotSnapshot']),
      networkSnapshot: serializer.fromJson<String>(json['networkSnapshot']),
      sectorSnapshot: serializer.fromJson<String>(json['sectorSnapshot']),
      haSnapshot: serializer.fromJson<double>(json['haSnapshot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordId': serializer.toJson<String>(recordId),
      'locationId': serializer.toJson<String>(locationId),
      'cropNameSnapshot': serializer.toJson<String>(cropNameSnapshot),
      'lotSnapshot': serializer.toJson<String>(lotSnapshot),
      'networkSnapshot': serializer.toJson<String>(networkSnapshot),
      'sectorSnapshot': serializer.toJson<String>(sectorSnapshot),
      'haSnapshot': serializer.toJson<double>(haSnapshot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FarmRecordLocation copyWith({
    String? id,
    String? recordId,
    String? locationId,
    String? cropNameSnapshot,
    String? lotSnapshot,
    String? networkSnapshot,
    String? sectorSnapshot,
    double? haSnapshot,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => FarmRecordLocation(
    id: id ?? this.id,
    recordId: recordId ?? this.recordId,
    locationId: locationId ?? this.locationId,
    cropNameSnapshot: cropNameSnapshot ?? this.cropNameSnapshot,
    lotSnapshot: lotSnapshot ?? this.lotSnapshot,
    networkSnapshot: networkSnapshot ?? this.networkSnapshot,
    sectorSnapshot: sectorSnapshot ?? this.sectorSnapshot,
    haSnapshot: haSnapshot ?? this.haSnapshot,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FarmRecordLocation copyWithCompanion(RecordLocationsCompanion data) {
    return FarmRecordLocation(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      cropNameSnapshot: data.cropNameSnapshot.present
          ? data.cropNameSnapshot.value
          : this.cropNameSnapshot,
      lotSnapshot: data.lotSnapshot.present
          ? data.lotSnapshot.value
          : this.lotSnapshot,
      networkSnapshot: data.networkSnapshot.present
          ? data.networkSnapshot.value
          : this.networkSnapshot,
      sectorSnapshot: data.sectorSnapshot.present
          ? data.sectorSnapshot.value
          : this.sectorSnapshot,
      haSnapshot: data.haSnapshot.present
          ? data.haSnapshot.value
          : this.haSnapshot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmRecordLocation(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('locationId: $locationId, ')
          ..write('cropNameSnapshot: $cropNameSnapshot, ')
          ..write('lotSnapshot: $lotSnapshot, ')
          ..write('networkSnapshot: $networkSnapshot, ')
          ..write('sectorSnapshot: $sectorSnapshot, ')
          ..write('haSnapshot: $haSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordId,
    locationId,
    cropNameSnapshot,
    lotSnapshot,
    networkSnapshot,
    sectorSnapshot,
    haSnapshot,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmRecordLocation &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.locationId == this.locationId &&
          other.cropNameSnapshot == this.cropNameSnapshot &&
          other.lotSnapshot == this.lotSnapshot &&
          other.networkSnapshot == this.networkSnapshot &&
          other.sectorSnapshot == this.sectorSnapshot &&
          other.haSnapshot == this.haSnapshot &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class RecordLocationsCompanion extends UpdateCompanion<FarmRecordLocation> {
  final Value<String> id;
  final Value<String> recordId;
  final Value<String> locationId;
  final Value<String> cropNameSnapshot;
  final Value<String> lotSnapshot;
  final Value<String> networkSnapshot;
  final Value<String> sectorSnapshot;
  final Value<double> haSnapshot;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const RecordLocationsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.cropNameSnapshot = const Value.absent(),
    this.lotSnapshot = const Value.absent(),
    this.networkSnapshot = const Value.absent(),
    this.sectorSnapshot = const Value.absent(),
    this.haSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordLocationsCompanion.insert({
    required String id,
    required String recordId,
    required String locationId,
    required String cropNameSnapshot,
    required String lotSnapshot,
    required String networkSnapshot,
    required String sectorSnapshot,
    required double haSnapshot,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordId = Value(recordId),
       locationId = Value(locationId),
       cropNameSnapshot = Value(cropNameSnapshot),
       lotSnapshot = Value(lotSnapshot),
       networkSnapshot = Value(networkSnapshot),
       sectorSnapshot = Value(sectorSnapshot),
       haSnapshot = Value(haSnapshot);
  static Insertable<FarmRecordLocation> custom({
    Expression<String>? id,
    Expression<String>? recordId,
    Expression<String>? locationId,
    Expression<String>? cropNameSnapshot,
    Expression<String>? lotSnapshot,
    Expression<String>? networkSnapshot,
    Expression<String>? sectorSnapshot,
    Expression<double>? haSnapshot,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (locationId != null) 'location_id': locationId,
      if (cropNameSnapshot != null) 'crop_name_snapshot': cropNameSnapshot,
      if (lotSnapshot != null) 'lot_snapshot': lotSnapshot,
      if (networkSnapshot != null) 'network_snapshot': networkSnapshot,
      if (sectorSnapshot != null) 'sector_snapshot': sectorSnapshot,
      if (haSnapshot != null) 'ha_snapshot': haSnapshot,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordLocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? recordId,
    Value<String>? locationId,
    Value<String>? cropNameSnapshot,
    Value<String>? lotSnapshot,
    Value<String>? networkSnapshot,
    Value<String>? sectorSnapshot,
    Value<double>? haSnapshot,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return RecordLocationsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      locationId: locationId ?? this.locationId,
      cropNameSnapshot: cropNameSnapshot ?? this.cropNameSnapshot,
      lotSnapshot: lotSnapshot ?? this.lotSnapshot,
      networkSnapshot: networkSnapshot ?? this.networkSnapshot,
      sectorSnapshot: sectorSnapshot ?? this.sectorSnapshot,
      haSnapshot: haSnapshot ?? this.haSnapshot,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (cropNameSnapshot.present) {
      map['crop_name_snapshot'] = Variable<String>(cropNameSnapshot.value);
    }
    if (lotSnapshot.present) {
      map['lot_snapshot'] = Variable<String>(lotSnapshot.value);
    }
    if (networkSnapshot.present) {
      map['network_snapshot'] = Variable<String>(networkSnapshot.value);
    }
    if (sectorSnapshot.present) {
      map['sector_snapshot'] = Variable<String>(sectorSnapshot.value);
    }
    if (haSnapshot.present) {
      map['ha_snapshot'] = Variable<double>(haSnapshot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordLocationsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('locationId: $locationId, ')
          ..write('cropNameSnapshot: $cropNameSnapshot, ')
          ..write('lotSnapshot: $lotSnapshot, ')
          ..write('networkSnapshot: $networkSnapshot, ')
          ..write('sectorSnapshot: $sectorSnapshot, ')
          ..write('haSnapshot: $haSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormFieldConfigsTable extends FormFieldConfigs
    with TableInfo<$FormFieldConfigsTable, FormFieldConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormFieldConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _fieldKeyMeta = const VerificationMeta(
    'fieldKey',
  );
  @override
  late final GeneratedColumn<String> fieldKey = GeneratedColumn<String>(
    'field_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldTypeMeta = const VerificationMeta(
    'fieldType',
  );
  @override
  late final GeneratedColumn<String> fieldType = GeneratedColumn<String>(
    'field_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    fieldKey,
    label,
    fieldType,
    isRequired,
    isVisible,
    sortOrder,
    optionsJson,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_field_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormFieldConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('field_key')) {
      context.handle(
        _fieldKeyMeta,
        fieldKey.isAcceptableOrUnknown(data['field_key']!, _fieldKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('field_type')) {
      context.handle(
        _fieldTypeMeta,
        fieldType.isAcceptableOrUnknown(data['field_type']!, _fieldTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldTypeMeta);
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormFieldConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormFieldConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      fieldKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      fieldType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_type'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $FormFieldConfigsTable createAlias(String alias) {
    return $FormFieldConfigsTable(attachedDatabase, alias);
  }
}

class FormFieldConfig extends DataClass implements Insertable<FormFieldConfig> {
  final String id;
  final String departmentId;
  final String fieldKey;
  final String label;
  final String fieldType;
  final bool isRequired;
  final bool isVisible;
  final int sortOrder;
  final String? optionsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const FormFieldConfig({
    required this.id,
    required this.departmentId,
    required this.fieldKey,
    required this.label,
    required this.fieldType,
    required this.isRequired,
    required this.isVisible,
    required this.sortOrder,
    this.optionsJson,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['field_key'] = Variable<String>(fieldKey);
    map['label'] = Variable<String>(label);
    map['field_type'] = Variable<String>(fieldType);
    map['is_required'] = Variable<bool>(isRequired);
    map['is_visible'] = Variable<bool>(isVisible);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || optionsJson != null) {
      map['options_json'] = Variable<String>(optionsJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  FormFieldConfigsCompanion toCompanion(bool nullToAbsent) {
    return FormFieldConfigsCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      fieldKey: Value(fieldKey),
      label: Value(label),
      fieldType: Value(fieldType),
      isRequired: Value(isRequired),
      isVisible: Value(isVisible),
      sortOrder: Value(sortOrder),
      optionsJson: optionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory FormFieldConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormFieldConfig(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      fieldKey: serializer.fromJson<String>(json['fieldKey']),
      label: serializer.fromJson<String>(json['label']),
      fieldType: serializer.fromJson<String>(json['fieldType']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      optionsJson: serializer.fromJson<String?>(json['optionsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'fieldKey': serializer.toJson<String>(fieldKey),
      'label': serializer.toJson<String>(label),
      'fieldType': serializer.toJson<String>(fieldType),
      'isRequired': serializer.toJson<bool>(isRequired),
      'isVisible': serializer.toJson<bool>(isVisible),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'optionsJson': serializer.toJson<String?>(optionsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  FormFieldConfig copyWith({
    String? id,
    String? departmentId,
    String? fieldKey,
    String? label,
    String? fieldType,
    bool? isRequired,
    bool? isVisible,
    int? sortOrder,
    Value<String?> optionsJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => FormFieldConfig(
    id: id ?? this.id,
    departmentId: departmentId ?? this.departmentId,
    fieldKey: fieldKey ?? this.fieldKey,
    label: label ?? this.label,
    fieldType: fieldType ?? this.fieldType,
    isRequired: isRequired ?? this.isRequired,
    isVisible: isVisible ?? this.isVisible,
    sortOrder: sortOrder ?? this.sortOrder,
    optionsJson: optionsJson.present ? optionsJson.value : this.optionsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  FormFieldConfig copyWithCompanion(FormFieldConfigsCompanion data) {
    return FormFieldConfig(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      fieldKey: data.fieldKey.present ? data.fieldKey.value : this.fieldKey,
      label: data.label.present ? data.label.value : this.label,
      fieldType: data.fieldType.present ? data.fieldType.value : this.fieldType,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormFieldConfig(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('label: $label, ')
          ..write('fieldType: $fieldType, ')
          ..write('isRequired: $isRequired, ')
          ..write('isVisible: $isVisible, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    departmentId,
    fieldKey,
    label,
    fieldType,
    isRequired,
    isVisible,
    sortOrder,
    optionsJson,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormFieldConfig &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.fieldKey == this.fieldKey &&
          other.label == this.label &&
          other.fieldType == this.fieldType &&
          other.isRequired == this.isRequired &&
          other.isVisible == this.isVisible &&
          other.sortOrder == this.sortOrder &&
          other.optionsJson == this.optionsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class FormFieldConfigsCompanion extends UpdateCompanion<FormFieldConfig> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> fieldKey;
  final Value<String> label;
  final Value<String> fieldType;
  final Value<bool> isRequired;
  final Value<bool> isVisible;
  final Value<int> sortOrder;
  final Value<String?> optionsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const FormFieldConfigsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.fieldKey = const Value.absent(),
    this.label = const Value.absent(),
    this.fieldType = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormFieldConfigsCompanion.insert({
    required String id,
    required String departmentId,
    required String fieldKey,
    required String label,
    required String fieldType,
    this.isRequired = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       departmentId = Value(departmentId),
       fieldKey = Value(fieldKey),
       label = Value(label),
       fieldType = Value(fieldType);
  static Insertable<FormFieldConfig> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? fieldKey,
    Expression<String>? label,
    Expression<String>? fieldType,
    Expression<bool>? isRequired,
    Expression<bool>? isVisible,
    Expression<int>? sortOrder,
    Expression<String>? optionsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (fieldKey != null) 'field_key': fieldKey,
      if (label != null) 'label': label,
      if (fieldType != null) 'field_type': fieldType,
      if (isRequired != null) 'is_required': isRequired,
      if (isVisible != null) 'is_visible': isVisible,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (optionsJson != null) 'options_json': optionsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormFieldConfigsCompanion copyWith({
    Value<String>? id,
    Value<String>? departmentId,
    Value<String>? fieldKey,
    Value<String>? label,
    Value<String>? fieldType,
    Value<bool>? isRequired,
    Value<bool>? isVisible,
    Value<int>? sortOrder,
    Value<String?>? optionsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return FormFieldConfigsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      fieldKey: fieldKey ?? this.fieldKey,
      label: label ?? this.label,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
      optionsJson: optionsJson ?? this.optionsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (fieldKey.present) {
      map['field_key'] = Variable<String>(fieldKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (fieldType.present) {
      map['field_type'] = Variable<String>(fieldType.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormFieldConfigsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('label: $label, ')
          ..write('fieldType: $fieldType, ')
          ..write('isRequired: $isRequired, ')
          ..write('isVisible: $isVisible, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TableColumnConfigsTable extends TableColumnConfigs
    with TableInfo<$TableColumnConfigsTable, TableColumnConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableColumnConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id)',
    ),
  );
  static const VerificationMeta _tableKeyMeta = const VerificationMeta(
    'tableKey',
  );
  @override
  late final GeneratedColumn<String> tableKey = GeneratedColumn<String>(
    'table_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _columnKeyMeta = const VerificationMeta(
    'columnKey',
  );
  @override
  late final GeneratedColumn<String> columnKey = GeneratedColumn<String>(
    'column_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isExportableMeta = const VerificationMeta(
    'isExportable',
  );
  @override
  late final GeneratedColumn<bool> isExportable = GeneratedColumn<bool>(
    'is_exportable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_exportable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.synced),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    tableKey,
    columnKey,
    label,
    isVisible,
    isExportable,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_column_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableColumnConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('table_key')) {
      context.handle(
        _tableKeyMeta,
        tableKey.isAcceptableOrUnknown(data['table_key']!, _tableKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_tableKeyMeta);
    }
    if (data.containsKey('column_key')) {
      context.handle(
        _columnKeyMeta,
        columnKey.isAcceptableOrUnknown(data['column_key']!, _columnKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_columnKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    if (data.containsKey('is_exportable')) {
      context.handle(
        _isExportableMeta,
        isExportable.isAcceptableOrUnknown(
          data['is_exportable']!,
          _isExportableMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableColumnConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableColumnConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      ),
      tableKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_key'],
      )!,
      columnKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}column_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
      isExportable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_exportable'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TableColumnConfigsTable createAlias(String alias) {
    return $TableColumnConfigsTable(attachedDatabase, alias);
  }
}

class TableColumnConfig extends DataClass
    implements Insertable<TableColumnConfig> {
  final String id;
  final String? departmentId;
  final String tableKey;
  final String columnKey;
  final String label;
  final bool isVisible;
  final bool isExportable;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const TableColumnConfig({
    required this.id,
    this.departmentId,
    required this.tableKey,
    required this.columnKey,
    required this.label,
    required this.isVisible,
    required this.isExportable,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    map['table_key'] = Variable<String>(tableKey);
    map['column_key'] = Variable<String>(columnKey);
    map['label'] = Variable<String>(label);
    map['is_visible'] = Variable<bool>(isVisible);
    map['is_exportable'] = Variable<bool>(isExportable);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TableColumnConfigsCompanion toCompanion(bool nullToAbsent) {
    return TableColumnConfigsCompanion(
      id: Value(id),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      tableKey: Value(tableKey),
      columnKey: Value(columnKey),
      label: Value(label),
      isVisible: Value(isVisible),
      isExportable: Value(isExportable),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory TableColumnConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableColumnConfig(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      tableKey: serializer.fromJson<String>(json['tableKey']),
      columnKey: serializer.fromJson<String>(json['columnKey']),
      label: serializer.fromJson<String>(json['label']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      isExportable: serializer.fromJson<bool>(json['isExportable']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String?>(departmentId),
      'tableKey': serializer.toJson<String>(tableKey),
      'columnKey': serializer.toJson<String>(columnKey),
      'label': serializer.toJson<String>(label),
      'isVisible': serializer.toJson<bool>(isVisible),
      'isExportable': serializer.toJson<bool>(isExportable),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TableColumnConfig copyWith({
    String? id,
    Value<String?> departmentId = const Value.absent(),
    String? tableKey,
    String? columnKey,
    String? label,
    bool? isVisible,
    bool? isExportable,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => TableColumnConfig(
    id: id ?? this.id,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    tableKey: tableKey ?? this.tableKey,
    columnKey: columnKey ?? this.columnKey,
    label: label ?? this.label,
    isVisible: isVisible ?? this.isVisible,
    isExportable: isExportable ?? this.isExportable,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  TableColumnConfig copyWithCompanion(TableColumnConfigsCompanion data) {
    return TableColumnConfig(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      tableKey: data.tableKey.present ? data.tableKey.value : this.tableKey,
      columnKey: data.columnKey.present ? data.columnKey.value : this.columnKey,
      label: data.label.present ? data.label.value : this.label,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      isExportable: data.isExportable.present
          ? data.isExportable.value
          : this.isExportable,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableColumnConfig(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('tableKey: $tableKey, ')
          ..write('columnKey: $columnKey, ')
          ..write('label: $label, ')
          ..write('isVisible: $isVisible, ')
          ..write('isExportable: $isExportable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    departmentId,
    tableKey,
    columnKey,
    label,
    isVisible,
    isExportable,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableColumnConfig &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.tableKey == this.tableKey &&
          other.columnKey == this.columnKey &&
          other.label == this.label &&
          other.isVisible == this.isVisible &&
          other.isExportable == this.isExportable &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class TableColumnConfigsCompanion extends UpdateCompanion<TableColumnConfig> {
  final Value<String> id;
  final Value<String?> departmentId;
  final Value<String> tableKey;
  final Value<String> columnKey;
  final Value<String> label;
  final Value<bool> isVisible;
  final Value<bool> isExportable;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TableColumnConfigsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.tableKey = const Value.absent(),
    this.columnKey = const Value.absent(),
    this.label = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.isExportable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TableColumnConfigsCompanion.insert({
    required String id,
    this.departmentId = const Value.absent(),
    required String tableKey,
    required String columnKey,
    required String label,
    this.isVisible = const Value.absent(),
    this.isExportable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tableKey = Value(tableKey),
       columnKey = Value(columnKey),
       label = Value(label);
  static Insertable<TableColumnConfig> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? tableKey,
    Expression<String>? columnKey,
    Expression<String>? label,
    Expression<bool>? isVisible,
    Expression<bool>? isExportable,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (tableKey != null) 'table_key': tableKey,
      if (columnKey != null) 'column_key': columnKey,
      if (label != null) 'label': label,
      if (isVisible != null) 'is_visible': isVisible,
      if (isExportable != null) 'is_exportable': isExportable,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TableColumnConfigsCompanion copyWith({
    Value<String>? id,
    Value<String?>? departmentId,
    Value<String>? tableKey,
    Value<String>? columnKey,
    Value<String>? label,
    Value<bool>? isVisible,
    Value<bool>? isExportable,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return TableColumnConfigsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      tableKey: tableKey ?? this.tableKey,
      columnKey: columnKey ?? this.columnKey,
      label: label ?? this.label,
      isVisible: isVisible ?? this.isVisible,
      isExportable: isExportable ?? this.isExportable,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (tableKey.present) {
      map['table_key'] = Variable<String>(tableKey.value);
    }
    if (columnKey.present) {
      map['column_key'] = Variable<String>(columnKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (isExportable.present) {
      map['is_exportable'] = Variable<bool>(isExportable.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableColumnConfigsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('tableKey: $tableKey, ')
          ..write('columnKey: $columnKey, ')
          ..write('label: $label, ')
          ..write('isVisible: $isVisible, ')
          ..write('isExportable: $isExportable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.pending),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(SyncStatuses.pending),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payloadJson,
    status,
    attempts,
    lastError,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payloadJson;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  const SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payloadJson,
    required this.status,
    required this.attempts,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  SyncQueueItem copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payloadJson,
    String? status,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
  }) => SyncQueueItem(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payloadJson,
    status,
    attempts,
    lastError,
    createdAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payloadJson,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payloadJson = Value(payloadJson);
  static Insertable<SyncQueueItem> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $CropsTable crops = $CropsTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $OperatorsTable operators = $OperatorsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserDepartmentsTable userDepartments = $UserDepartmentsTable(
    this,
  );
  late final $TasksTable tasks = $TasksTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $DiningRoomsTable diningRooms = $DiningRoomsTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $RecordLocationsTable recordLocations = $RecordLocationsTable(
    this,
  );
  late final $FormFieldConfigsTable formFieldConfigs = $FormFieldConfigsTable(
    this,
  );
  late final $TableColumnConfigsTable tableColumnConfigs =
      $TableColumnConfigsTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    roles,
    crops,
    positions,
    departments,
    operators,
    users,
    userDepartments,
    tasks,
    locations,
    diningRooms,
    records,
    recordLocations,
    formFieldConfigs,
    tableColumnConfigs,
    syncQueueItems,
  ];
}

typedef $$RolesTableCreateCompanionBuilder =
    RolesCompanion Function({
      required String id,
      required String name,
      Value<bool> isAdmin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$RolesTableUpdateCompanionBuilder =
    RolesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> isAdmin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$RolesTableReferences
    extends BaseReferences<_$AppDatabase, $RolesTable, LocalRole> {
  $$RolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsersTable, List<LocalUser>> _usersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.users,
    aliasName: $_aliasNameGenerator(db.roles.id, db.users.roleId),
  );

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.roleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usersRefs(
    Expression<bool> Function($$UsersTableFilterComposer f) f,
  ) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAdmin => $composableBuilder(
    column: $table.isAdmin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isAdmin =>
      $composableBuilder(column: $table.isAdmin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> usersRefs<T extends Object>(
    Expression<T> Function($$UsersTableAnnotationComposer a) f,
  ) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RolesTable,
          LocalRole,
          $$RolesTableFilterComposer,
          $$RolesTableOrderingComposer,
          $$RolesTableAnnotationComposer,
          $$RolesTableCreateCompanionBuilder,
          $$RolesTableUpdateCompanionBuilder,
          (LocalRole, $$RolesTableReferences),
          LocalRole,
          PrefetchHooks Function({bool usersRefs})
        > {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isAdmin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion(
                id: id,
                name: name,
                isAdmin: isAdmin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isAdmin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RolesCompanion.insert(
                id: id,
                name: name,
                isAdmin: isAdmin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RolesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({usersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usersRefs) db.users],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usersRefs)
                    await $_getPrefetchedData<
                      LocalRole,
                      $RolesTable,
                      LocalUser
                    >(
                      currentTable: table,
                      referencedTable: $$RolesTableReferences._usersRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$RolesTableReferences(db, table, p0).usersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.roleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RolesTable,
      LocalRole,
      $$RolesTableFilterComposer,
      $$RolesTableOrderingComposer,
      $$RolesTableAnnotationComposer,
      $$RolesTableCreateCompanionBuilder,
      $$RolesTableUpdateCompanionBuilder,
      (LocalRole, $$RolesTableReferences),
      LocalRole,
      PrefetchHooks Function({bool usersRefs})
    >;
typedef $$CropsTableCreateCompanionBuilder =
    CropsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String name,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$CropsTableUpdateCompanionBuilder =
    CropsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> name,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$CropsTableReferences
    extends BaseReferences<_$AppDatabase, $CropsTable, Crop> {
  $$CropsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DepartmentsTable, List<Department>>
  _departmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.departments,
    aliasName: $_aliasNameGenerator(db.crops.id, db.departments.cropId),
  );

  $$DepartmentsTableProcessedTableManager get departmentsRefs {
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_departmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<FarmTask>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.crops.id, db.tasks.cropId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LocationsTable, List<LocationEntry>>
  _locationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.locations,
    aliasName: $_aliasNameGenerator(db.crops.id, db.locations.cropId),
  );

  $$LocationsTableProcessedTableManager get locationsRefs {
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_locationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiningRoomsTable, List<DiningRoom>>
  _diningRoomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diningRooms,
    aliasName: $_aliasNameGenerator(db.crops.id, db.diningRooms.cropId),
  );

  $$DiningRoomsTableProcessedTableManager get diningRoomsRefs {
    final manager = $$DiningRoomsTableTableManager(
      $_db,
      $_db.diningRooms,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diningRoomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.crops.id, db.records.cropId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.cropId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CropsTableFilterComposer extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> departmentsRefs(
    Expression<bool> Function($$DepartmentsTableFilterComposer f) f,
  ) {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> locationsRefs(
    Expression<bool> Function($$LocationsTableFilterComposer f) f,
  ) {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diningRoomsRefs(
    Expression<bool> Function($$DiningRoomsTableFilterComposer f) f,
  ) {
    final $$DiningRoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diningRooms,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiningRoomsTableFilterComposer(
            $db: $db,
            $table: $db.diningRooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CropsTableOrderingComposer
    extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CropsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CropsTable> {
  $$CropsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> departmentsRefs<T extends Object>(
    Expression<T> Function($$DepartmentsTableAnnotationComposer a) f,
  ) {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> locationsRefs<T extends Object>(
    Expression<T> Function($$LocationsTableAnnotationComposer a) f,
  ) {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diningRoomsRefs<T extends Object>(
    Expression<T> Function($$DiningRoomsTableAnnotationComposer a) f,
  ) {
    final $$DiningRoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diningRooms,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiningRoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.diningRooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.cropId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CropsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CropsTable,
          Crop,
          $$CropsTableFilterComposer,
          $$CropsTableOrderingComposer,
          $$CropsTableAnnotationComposer,
          $$CropsTableCreateCompanionBuilder,
          $$CropsTableUpdateCompanionBuilder,
          (Crop, $$CropsTableReferences),
          Crop,
          PrefetchHooks Function({
            bool departmentsRefs,
            bool tasksRefs,
            bool locationsRefs,
            bool diningRoomsRefs,
            bool recordsRefs,
          })
        > {
  $$CropsTableTableManager(_$AppDatabase db, $CropsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CropsCompanion(
                id: id,
                serverId: serverId,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CropsCompanion.insert(
                id: id,
                serverId: serverId,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CropsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                departmentsRefs = false,
                tasksRefs = false,
                locationsRefs = false,
                diningRoomsRefs = false,
                recordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (departmentsRefs) db.departments,
                    if (tasksRefs) db.tasks,
                    if (locationsRefs) db.locations,
                    if (diningRoomsRefs) db.diningRooms,
                    if (recordsRefs) db.records,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (departmentsRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          Department
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._departmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(
                                db,
                                table,
                                p0,
                              ).departmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<Crop, $CropsTable, FarmTask>(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(db, table, p0).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (locationsRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          LocationEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._locationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(
                                db,
                                table,
                                p0,
                              ).locationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diningRoomsRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          DiningRoom
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._diningRoomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(
                                db,
                                table,
                                p0,
                              ).diningRoomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordsRefs)
                        await $_getPrefetchedData<
                          Crop,
                          $CropsTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$CropsTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CropsTableReferences(db, table, p0).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cropId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CropsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CropsTable,
      Crop,
      $$CropsTableFilterComposer,
      $$CropsTableOrderingComposer,
      $$CropsTableAnnotationComposer,
      $$CropsTableCreateCompanionBuilder,
      $$CropsTableUpdateCompanionBuilder,
      (Crop, $$CropsTableReferences),
      Crop,
      PrefetchHooks Function({
        bool departmentsRefs,
        bool tasksRefs,
        bool locationsRefs,
        bool diningRoomsRefs,
        bool recordsRefs,
      })
    >;
typedef $$PositionsTableCreateCompanionBuilder =
    PositionsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String name,
      Value<bool> canBeLeader,
      Value<bool> canLogin,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$PositionsTableUpdateCompanionBuilder =
    PositionsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> name,
      Value<bool> canBeLeader,
      Value<bool> canLogin,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$PositionsTableReferences
    extends BaseReferences<_$AppDatabase, $PositionsTable, OperatorPosition> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OperatorsTable, List<FarmOperator>>
  _operatorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.operators,
    aliasName: $_aliasNameGenerator(db.positions.id, db.operators.positionId),
  );

  $$OperatorsTableProcessedTableManager get operatorsRefs {
    final manager = $$OperatorsTableTableManager(
      $_db,
      $_db.operators,
    ).filter((f) => f.positionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_operatorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canBeLeader => $composableBuilder(
    column: $table.canBeLeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canLogin => $composableBuilder(
    column: $table.canLogin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> operatorsRefs(
    Expression<bool> Function($$OperatorsTableFilterComposer f) f,
  ) {
    final $$OperatorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableFilterComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canBeLeader => $composableBuilder(
    column: $table.canBeLeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canLogin => $composableBuilder(
    column: $table.canLogin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get canBeLeader => $composableBuilder(
    column: $table.canBeLeader,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get canLogin =>
      $composableBuilder(column: $table.canLogin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  Expression<T> operatorsRefs<T extends Object>(
    Expression<T> Function($$OperatorsTableAnnotationComposer a) f,
  ) {
    final $$OperatorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableAnnotationComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PositionsTable,
          OperatorPosition,
          $$PositionsTableFilterComposer,
          $$PositionsTableOrderingComposer,
          $$PositionsTableAnnotationComposer,
          $$PositionsTableCreateCompanionBuilder,
          $$PositionsTableUpdateCompanionBuilder,
          (OperatorPosition, $$PositionsTableReferences),
          OperatorPosition,
          PrefetchHooks Function({bool operatorsRefs})
        > {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> canBeLeader = const Value.absent(),
                Value<bool> canLogin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PositionsCompanion(
                id: id,
                serverId: serverId,
                name: name,
                canBeLeader: canBeLeader,
                canLogin: canLogin,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String name,
                Value<bool> canBeLeader = const Value.absent(),
                Value<bool> canLogin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PositionsCompanion.insert(
                id: id,
                serverId: serverId,
                name: name,
                canBeLeader: canBeLeader,
                canLogin: canLogin,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({operatorsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (operatorsRefs) db.operators],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (operatorsRefs)
                    await $_getPrefetchedData<
                      OperatorPosition,
                      $PositionsTable,
                      FarmOperator
                    >(
                      currentTable: table,
                      referencedTable: $$PositionsTableReferences
                          ._operatorsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PositionsTableReferences(
                            db,
                            table,
                            p0,
                          ).operatorsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.positionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PositionsTable,
      OperatorPosition,
      $$PositionsTableFilterComposer,
      $$PositionsTableOrderingComposer,
      $$PositionsTableAnnotationComposer,
      $$PositionsTableCreateCompanionBuilder,
      $$PositionsTableUpdateCompanionBuilder,
      (OperatorPosition, $$PositionsTableReferences),
      OperatorPosition,
      PrefetchHooks Function({bool operatorsRefs})
    >;
typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String name,
      Value<String?> cropId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> name,
      Value<String?> cropId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$DepartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $DepartmentsTable, Department> {
  $$DepartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.departments.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager? get cropId {
    final $_column = $_itemColumn<String>('crop_id');
    if ($_column == null) return null;
    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OperatorsTable, List<FarmOperator>>
  _operatorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.operators,
    aliasName: $_aliasNameGenerator(
      db.departments.id,
      db.operators.departmentId,
    ),
  );

  $$OperatorsTableProcessedTableManager get operatorsRefs {
    final manager = $$OperatorsTableTableManager(
      $_db,
      $_db.operators,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_operatorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserDepartmentsTable, List<UserDepartment>>
  _userDepartmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userDepartments,
    aliasName: $_aliasNameGenerator(
      db.departments.id,
      db.userDepartments.departmentId,
    ),
  );

  $$UserDepartmentsTableProcessedTableManager get userDepartmentsRefs {
    final manager = $$UserDepartmentsTableTableManager(
      $_db,
      $_db.userDepartments,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userDepartmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<FarmTask>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.departments.id, db.tasks.departmentId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.departments.id, db.records.departmentId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FormFieldConfigsTable, List<FormFieldConfig>>
  _formFieldConfigsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.formFieldConfigs,
    aliasName: $_aliasNameGenerator(
      db.departments.id,
      db.formFieldConfigs.departmentId,
    ),
  );

  $$FormFieldConfigsTableProcessedTableManager get formFieldConfigsRefs {
    final manager = $$FormFieldConfigsTableTableManager(
      $_db,
      $_db.formFieldConfigs,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _formFieldConfigsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TableColumnConfigsTable, List<TableColumnConfig>>
  _tableColumnConfigsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tableColumnConfigs,
        aliasName: $_aliasNameGenerator(
          db.departments.id,
          db.tableColumnConfigs.departmentId,
        ),
      );

  $$TableColumnConfigsTableProcessedTableManager get tableColumnConfigsRefs {
    final manager = $$TableColumnConfigsTableTableManager(
      $_db,
      $_db.tableColumnConfigs,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tableColumnConfigsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> operatorsRefs(
    Expression<bool> Function($$OperatorsTableFilterComposer f) f,
  ) {
    final $$OperatorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableFilterComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userDepartmentsRefs(
    Expression<bool> Function($$UserDepartmentsTableFilterComposer f) f,
  ) {
    final $$UserDepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userDepartments,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserDepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.userDepartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> formFieldConfigsRefs(
    Expression<bool> Function($$FormFieldConfigsTableFilterComposer f) f,
  ) {
    final $$FormFieldConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formFieldConfigs,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormFieldConfigsTableFilterComposer(
            $db: $db,
            $table: $db.formFieldConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tableColumnConfigsRefs(
    Expression<bool> Function($$TableColumnConfigsTableFilterComposer f) f,
  ) {
    final $$TableColumnConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tableColumnConfigs,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableColumnConfigsTableFilterComposer(
            $db: $db,
            $table: $db.tableColumnConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> operatorsRefs<T extends Object>(
    Expression<T> Function($$OperatorsTableAnnotationComposer a) f,
  ) {
    final $$OperatorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableAnnotationComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userDepartmentsRefs<T extends Object>(
    Expression<T> Function($$UserDepartmentsTableAnnotationComposer a) f,
  ) {
    final $$UserDepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userDepartments,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserDepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.userDepartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> formFieldConfigsRefs<T extends Object>(
    Expression<T> Function($$FormFieldConfigsTableAnnotationComposer a) f,
  ) {
    final $$FormFieldConfigsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formFieldConfigs,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormFieldConfigsTableAnnotationComposer(
            $db: $db,
            $table: $db.formFieldConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tableColumnConfigsRefs<T extends Object>(
    Expression<T> Function($$TableColumnConfigsTableAnnotationComposer a) f,
  ) {
    final $$TableColumnConfigsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tableColumnConfigs,
          getReferencedColumn: (t) => t.departmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TableColumnConfigsTableAnnotationComposer(
                $db: $db,
                $table: $db.tableColumnConfigs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (Department, $$DepartmentsTableReferences),
          Department,
          PrefetchHooks Function({
            bool cropId,
            bool operatorsRefs,
            bool userDepartmentsRefs,
            bool tasksRefs,
            bool recordsRefs,
            bool formFieldConfigsRefs,
            bool tableColumnConfigsRefs,
          })
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> cropId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                serverId: serverId,
                name: name,
                cropId: cropId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String name,
                Value<String?> cropId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                serverId: serverId,
                name: name,
                cropId: cropId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cropId = false,
                operatorsRefs = false,
                userDepartmentsRefs = false,
                tasksRefs = false,
                recordsRefs = false,
                formFieldConfigsRefs = false,
                tableColumnConfigsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (operatorsRefs) db.operators,
                    if (userDepartmentsRefs) db.userDepartments,
                    if (tasksRefs) db.tasks,
                    if (recordsRefs) db.records,
                    if (formFieldConfigsRefs) db.formFieldConfigs,
                    if (tableColumnConfigsRefs) db.tableColumnConfigs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cropId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cropId,
                                    referencedTable:
                                        $$DepartmentsTableReferences
                                            ._cropIdTable(db),
                                    referencedColumn:
                                        $$DepartmentsTableReferences
                                            ._cropIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (operatorsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          FarmOperator
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._operatorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).operatorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userDepartmentsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          UserDepartment
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._userDepartmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).userDepartmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          FarmTask
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (formFieldConfigsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          FormFieldConfig
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._formFieldConfigsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).formFieldConfigsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tableColumnConfigsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          TableColumnConfig
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._tableColumnConfigsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).tableColumnConfigsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (Department, $$DepartmentsTableReferences),
      Department,
      PrefetchHooks Function({
        bool cropId,
        bool operatorsRefs,
        bool userDepartmentsRefs,
        bool tasksRefs,
        bool recordsRefs,
        bool formFieldConfigsRefs,
        bool tableColumnConfigsRefs,
      })
    >;
typedef $$OperatorsTableCreateCompanionBuilder =
    OperatorsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String code,
      required String fullName,
      Value<String?> departmentId,
      Value<String?> positionId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$OperatorsTableUpdateCompanionBuilder =
    OperatorsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> code,
      Value<String> fullName,
      Value<String?> departmentId,
      Value<String?> positionId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$OperatorsTableReferences
    extends BaseReferences<_$AppDatabase, $OperatorsTable, FarmOperator> {
  $$OperatorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(db.operators.departmentId, db.departments.id),
      );

  $$DepartmentsTableProcessedTableManager? get departmentId {
    final $_column = $_itemColumn<String>('department_id');
    if ($_column == null) return null;
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PositionsTable _positionIdTable(_$AppDatabase db) =>
      db.positions.createAlias(
        $_aliasNameGenerator(db.operators.positionId, db.positions.id),
      );

  $$PositionsTableProcessedTableManager? get positionId {
    final $_column = $_itemColumn<String>('position_id');
    if ($_column == null) return null;
    final manager = $$PositionsTableTableManager(
      $_db,
      $_db.positions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_positionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$UsersTable, List<LocalUser>> _usersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.users,
    aliasName: $_aliasNameGenerator(db.operators.id, db.users.operatorId),
  );

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.operatorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>>
  _programmedOperatorRecordsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.records,
        aliasName: $_aliasNameGenerator(db.operators.id, db.records.operatorId),
      );

  $$RecordsTableProcessedTableManager get programmedOperatorRecords {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.operatorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _programmedOperatorRecordsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>>
  _leaderRecordsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(
      db.operators.id,
      db.records.leaderOperatorId,
    ),
  );

  $$RecordsTableProcessedTableManager get leaderRecords {
    final manager = $$RecordsTableTableManager($_db, $_db.records).filter(
      (f) => f.leaderOperatorId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_leaderRecordsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OperatorsTableFilterComposer
    extends Composer<_$AppDatabase, $OperatorsTable> {
  $$OperatorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PositionsTableFilterComposer get positionId {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableFilterComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> usersRefs(
    Expression<bool> Function($$UsersTableFilterComposer f) f,
  ) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.operatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> programmedOperatorRecords(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.operatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> leaderRecords(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.leaderOperatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OperatorsTableOrderingComposer
    extends Composer<_$AppDatabase, $OperatorsTable> {
  $$OperatorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PositionsTableOrderingComposer get positionId {
    final $$PositionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableOrderingComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OperatorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OperatorsTable> {
  $$OperatorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PositionsTableAnnotationComposer get positionId {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> usersRefs<T extends Object>(
    Expression<T> Function($$UsersTableAnnotationComposer a) f,
  ) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.operatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> programmedOperatorRecords<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.operatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> leaderRecords<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.leaderOperatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OperatorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OperatorsTable,
          FarmOperator,
          $$OperatorsTableFilterComposer,
          $$OperatorsTableOrderingComposer,
          $$OperatorsTableAnnotationComposer,
          $$OperatorsTableCreateCompanionBuilder,
          $$OperatorsTableUpdateCompanionBuilder,
          (FarmOperator, $$OperatorsTableReferences),
          FarmOperator,
          PrefetchHooks Function({
            bool departmentId,
            bool positionId,
            bool usersRefs,
            bool programmedOperatorRecords,
            bool leaderRecords,
          })
        > {
  $$OperatorsTableTableManager(_$AppDatabase db, $OperatorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperatorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperatorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperatorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String?> positionId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OperatorsCompanion(
                id: id,
                serverId: serverId,
                code: code,
                fullName: fullName,
                departmentId: departmentId,
                positionId: positionId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String code,
                required String fullName,
                Value<String?> departmentId = const Value.absent(),
                Value<String?> positionId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OperatorsCompanion.insert(
                id: id,
                serverId: serverId,
                code: code,
                fullName: fullName,
                departmentId: departmentId,
                positionId: positionId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OperatorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                departmentId = false,
                positionId = false,
                usersRefs = false,
                programmedOperatorRecords = false,
                leaderRecords = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (usersRefs) db.users,
                    if (programmedOperatorRecords) db.records,
                    if (leaderRecords) db.records,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (departmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.departmentId,
                                    referencedTable: $$OperatorsTableReferences
                                        ._departmentIdTable(db),
                                    referencedColumn: $$OperatorsTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (positionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.positionId,
                                    referencedTable: $$OperatorsTableReferences
                                        ._positionIdTable(db),
                                    referencedColumn: $$OperatorsTableReferences
                                        ._positionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (usersRefs)
                        await $_getPrefetchedData<
                          FarmOperator,
                          $OperatorsTable,
                          LocalUser
                        >(
                          currentTable: table,
                          referencedTable: $$OperatorsTableReferences
                              ._usersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OperatorsTableReferences(
                                db,
                                table,
                                p0,
                              ).usersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.operatorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (programmedOperatorRecords)
                        await $_getPrefetchedData<
                          FarmOperator,
                          $OperatorsTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$OperatorsTableReferences
                              ._programmedOperatorRecordsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OperatorsTableReferences(
                                db,
                                table,
                                p0,
                              ).programmedOperatorRecords,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.operatorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (leaderRecords)
                        await $_getPrefetchedData<
                          FarmOperator,
                          $OperatorsTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$OperatorsTableReferences
                              ._leaderRecordsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OperatorsTableReferences(
                                db,
                                table,
                                p0,
                              ).leaderRecords,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.leaderOperatorId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OperatorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OperatorsTable,
      FarmOperator,
      $$OperatorsTableFilterComposer,
      $$OperatorsTableOrderingComposer,
      $$OperatorsTableAnnotationComposer,
      $$OperatorsTableCreateCompanionBuilder,
      $$OperatorsTableUpdateCompanionBuilder,
      (FarmOperator, $$OperatorsTableReferences),
      FarmOperator,
      PrefetchHooks Function({
        bool departmentId,
        bool positionId,
        bool usersRefs,
        bool programmedOperatorRecords,
        bool leaderRecords,
      })
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      Value<String?> serverId,
      required String code,
      required String fullName,
      required String passwordPin,
      required String roleId,
      Value<String?> operatorId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> code,
      Value<String> fullName,
      Value<String> passwordPin,
      Value<String> roleId,
      Value<String?> operatorId,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, LocalUser> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RolesTable _roleIdTable(_$AppDatabase db) =>
      db.roles.createAlias($_aliasNameGenerator(db.users.roleId, db.roles.id));

  $$RolesTableProcessedTableManager get roleId {
    final $_column = $_itemColumn<String>('role_id')!;

    final manager = $$RolesTableTableManager(
      $_db,
      $_db.roles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OperatorsTable _operatorIdTable(_$AppDatabase db) => db.operators
      .createAlias($_aliasNameGenerator(db.users.operatorId, db.operators.id));

  $$OperatorsTableProcessedTableManager? get operatorId {
    final $_column = $_itemColumn<String>('operator_id');
    if ($_column == null) return null;
    final manager = $$OperatorsTableTableManager(
      $_db,
      $_db.operators,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_operatorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$UserDepartmentsTable, List<UserDepartment>>
  _userDepartmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userDepartments,
    aliasName: $_aliasNameGenerator(db.users.id, db.userDepartments.userId),
  );

  $$UserDepartmentsTableProcessedTableManager get userDepartmentsRefs {
    final manager = $$UserDepartmentsTableTableManager(
      $_db,
      $_db.userDepartments,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userDepartmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.users.id, db.records.createdByUserId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager($_db, $_db.records).filter(
      (f) => f.createdByUserId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordPin => $composableBuilder(
    column: $table.passwordPin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$RolesTableFilterComposer get roleId {
    final $$RolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableFilterComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableFilterComposer get operatorId {
    final $$OperatorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableFilterComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> userDepartmentsRefs(
    Expression<bool> Function($$UserDepartmentsTableFilterComposer f) f,
  ) {
    final $$UserDepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userDepartments,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserDepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.userDepartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.createdByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordPin => $composableBuilder(
    column: $table.passwordPin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$RolesTableOrderingComposer get roleId {
    final $$RolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableOrderingComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableOrderingComposer get operatorId {
    final $$OperatorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableOrderingComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get passwordPin => $composableBuilder(
    column: $table.passwordPin,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$RolesTableAnnotationComposer get roleId {
    final $$RolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableAnnotationComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableAnnotationComposer get operatorId {
    final $$OperatorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableAnnotationComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> userDepartmentsRefs<T extends Object>(
    Expression<T> Function($$UserDepartmentsTableAnnotationComposer a) f,
  ) {
    final $$UserDepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userDepartments,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserDepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.userDepartments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.createdByUserId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          LocalUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (LocalUser, $$UsersTableReferences),
          LocalUser,
          PrefetchHooks Function({
            bool roleId,
            bool operatorId,
            bool userDepartmentsRefs,
            bool recordsRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> passwordPin = const Value.absent(),
                Value<String> roleId = const Value.absent(),
                Value<String?> operatorId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                serverId: serverId,
                code: code,
                fullName: fullName,
                passwordPin: passwordPin,
                roleId: roleId,
                operatorId: operatorId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String code,
                required String fullName,
                required String passwordPin,
                required String roleId,
                Value<String?> operatorId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                serverId: serverId,
                code: code,
                fullName: fullName,
                passwordPin: passwordPin,
                roleId: roleId,
                operatorId: operatorId,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                roleId = false,
                operatorId = false,
                userDepartmentsRefs = false,
                recordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userDepartmentsRefs) db.userDepartments,
                    if (recordsRefs) db.records,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.roleId,
                                    referencedTable: $$UsersTableReferences
                                        ._roleIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._roleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (operatorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.operatorId,
                                    referencedTable: $$UsersTableReferences
                                        ._operatorIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._operatorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userDepartmentsRefs)
                        await $_getPrefetchedData<
                          LocalUser,
                          $UsersTable,
                          UserDepartment
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userDepartmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userDepartmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordsRefs)
                        await $_getPrefetchedData<
                          LocalUser,
                          $UsersTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.createdByUserId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      LocalUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (LocalUser, $$UsersTableReferences),
      LocalUser,
      PrefetchHooks Function({
        bool roleId,
        bool operatorId,
        bool userDepartmentsRefs,
        bool recordsRefs,
      })
    >;
typedef $$UserDepartmentsTableCreateCompanionBuilder =
    UserDepartmentsCompanion Function({
      required String id,
      required String userId,
      required String departmentId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$UserDepartmentsTableUpdateCompanionBuilder =
    UserDepartmentsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> departmentId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$UserDepartmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserDepartmentsTable, UserDepartment> {
  $$UserDepartmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
    $_aliasNameGenerator(db.userDepartments.userId, db.users.id),
  );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(
          db.userDepartments.departmentId,
          db.departments.id,
        ),
      );

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<String>('department_id')!;

    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserDepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $UserDepartmentsTable> {
  $$UserDepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserDepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserDepartmentsTable> {
  $$UserDepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserDepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserDepartmentsTable> {
  $$UserDepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserDepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserDepartmentsTable,
          UserDepartment,
          $$UserDepartmentsTableFilterComposer,
          $$UserDepartmentsTableOrderingComposer,
          $$UserDepartmentsTableAnnotationComposer,
          $$UserDepartmentsTableCreateCompanionBuilder,
          $$UserDepartmentsTableUpdateCompanionBuilder,
          (UserDepartment, $$UserDepartmentsTableReferences),
          UserDepartment,
          PrefetchHooks Function({bool userId, bool departmentId})
        > {
  $$UserDepartmentsTableTableManager(
    _$AppDatabase db,
    $UserDepartmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserDepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserDepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserDepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserDepartmentsCompanion(
                id: id,
                userId: userId,
                departmentId: departmentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String departmentId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserDepartmentsCompanion.insert(
                id: id,
                userId: userId,
                departmentId: departmentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserDepartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$UserDepartmentsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$UserDepartmentsTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable:
                                    $$UserDepartmentsTableReferences
                                        ._departmentIdTable(db),
                                referencedColumn:
                                    $$UserDepartmentsTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserDepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserDepartmentsTable,
      UserDepartment,
      $$UserDepartmentsTableFilterComposer,
      $$UserDepartmentsTableOrderingComposer,
      $$UserDepartmentsTableAnnotationComposer,
      $$UserDepartmentsTableCreateCompanionBuilder,
      $$UserDepartmentsTableUpdateCompanionBuilder,
      (UserDepartment, $$UserDepartmentsTableReferences),
      UserDepartment,
      PrefetchHooks Function({bool userId, bool departmentId})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      Value<String?> serverId,
      Value<String?> departmentId,
      Value<String?> cropId,
      Value<String?> code,
      required String name,
      Value<String?> defaultDetail,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String?> departmentId,
      Value<String?> cropId,
      Value<String?> code,
      Value<String> name,
      Value<String?> defaultDetail,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, FarmTask> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(db.tasks.departmentId, db.departments.id),
      );

  $$DepartmentsTableProcessedTableManager? get departmentId {
    final $_column = $_itemColumn<String>('department_id');
    if ($_column == null) return null;
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CropsTable _cropIdTable(_$AppDatabase db) =>
      db.crops.createAlias($_aliasNameGenerator(db.tasks.cropId, db.crops.id));

  $$CropsTableProcessedTableManager? get cropId {
    final $_column = $_itemColumn<String>('crop_id');
    if ($_column == null) return null;
    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.records.taskId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDetail => $composableBuilder(
    column: $table.defaultDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDetail => $composableBuilder(
    column: $table.defaultDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultDetail => $composableBuilder(
    column: $table.defaultDetail,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          FarmTask,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (FarmTask, $$TasksTableReferences),
          FarmTask,
          PrefetchHooks Function({
            bool departmentId,
            bool cropId,
            bool recordsRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String?> cropId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> defaultDetail = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                serverId: serverId,
                departmentId: departmentId,
                cropId: cropId,
                code: code,
                name: name,
                defaultDetail: defaultDetail,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String?> cropId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                required String name,
                Value<String?> defaultDetail = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                serverId: serverId,
                departmentId: departmentId,
                cropId: cropId,
                code: code,
                name: name,
                defaultDetail: defaultDetail,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({departmentId = false, cropId = false, recordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (recordsRefs) db.records],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (departmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.departmentId,
                                    referencedTable: $$TasksTableReferences
                                        ._departmentIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (cropId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cropId,
                                    referencedTable: $$TasksTableReferences
                                        ._cropIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._cropIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordsRefs)
                        await $_getPrefetchedData<
                          FarmTask,
                          $TasksTable,
                          FarmRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._recordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(db, table, p0).recordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      FarmTask,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (FarmTask, $$TasksTableReferences),
      FarmTask,
      PrefetchHooks Function({bool departmentId, bool cropId, bool recordsRefs})
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String cropId,
      required String lot,
      required String network,
      required String sector,
      Value<String?> farmType,
      required double ha,
      Value<String?> suggestedDiningRoom,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> cropId,
      Value<String> lot,
      Value<String> network,
      Value<String> sector,
      Value<String?> farmType,
      Value<double> ha,
      Value<String?> suggestedDiningRoom,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, LocationEntry> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.locations.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager get cropId {
    final $_column = $_itemColumn<String>('crop_id')!;

    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecordLocationsTable, List<FarmRecordLocation>>
  _recordLocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordLocations,
    aliasName: $_aliasNameGenerator(
      db.locations.id,
      db.recordLocations.locationId,
    ),
  );

  $$RecordLocationsTableProcessedTableManager get recordLocationsRefs {
    final manager = $$RecordLocationsTableTableManager(
      $_db,
      $_db.recordLocations,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recordLocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmType => $composableBuilder(
    column: $table.farmType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ha => $composableBuilder(
    column: $table.ha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedDiningRoom => $composableBuilder(
    column: $table.suggestedDiningRoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recordLocationsRefs(
    Expression<bool> Function($$RecordLocationsTableFilterComposer f) f,
  ) {
    final $$RecordLocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordLocations,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordLocationsTableFilterComposer(
            $db: $db,
            $table: $db.recordLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmType => $composableBuilder(
    column: $table.farmType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ha => $composableBuilder(
    column: $table.ha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedDiningRoom => $composableBuilder(
    column: $table.suggestedDiningRoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get lot =>
      $composableBuilder(column: $table.lot, builder: (column) => column);

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<String> get farmType =>
      $composableBuilder(column: $table.farmType, builder: (column) => column);

  GeneratedColumn<double> get ha =>
      $composableBuilder(column: $table.ha, builder: (column) => column);

  GeneratedColumn<String> get suggestedDiningRoom => $composableBuilder(
    column: $table.suggestedDiningRoom,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recordLocationsRefs<T extends Object>(
    Expression<T> Function($$RecordLocationsTableAnnotationComposer a) f,
  ) {
    final $$RecordLocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordLocations,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordLocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.recordLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          LocationEntry,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (LocationEntry, $$LocationsTableReferences),
          LocationEntry,
          PrefetchHooks Function({bool cropId, bool recordLocationsRefs})
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> cropId = const Value.absent(),
                Value<String> lot = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<String> sector = const Value.absent(),
                Value<String?> farmType = const Value.absent(),
                Value<double> ha = const Value.absent(),
                Value<String?> suggestedDiningRoom = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                serverId: serverId,
                cropId: cropId,
                lot: lot,
                network: network,
                sector: sector,
                farmType: farmType,
                ha: ha,
                suggestedDiningRoom: suggestedDiningRoom,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String cropId,
                required String lot,
                required String network,
                required String sector,
                Value<String?> farmType = const Value.absent(),
                required double ha,
                Value<String?> suggestedDiningRoom = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                serverId: serverId,
                cropId: cropId,
                lot: lot,
                network: network,
                sector: sector,
                farmType: farmType,
                ha: ha,
                suggestedDiningRoom: suggestedDiningRoom,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cropId = false, recordLocationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recordLocationsRefs) db.recordLocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cropId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cropId,
                                    referencedTable: $$LocationsTableReferences
                                        ._cropIdTable(db),
                                    referencedColumn: $$LocationsTableReferences
                                        ._cropIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordLocationsRefs)
                        await $_getPrefetchedData<
                          LocationEntry,
                          $LocationsTable,
                          FarmRecordLocation
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._recordLocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordLocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.locationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      LocationEntry,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (LocationEntry, $$LocationsTableReferences),
      LocationEntry,
      PrefetchHooks Function({bool cropId, bool recordLocationsRefs})
    >;
typedef $$DiningRoomsTableCreateCompanionBuilder =
    DiningRoomsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String cropId,
      required String name,
      Value<String?> lot,
      Value<String?> network,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$DiningRoomsTableUpdateCompanionBuilder =
    DiningRoomsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> cropId,
      Value<String> name,
      Value<String?> lot,
      Value<String?> network,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$DiningRoomsTableReferences
    extends BaseReferences<_$AppDatabase, $DiningRoomsTable, DiningRoom> {
  $$DiningRoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.diningRooms.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager get cropId {
    final $_column = $_itemColumn<String>('crop_id')!;

    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecordsTable, List<FarmRecord>> _recordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.records,
    aliasName: $_aliasNameGenerator(db.diningRooms.id, db.records.diningRoomId),
  );

  $$RecordsTableProcessedTableManager get recordsRefs {
    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.diningRoomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiningRoomsTableFilterComposer
    extends Composer<_$AppDatabase, $DiningRoomsTable> {
  $$DiningRoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recordsRefs(
    Expression<bool> Function($$RecordsTableFilterComposer f) f,
  ) {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.diningRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiningRoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiningRoomsTable> {
  $$DiningRoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiningRoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiningRoomsTable> {
  $$DiningRoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lot =>
      $composableBuilder(column: $table.lot, builder: (column) => column);

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recordsRefs<T extends Object>(
    Expression<T> Function($$RecordsTableAnnotationComposer a) f,
  ) {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.diningRoomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiningRoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiningRoomsTable,
          DiningRoom,
          $$DiningRoomsTableFilterComposer,
          $$DiningRoomsTableOrderingComposer,
          $$DiningRoomsTableAnnotationComposer,
          $$DiningRoomsTableCreateCompanionBuilder,
          $$DiningRoomsTableUpdateCompanionBuilder,
          (DiningRoom, $$DiningRoomsTableReferences),
          DiningRoom,
          PrefetchHooks Function({bool cropId, bool recordsRefs})
        > {
  $$DiningRoomsTableTableManager(_$AppDatabase db, $DiningRoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiningRoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiningRoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiningRoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> cropId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> lot = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiningRoomsCompanion(
                id: id,
                serverId: serverId,
                cropId: cropId,
                name: name,
                lot: lot,
                network: network,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String cropId,
                required String name,
                Value<String?> lot = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiningRoomsCompanion.insert(
                id: id,
                serverId: serverId,
                cropId: cropId,
                name: name,
                lot: lot,
                network: network,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiningRoomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cropId = false, recordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recordsRefs) db.records],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cropId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cropId,
                                referencedTable: $$DiningRoomsTableReferences
                                    ._cropIdTable(db),
                                referencedColumn: $$DiningRoomsTableReferences
                                    ._cropIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recordsRefs)
                    await $_getPrefetchedData<
                      DiningRoom,
                      $DiningRoomsTable,
                      FarmRecord
                    >(
                      currentTable: table,
                      referencedTable: $$DiningRoomsTableReferences
                          ._recordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DiningRoomsTableReferences(
                            db,
                            table,
                            p0,
                          ).recordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.diningRoomId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DiningRoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiningRoomsTable,
      DiningRoom,
      $$DiningRoomsTableFilterComposer,
      $$DiningRoomsTableOrderingComposer,
      $$DiningRoomsTableAnnotationComposer,
      $$DiningRoomsTableCreateCompanionBuilder,
      $$DiningRoomsTableUpdateCompanionBuilder,
      (DiningRoom, $$DiningRoomsTableReferences),
      DiningRoom,
      PrefetchHooks Function({bool cropId, bool recordsRefs})
    >;
typedef $$RecordsTableCreateCompanionBuilder =
    RecordsCompanion Function({
      required String id,
      Value<String?> serverId,
      required DateTime recordDate,
      required int weekNumber,
      required String departmentId,
      required String createdByUserId,
      required String userCode,
      Value<String?> operatorId,
      Value<String?> operatorNameSnapshot,
      Value<String?> leaderOperatorId,
      Value<String?> leaderCodeSnapshot,
      Value<String?> leaderNameSnapshot,
      Value<String?> cropId,
      Value<String?> cropNameSnapshot,
      Value<String?> taskId,
      Value<String?> taskCodeSnapshot,
      Value<String?> taskNameSnapshot,
      Value<String?> taskDetail,
      Value<String?> lot,
      Value<String?> network,
      Value<double?> scheduledWage,
      Value<double?> realWage,
      Value<double> ha,
      Value<double?> ratio,
      Value<String?> diningRoomId,
      Value<String?> diningRoom,
      Value<String?> observation,
      Value<String?> extraFieldsJson,
      Value<bool> isActive,
      Value<bool> isLocked,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$RecordsTableUpdateCompanionBuilder =
    RecordsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<DateTime> recordDate,
      Value<int> weekNumber,
      Value<String> departmentId,
      Value<String> createdByUserId,
      Value<String> userCode,
      Value<String?> operatorId,
      Value<String?> operatorNameSnapshot,
      Value<String?> leaderOperatorId,
      Value<String?> leaderCodeSnapshot,
      Value<String?> leaderNameSnapshot,
      Value<String?> cropId,
      Value<String?> cropNameSnapshot,
      Value<String?> taskId,
      Value<String?> taskCodeSnapshot,
      Value<String?> taskNameSnapshot,
      Value<String?> taskDetail,
      Value<String?> lot,
      Value<String?> network,
      Value<double?> scheduledWage,
      Value<double?> realWage,
      Value<double> ha,
      Value<double?> ratio,
      Value<String?> diningRoomId,
      Value<String?> diningRoom,
      Value<String?> observation,
      Value<String?> extraFieldsJson,
      Value<bool> isActive,
      Value<bool> isLocked,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$RecordsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordsTable, FarmRecord> {
  $$RecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(db.records.departmentId, db.departments.id),
      );

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<String>('department_id')!;

    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _createdByUserIdTable(_$AppDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.records.createdByUserId, db.users.id),
      );

  $$UsersTableProcessedTableManager get createdByUserId {
    final $_column = $_itemColumn<String>('created_by_user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OperatorsTable _operatorIdTable(_$AppDatabase db) =>
      db.operators.createAlias(
        $_aliasNameGenerator(db.records.operatorId, db.operators.id),
      );

  $$OperatorsTableProcessedTableManager? get operatorId {
    final $_column = $_itemColumn<String>('operator_id');
    if ($_column == null) return null;
    final manager = $$OperatorsTableTableManager(
      $_db,
      $_db.operators,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_operatorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OperatorsTable _leaderOperatorIdTable(_$AppDatabase db) =>
      db.operators.createAlias(
        $_aliasNameGenerator(db.records.leaderOperatorId, db.operators.id),
      );

  $$OperatorsTableProcessedTableManager? get leaderOperatorId {
    final $_column = $_itemColumn<String>('leader_operator_id');
    if ($_column == null) return null;
    final manager = $$OperatorsTableTableManager(
      $_db,
      $_db.operators,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leaderOperatorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CropsTable _cropIdTable(_$AppDatabase db) => db.crops.createAlias(
    $_aliasNameGenerator(db.records.cropId, db.crops.id),
  );

  $$CropsTableProcessedTableManager? get cropId {
    final $_column = $_itemColumn<String>('crop_id');
    if ($_column == null) return null;
    final manager = $$CropsTableTableManager(
      $_db,
      $_db.crops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cropIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.records.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DiningRoomsTable _diningRoomIdTable(_$AppDatabase db) =>
      db.diningRooms.createAlias(
        $_aliasNameGenerator(db.records.diningRoomId, db.diningRooms.id),
      );

  $$DiningRoomsTableProcessedTableManager? get diningRoomId {
    final $_column = $_itemColumn<String>('dining_room_id');
    if ($_column == null) return null;
    final manager = $$DiningRoomsTableTableManager(
      $_db,
      $_db.diningRooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diningRoomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecordLocationsTable, List<FarmRecordLocation>>
  _recordLocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordLocations,
    aliasName: $_aliasNameGenerator(db.records.id, db.recordLocations.recordId),
  );

  $$RecordLocationsTableProcessedTableManager get recordLocationsRefs {
    final manager = $$RecordLocationsTableTableManager(
      $_db,
      $_db.recordLocations,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recordLocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userCode => $composableBuilder(
    column: $table.userCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatorNameSnapshot => $composableBuilder(
    column: $table.operatorNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaderCodeSnapshot => $composableBuilder(
    column: $table.leaderCodeSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaderNameSnapshot => $composableBuilder(
    column: $table.leaderNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskCodeSnapshot => $composableBuilder(
    column: $table.taskCodeSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskNameSnapshot => $composableBuilder(
    column: $table.taskNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskDetail => $composableBuilder(
    column: $table.taskDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scheduledWage => $composableBuilder(
    column: $table.scheduledWage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get realWage => $composableBuilder(
    column: $table.realWage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ha => $composableBuilder(
    column: $table.ha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diningRoom => $composableBuilder(
    column: $table.diningRoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraFieldsJson => $composableBuilder(
    column: $table.extraFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get createdByUserId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableFilterComposer get operatorId {
    final $$OperatorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableFilterComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableFilterComposer get leaderOperatorId {
    final $$OperatorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaderOperatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableFilterComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableFilterComposer get cropId {
    final $$CropsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableFilterComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiningRoomsTableFilterComposer get diningRoomId {
    final $$DiningRoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diningRoomId,
      referencedTable: $db.diningRooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiningRoomsTableFilterComposer(
            $db: $db,
            $table: $db.diningRooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recordLocationsRefs(
    Expression<bool> Function($$RecordLocationsTableFilterComposer f) f,
  ) {
    final $$RecordLocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordLocations,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordLocationsTableFilterComposer(
            $db: $db,
            $table: $db.recordLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userCode => $composableBuilder(
    column: $table.userCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatorNameSnapshot => $composableBuilder(
    column: $table.operatorNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderCodeSnapshot => $composableBuilder(
    column: $table.leaderCodeSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderNameSnapshot => $composableBuilder(
    column: $table.leaderNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskCodeSnapshot => $composableBuilder(
    column: $table.taskCodeSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskNameSnapshot => $composableBuilder(
    column: $table.taskNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskDetail => $composableBuilder(
    column: $table.taskDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scheduledWage => $composableBuilder(
    column: $table.scheduledWage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get realWage => $composableBuilder(
    column: $table.realWage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ha => $composableBuilder(
    column: $table.ha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diningRoom => $composableBuilder(
    column: $table.diningRoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraFieldsJson => $composableBuilder(
    column: $table.extraFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get createdByUserId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableOrderingComposer get operatorId {
    final $$OperatorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableOrderingComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableOrderingComposer get leaderOperatorId {
    final $$OperatorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaderOperatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableOrderingComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableOrderingComposer get cropId {
    final $$CropsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableOrderingComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiningRoomsTableOrderingComposer get diningRoomId {
    final $$DiningRoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diningRoomId,
      referencedTable: $db.diningRooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiningRoomsTableOrderingComposer(
            $db: $db,
            $table: $db.diningRooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userCode =>
      $composableBuilder(column: $table.userCode, builder: (column) => column);

  GeneratedColumn<String> get operatorNameSnapshot => $composableBuilder(
    column: $table.operatorNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaderCodeSnapshot => $composableBuilder(
    column: $table.leaderCodeSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaderNameSnapshot => $composableBuilder(
    column: $table.leaderNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskCodeSnapshot => $composableBuilder(
    column: $table.taskCodeSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskNameSnapshot => $composableBuilder(
    column: $table.taskNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskDetail => $composableBuilder(
    column: $table.taskDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lot =>
      $composableBuilder(column: $table.lot, builder: (column) => column);

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<double> get scheduledWage => $composableBuilder(
    column: $table.scheduledWage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get realWage =>
      $composableBuilder(column: $table.realWage, builder: (column) => column);

  GeneratedColumn<double> get ha =>
      $composableBuilder(column: $table.ha, builder: (column) => column);

  GeneratedColumn<double> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  GeneratedColumn<String> get diningRoom => $composableBuilder(
    column: $table.diningRoom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraFieldsJson => $composableBuilder(
    column: $table.extraFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get createdByUserId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByUserId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableAnnotationComposer get operatorId {
    final $$OperatorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.operatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableAnnotationComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OperatorsTableAnnotationComposer get leaderOperatorId {
    final $$OperatorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaderOperatorId,
      referencedTable: $db.operators,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OperatorsTableAnnotationComposer(
            $db: $db,
            $table: $db.operators,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CropsTableAnnotationComposer get cropId {
    final $$CropsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cropId,
      referencedTable: $db.crops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CropsTableAnnotationComposer(
            $db: $db,
            $table: $db.crops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiningRoomsTableAnnotationComposer get diningRoomId {
    final $$DiningRoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diningRoomId,
      referencedTable: $db.diningRooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiningRoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.diningRooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recordLocationsRefs<T extends Object>(
    Expression<T> Function($$RecordLocationsTableAnnotationComposer a) f,
  ) {
    final $$RecordLocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordLocations,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordLocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.recordLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          FarmRecord,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (FarmRecord, $$RecordsTableReferences),
          FarmRecord,
          PrefetchHooks Function({
            bool departmentId,
            bool createdByUserId,
            bool operatorId,
            bool leaderOperatorId,
            bool cropId,
            bool taskId,
            bool diningRoomId,
            bool recordLocationsRefs,
          })
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<DateTime> recordDate = const Value.absent(),
                Value<int> weekNumber = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> createdByUserId = const Value.absent(),
                Value<String> userCode = const Value.absent(),
                Value<String?> operatorId = const Value.absent(),
                Value<String?> operatorNameSnapshot = const Value.absent(),
                Value<String?> leaderOperatorId = const Value.absent(),
                Value<String?> leaderCodeSnapshot = const Value.absent(),
                Value<String?> leaderNameSnapshot = const Value.absent(),
                Value<String?> cropId = const Value.absent(),
                Value<String?> cropNameSnapshot = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskCodeSnapshot = const Value.absent(),
                Value<String?> taskNameSnapshot = const Value.absent(),
                Value<String?> taskDetail = const Value.absent(),
                Value<String?> lot = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<double?> scheduledWage = const Value.absent(),
                Value<double?> realWage = const Value.absent(),
                Value<double> ha = const Value.absent(),
                Value<double?> ratio = const Value.absent(),
                Value<String?> diningRoomId = const Value.absent(),
                Value<String?> diningRoom = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<String?> extraFieldsJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion(
                id: id,
                serverId: serverId,
                recordDate: recordDate,
                weekNumber: weekNumber,
                departmentId: departmentId,
                createdByUserId: createdByUserId,
                userCode: userCode,
                operatorId: operatorId,
                operatorNameSnapshot: operatorNameSnapshot,
                leaderOperatorId: leaderOperatorId,
                leaderCodeSnapshot: leaderCodeSnapshot,
                leaderNameSnapshot: leaderNameSnapshot,
                cropId: cropId,
                cropNameSnapshot: cropNameSnapshot,
                taskId: taskId,
                taskCodeSnapshot: taskCodeSnapshot,
                taskNameSnapshot: taskNameSnapshot,
                taskDetail: taskDetail,
                lot: lot,
                network: network,
                scheduledWage: scheduledWage,
                realWage: realWage,
                ha: ha,
                ratio: ratio,
                diningRoomId: diningRoomId,
                diningRoom: diningRoom,
                observation: observation,
                extraFieldsJson: extraFieldsJson,
                isActive: isActive,
                isLocked: isLocked,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required DateTime recordDate,
                required int weekNumber,
                required String departmentId,
                required String createdByUserId,
                required String userCode,
                Value<String?> operatorId = const Value.absent(),
                Value<String?> operatorNameSnapshot = const Value.absent(),
                Value<String?> leaderOperatorId = const Value.absent(),
                Value<String?> leaderCodeSnapshot = const Value.absent(),
                Value<String?> leaderNameSnapshot = const Value.absent(),
                Value<String?> cropId = const Value.absent(),
                Value<String?> cropNameSnapshot = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> taskCodeSnapshot = const Value.absent(),
                Value<String?> taskNameSnapshot = const Value.absent(),
                Value<String?> taskDetail = const Value.absent(),
                Value<String?> lot = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<double?> scheduledWage = const Value.absent(),
                Value<double?> realWage = const Value.absent(),
                Value<double> ha = const Value.absent(),
                Value<double?> ratio = const Value.absent(),
                Value<String?> diningRoomId = const Value.absent(),
                Value<String?> diningRoom = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<String?> extraFieldsJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsCompanion.insert(
                id: id,
                serverId: serverId,
                recordDate: recordDate,
                weekNumber: weekNumber,
                departmentId: departmentId,
                createdByUserId: createdByUserId,
                userCode: userCode,
                operatorId: operatorId,
                operatorNameSnapshot: operatorNameSnapshot,
                leaderOperatorId: leaderOperatorId,
                leaderCodeSnapshot: leaderCodeSnapshot,
                leaderNameSnapshot: leaderNameSnapshot,
                cropId: cropId,
                cropNameSnapshot: cropNameSnapshot,
                taskId: taskId,
                taskCodeSnapshot: taskCodeSnapshot,
                taskNameSnapshot: taskNameSnapshot,
                taskDetail: taskDetail,
                lot: lot,
                network: network,
                scheduledWage: scheduledWage,
                realWage: realWage,
                ha: ha,
                ratio: ratio,
                diningRoomId: diningRoomId,
                diningRoom: diningRoom,
                observation: observation,
                extraFieldsJson: extraFieldsJson,
                isActive: isActive,
                isLocked: isLocked,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                departmentId = false,
                createdByUserId = false,
                operatorId = false,
                leaderOperatorId = false,
                cropId = false,
                taskId = false,
                diningRoomId = false,
                recordLocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recordLocationsRefs) db.recordLocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (departmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.departmentId,
                                    referencedTable: $$RecordsTableReferences
                                        ._departmentIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (createdByUserId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdByUserId,
                                    referencedTable: $$RecordsTableReferences
                                        ._createdByUserIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._createdByUserIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (operatorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.operatorId,
                                    referencedTable: $$RecordsTableReferences
                                        ._operatorIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._operatorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (leaderOperatorId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.leaderOperatorId,
                                    referencedTable: $$RecordsTableReferences
                                        ._leaderOperatorIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._leaderOperatorIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (cropId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cropId,
                                    referencedTable: $$RecordsTableReferences
                                        ._cropIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._cropIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (taskId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taskId,
                                    referencedTable: $$RecordsTableReferences
                                        ._taskIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (diningRoomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.diningRoomId,
                                    referencedTable: $$RecordsTableReferences
                                        ._diningRoomIdTable(db),
                                    referencedColumn: $$RecordsTableReferences
                                        ._diningRoomIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordLocationsRefs)
                        await $_getPrefetchedData<
                          FarmRecord,
                          $RecordsTable,
                          FarmRecordLocation
                        >(
                          currentTable: table,
                          referencedTable: $$RecordsTableReferences
                              ._recordLocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordLocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      FarmRecord,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (FarmRecord, $$RecordsTableReferences),
      FarmRecord,
      PrefetchHooks Function({
        bool departmentId,
        bool createdByUserId,
        bool operatorId,
        bool leaderOperatorId,
        bool cropId,
        bool taskId,
        bool diningRoomId,
        bool recordLocationsRefs,
      })
    >;
typedef $$RecordLocationsTableCreateCompanionBuilder =
    RecordLocationsCompanion Function({
      required String id,
      required String recordId,
      required String locationId,
      required String cropNameSnapshot,
      required String lotSnapshot,
      required String networkSnapshot,
      required String sectorSnapshot,
      required double haSnapshot,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$RecordLocationsTableUpdateCompanionBuilder =
    RecordLocationsCompanion Function({
      Value<String> id,
      Value<String> recordId,
      Value<String> locationId,
      Value<String> cropNameSnapshot,
      Value<String> lotSnapshot,
      Value<String> networkSnapshot,
      Value<String> sectorSnapshot,
      Value<double> haSnapshot,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$RecordLocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecordLocationsTable,
          FarmRecordLocation
        > {
  $$RecordLocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecordsTable _recordIdTable(_$AppDatabase db) =>
      db.records.createAlias(
        $_aliasNameGenerator(db.recordLocations.recordId, db.records.id),
      );

  $$RecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<String>('record_id')!;

    final manager = $$RecordsTableTableManager(
      $_db,
      $_db.records,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _locationIdTable(_$AppDatabase db) =>
      db.locations.createAlias(
        $_aliasNameGenerator(db.recordLocations.locationId, db.locations.id),
      );

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<String>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordLocationsTable> {
  $$RecordLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lotSnapshot => $composableBuilder(
    column: $table.lotSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkSnapshot => $composableBuilder(
    column: $table.networkSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectorSnapshot => $composableBuilder(
    column: $table.sectorSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get haSnapshot => $composableBuilder(
    column: $table.haSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$RecordsTableFilterComposer get recordId {
    final $$RecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableFilterComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordLocationsTable> {
  $$RecordLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lotSnapshot => $composableBuilder(
    column: $table.lotSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkSnapshot => $composableBuilder(
    column: $table.networkSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectorSnapshot => $composableBuilder(
    column: $table.sectorSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get haSnapshot => $composableBuilder(
    column: $table.haSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecordsTableOrderingComposer get recordId {
    final $$RecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableOrderingComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordLocationsTable> {
  $$RecordLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cropNameSnapshot => $composableBuilder(
    column: $table.cropNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lotSnapshot => $composableBuilder(
    column: $table.lotSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get networkSnapshot => $composableBuilder(
    column: $table.networkSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sectorSnapshot => $composableBuilder(
    column: $table.sectorSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get haSnapshot => $composableBuilder(
    column: $table.haSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$RecordsTableAnnotationComposer get recordId {
    final $$RecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.records,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.records,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordLocationsTable,
          FarmRecordLocation,
          $$RecordLocationsTableFilterComposer,
          $$RecordLocationsTableOrderingComposer,
          $$RecordLocationsTableAnnotationComposer,
          $$RecordLocationsTableCreateCompanionBuilder,
          $$RecordLocationsTableUpdateCompanionBuilder,
          (FarmRecordLocation, $$RecordLocationsTableReferences),
          FarmRecordLocation,
          PrefetchHooks Function({bool recordId, bool locationId})
        > {
  $$RecordLocationsTableTableManager(
    _$AppDatabase db,
    $RecordLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> cropNameSnapshot = const Value.absent(),
                Value<String> lotSnapshot = const Value.absent(),
                Value<String> networkSnapshot = const Value.absent(),
                Value<String> sectorSnapshot = const Value.absent(),
                Value<double> haSnapshot = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordLocationsCompanion(
                id: id,
                recordId: recordId,
                locationId: locationId,
                cropNameSnapshot: cropNameSnapshot,
                lotSnapshot: lotSnapshot,
                networkSnapshot: networkSnapshot,
                sectorSnapshot: sectorSnapshot,
                haSnapshot: haSnapshot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recordId,
                required String locationId,
                required String cropNameSnapshot,
                required String lotSnapshot,
                required String networkSnapshot,
                required String sectorSnapshot,
                required double haSnapshot,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordLocationsCompanion.insert(
                id: id,
                recordId: recordId,
                locationId: locationId,
                cropNameSnapshot: cropNameSnapshot,
                lotSnapshot: lotSnapshot,
                networkSnapshot: networkSnapshot,
                sectorSnapshot: sectorSnapshot,
                haSnapshot: haSnapshot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecordLocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false, locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recordId,
                                referencedTable:
                                    $$RecordLocationsTableReferences
                                        ._recordIdTable(db),
                                referencedColumn:
                                    $$RecordLocationsTableReferences
                                        ._recordIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable:
                                    $$RecordLocationsTableReferences
                                        ._locationIdTable(db),
                                referencedColumn:
                                    $$RecordLocationsTableReferences
                                        ._locationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecordLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordLocationsTable,
      FarmRecordLocation,
      $$RecordLocationsTableFilterComposer,
      $$RecordLocationsTableOrderingComposer,
      $$RecordLocationsTableAnnotationComposer,
      $$RecordLocationsTableCreateCompanionBuilder,
      $$RecordLocationsTableUpdateCompanionBuilder,
      (FarmRecordLocation, $$RecordLocationsTableReferences),
      FarmRecordLocation,
      PrefetchHooks Function({bool recordId, bool locationId})
    >;
typedef $$FormFieldConfigsTableCreateCompanionBuilder =
    FormFieldConfigsCompanion Function({
      required String id,
      required String departmentId,
      required String fieldKey,
      required String label,
      required String fieldType,
      Value<bool> isRequired,
      Value<bool> isVisible,
      Value<int> sortOrder,
      Value<String?> optionsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$FormFieldConfigsTableUpdateCompanionBuilder =
    FormFieldConfigsCompanion Function({
      Value<String> id,
      Value<String> departmentId,
      Value<String> fieldKey,
      Value<String> label,
      Value<String> fieldType,
      Value<bool> isRequired,
      Value<bool> isVisible,
      Value<int> sortOrder,
      Value<String?> optionsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$FormFieldConfigsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FormFieldConfigsTable, FormFieldConfig> {
  $$FormFieldConfigsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(
          db.formFieldConfigs.departmentId,
          db.departments.id,
        ),
      );

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<String>('department_id')!;

    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormFieldConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $FormFieldConfigsTable> {
  $$FormFieldConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormFieldConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $FormFieldConfigsTable> {
  $$FormFieldConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormFieldConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormFieldConfigsTable> {
  $$FormFieldConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldKey =>
      $composableBuilder(column: $table.fieldKey, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get fieldType =>
      $composableBuilder(column: $table.fieldType, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormFieldConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormFieldConfigsTable,
          FormFieldConfig,
          $$FormFieldConfigsTableFilterComposer,
          $$FormFieldConfigsTableOrderingComposer,
          $$FormFieldConfigsTableAnnotationComposer,
          $$FormFieldConfigsTableCreateCompanionBuilder,
          $$FormFieldConfigsTableUpdateCompanionBuilder,
          (FormFieldConfig, $$FormFieldConfigsTableReferences),
          FormFieldConfig,
          PrefetchHooks Function({bool departmentId})
        > {
  $$FormFieldConfigsTableTableManager(
    _$AppDatabase db,
    $FormFieldConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormFieldConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormFieldConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormFieldConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> fieldKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> fieldType = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormFieldConfigsCompanion(
                id: id,
                departmentId: departmentId,
                fieldKey: fieldKey,
                label: label,
                fieldType: fieldType,
                isRequired: isRequired,
                isVisible: isVisible,
                sortOrder: sortOrder,
                optionsJson: optionsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String departmentId,
                required String fieldKey,
                required String label,
                required String fieldType,
                Value<bool> isRequired = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormFieldConfigsCompanion.insert(
                id: id,
                departmentId: departmentId,
                fieldKey: fieldKey,
                label: label,
                fieldType: fieldType,
                isRequired: isRequired,
                isVisible: isVisible,
                sortOrder: sortOrder,
                optionsJson: optionsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FormFieldConfigsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable:
                                    $$FormFieldConfigsTableReferences
                                        ._departmentIdTable(db),
                                referencedColumn:
                                    $$FormFieldConfigsTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormFieldConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormFieldConfigsTable,
      FormFieldConfig,
      $$FormFieldConfigsTableFilterComposer,
      $$FormFieldConfigsTableOrderingComposer,
      $$FormFieldConfigsTableAnnotationComposer,
      $$FormFieldConfigsTableCreateCompanionBuilder,
      $$FormFieldConfigsTableUpdateCompanionBuilder,
      (FormFieldConfig, $$FormFieldConfigsTableReferences),
      FormFieldConfig,
      PrefetchHooks Function({bool departmentId})
    >;
typedef $$TableColumnConfigsTableCreateCompanionBuilder =
    TableColumnConfigsCompanion Function({
      required String id,
      Value<String?> departmentId,
      required String tableKey,
      required String columnKey,
      required String label,
      Value<bool> isVisible,
      Value<bool> isExportable,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$TableColumnConfigsTableUpdateCompanionBuilder =
    TableColumnConfigsCompanion Function({
      Value<String> id,
      Value<String?> departmentId,
      Value<String> tableKey,
      Value<String> columnKey,
      Value<String> label,
      Value<bool> isVisible,
      Value<bool> isExportable,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

final class $$TableColumnConfigsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TableColumnConfigsTable,
          TableColumnConfig
        > {
  $$TableColumnConfigsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias(
        $_aliasNameGenerator(
          db.tableColumnConfigs.departmentId,
          db.departments.id,
        ),
      );

  $$DepartmentsTableProcessedTableManager? get departmentId {
    final $_column = $_itemColumn<String>('department_id');
    if ($_column == null) return null;
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TableColumnConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $TableColumnConfigsTable> {
  $$TableColumnConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableKey => $composableBuilder(
    column: $table.tableKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get columnKey => $composableBuilder(
    column: $table.columnKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExportable => $composableBuilder(
    column: $table.isExportable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableColumnConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $TableColumnConfigsTable> {
  $$TableColumnConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableKey => $composableBuilder(
    column: $table.tableKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get columnKey => $composableBuilder(
    column: $table.columnKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExportable => $composableBuilder(
    column: $table.isExportable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableColumnConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableColumnConfigsTable> {
  $$TableColumnConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableKey =>
      $composableBuilder(column: $table.tableKey, builder: (column) => column);

  GeneratedColumn<String> get columnKey =>
      $composableBuilder(column: $table.columnKey, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<bool> get isExportable => $composableBuilder(
    column: $table.isExportable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableColumnConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableColumnConfigsTable,
          TableColumnConfig,
          $$TableColumnConfigsTableFilterComposer,
          $$TableColumnConfigsTableOrderingComposer,
          $$TableColumnConfigsTableAnnotationComposer,
          $$TableColumnConfigsTableCreateCompanionBuilder,
          $$TableColumnConfigsTableUpdateCompanionBuilder,
          (TableColumnConfig, $$TableColumnConfigsTableReferences),
          TableColumnConfig,
          PrefetchHooks Function({bool departmentId})
        > {
  $$TableColumnConfigsTableTableManager(
    _$AppDatabase db,
    $TableColumnConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableColumnConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableColumnConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableColumnConfigsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String> tableKey = const Value.absent(),
                Value<String> columnKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<bool> isExportable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TableColumnConfigsCompanion(
                id: id,
                departmentId: departmentId,
                tableKey: tableKey,
                columnKey: columnKey,
                label: label,
                isVisible: isVisible,
                isExportable: isExportable,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> departmentId = const Value.absent(),
                required String tableKey,
                required String columnKey,
                required String label,
                Value<bool> isVisible = const Value.absent(),
                Value<bool> isExportable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TableColumnConfigsCompanion.insert(
                id: id,
                departmentId: departmentId,
                tableKey: tableKey,
                columnKey: columnKey,
                label: label,
                isVisible: isVisible,
                isExportable: isExportable,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TableColumnConfigsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable:
                                    $$TableColumnConfigsTableReferences
                                        ._departmentIdTable(db),
                                referencedColumn:
                                    $$TableColumnConfigsTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TableColumnConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableColumnConfigsTable,
      TableColumnConfig,
      $$TableColumnConfigsTableFilterComposer,
      $$TableColumnConfigsTableOrderingComposer,
      $$TableColumnConfigsTableAnnotationComposer,
      $$TableColumnConfigsTableCreateCompanionBuilder,
      $$TableColumnConfigsTableUpdateCompanionBuilder,
      (TableColumnConfig, $$TableColumnConfigsTableReferences),
      TableColumnConfig,
      PrefetchHooks Function({bool departmentId})
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payloadJson,
      Value<String> status,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payloadJson,
      Value<String> status,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$AppDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$CropsTableTableManager get crops =>
      $$CropsTableTableManager(_db, _db.crops);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$OperatorsTableTableManager get operators =>
      $$OperatorsTableTableManager(_db, _db.operators);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserDepartmentsTableTableManager get userDepartments =>
      $$UserDepartmentsTableTableManager(_db, _db.userDepartments);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$DiningRoomsTableTableManager get diningRooms =>
      $$DiningRoomsTableTableManager(_db, _db.diningRooms);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
  $$RecordLocationsTableTableManager get recordLocations =>
      $$RecordLocationsTableTableManager(_db, _db.recordLocations);
  $$FormFieldConfigsTableTableManager get formFieldConfigs =>
      $$FormFieldConfigsTableTableManager(_db, _db.formFieldConfigs);
  $$TableColumnConfigsTableTableManager get tableColumnConfigs =>
      $$TableColumnConfigsTableTableManager(_db, _db.tableColumnConfigs);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
}
