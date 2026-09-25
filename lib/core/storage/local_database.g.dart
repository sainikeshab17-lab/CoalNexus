// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UserRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UserRole>($UsersTable.$converterrole);
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    role,
    permissions,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntity> instance, {
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permissionsMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      role: $UsersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
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
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UserRole, String, String> $converterrole =
      const EnumNameConverter(UserRole.values);
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    {
      map['role'] = Variable<String>($UsersTable.$converterrole.toSql(role));
    }
    map['permissions'] = Variable<String>(permissions);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      role: Value(role),
      permissions: Value(permissions),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      role: $UsersTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      permissions: serializer.fromJson<String>(json['permissions']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(
        $UsersTable.$converterrole.toJson(role),
      ),
      'permissions': serializer.toJson<String>(permissions),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? permissions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    permissions: permissions ?? this.permissions,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('permissions: $permissions, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    role,
    permissions,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role &&
          other.permissions == this.permissions &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<UserRole> role;
  final Value<String> permissions;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.permissions = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    required String permissions,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       role = Value(role),
       permissions = Value(permissions);
  static Insertable<UserEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? permissions,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (permissions != null) 'permissions': permissions,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<UserRole>? role,
    Value<String>? permissions,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $UsersTable.$converterrole.toSql(role.value),
      );
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('permissions: $permissions, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MinesTable extends Mines with TableInfo<$MinesTable, MineEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _mineCodeMeta = const VerificationMeta(
    'mineCode',
  );
  @override
  late final GeneratedColumn<String> mineCode = GeneratedColumn<String>(
    'mine_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MineStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MineStatus>($MinesTable.$converterstatus);
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    name,
    mineCode,
    latitude,
    longitude,
    status,
    createdAt,
    updatedAt,
    localVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mines';
  @override
  VerificationContext validateIntegrity(
    Insertable<MineEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
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
    if (data.containsKey('mine_code')) {
      context.handle(
        _mineCodeMeta,
        mineCode.isAcceptableOrUnknown(data['mine_code']!, _mineCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_mineCodeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
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
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  MineEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MineEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mineCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mine_code'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      status: $MinesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
    );
  }

  @override
  $MinesTable createAlias(String alias) {
    return $MinesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MineStatus, String, String> $converterstatus =
      const EnumNameConverter(MineStatus.values);
}

class MineEntity extends DataClass implements Insertable<MineEntity> {
  final String localId;
  final String? serverId;
  final String name;
  final String mineCode;
  final double latitude;
  final double longitude;
  final MineStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;
  const MineEntity({
    required this.localId,
    this.serverId,
    required this.name,
    required this.mineCode,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['mine_code'] = Variable<String>(mineCode);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    {
      map['status'] = Variable<String>(
        $MinesTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['local_version'] = Variable<int>(localVersion);
    return map;
  }

  MinesCompanion toCompanion(bool nullToAbsent) {
    return MinesCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      mineCode: Value(mineCode),
      latitude: Value(latitude),
      longitude: Value(longitude),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      localVersion: Value(localVersion),
    );
  }

  factory MineEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MineEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      mineCode: serializer.fromJson<String>(json['mineCode']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      status: $MinesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'mineCode': serializer.toJson<String>(mineCode),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'status': serializer.toJson<String>(
        $MinesTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'localVersion': serializer.toJson<int>(localVersion),
    };
  }

  MineEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? name,
    String? mineCode,
    double? latitude,
    double? longitude,
    MineStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) => MineEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    mineCode: mineCode ?? this.mineCode,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    localVersion: localVersion ?? this.localVersion,
  );
  MineEntity copyWithCompanion(MinesCompanion data) {
    return MineEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      mineCode: data.mineCode.present ? data.mineCode.value : this.mineCode,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MineEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('mineCode: $mineCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    name,
    mineCode,
    latitude,
    longitude,
    status,
    createdAt,
    updatedAt,
    localVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MineEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.mineCode == this.mineCode &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.localVersion == this.localVersion);
}

class MinesCompanion extends UpdateCompanion<MineEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<String> mineCode;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<MineStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> localVersion;
  final Value<int> rowid;
  const MinesCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.mineCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MinesCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String name,
    required String mineCode,
    required double latitude,
    required double longitude,
    required MineStatus status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       name = Value(name),
       mineCode = Value(mineCode),
       latitude = Value(latitude),
       longitude = Value(longitude),
       status = Value(status);
  static Insertable<MineEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? mineCode,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? localVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (mineCode != null) 'mine_code': mineCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (localVersion != null) 'local_version': localVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MinesCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? name,
    Value<String>? mineCode,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<MineStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? localVersion,
    Value<int>? rowid,
  }) {
    return MinesCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      mineCode: mineCode ?? this.mineCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mineCode.present) {
      map['mine_code'] = Variable<String>(mineCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MinesTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MinesCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('mineCode: $mineCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _featureNameMeta = const VerificationMeta(
    'featureName',
  );
  @override
  late final GeneratedColumn<String> featureName = GeneratedColumn<String>(
    'feature_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
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
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($SyncQueueTable.$convertersyncStatus);
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
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
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    featureName,
    actionType,
    payloadJson,
    syncStatus,
    retryCount,
    lastError,
    localVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('feature_name')) {
      context.handle(
        _featureNameMeta,
        featureName.isAcceptableOrUnknown(
          data['feature_name']!,
          _featureNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureNameMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
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
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  SyncQueueEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      featureName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_name'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      syncStatus: $SyncQueueTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter(SyncStatus.values);
}

class SyncQueueEntity extends DataClass implements Insertable<SyncQueueEntity> {
  final String localId;
  final String? serverId;
  final String featureName;
  final String actionType;
  final String payloadJson;
  final SyncStatus syncStatus;
  final int retryCount;
  final String? lastError;
  final int localVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueEntity({
    required this.localId,
    this.serverId,
    required this.featureName,
    required this.actionType,
    required this.payloadJson,
    required this.syncStatus,
    required this.retryCount,
    this.lastError,
    required this.localVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['feature_name'] = Variable<String>(featureName);
    map['action_type'] = Variable<String>(actionType);
    map['payload_json'] = Variable<String>(payloadJson);
    {
      map['sync_status'] = Variable<String>(
        $SyncQueueTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      featureName: Value(featureName),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      localVersion: Value(localVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      featureName: serializer.fromJson<String>(json['featureName']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      syncStatus: $SyncQueueTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'featureName': serializer.toJson<String>(featureName),
      'actionType': serializer.toJson<String>(actionType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'syncStatus': serializer.toJson<String>(
        $SyncQueueTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'localVersion': serializer.toJson<int>(localVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? featureName,
    String? actionType,
    String? payloadJson,
    SyncStatus? syncStatus,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    int? localVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    featureName: featureName ?? this.featureName,
    actionType: actionType ?? this.actionType,
    payloadJson: payloadJson ?? this.payloadJson,
    syncStatus: syncStatus ?? this.syncStatus,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    localVersion: localVersion ?? this.localVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueEntity copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      featureName: data.featureName.present
          ? data.featureName.value
          : this.featureName,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('featureName: $featureName, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('localVersion: $localVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    featureName,
    actionType,
    payloadJson,
    syncStatus,
    retryCount,
    lastError,
    localVersion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.featureName == this.featureName &&
          other.actionType == this.actionType &&
          other.payloadJson == this.payloadJson &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.localVersion == this.localVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> featureName;
  final Value<String> actionType;
  final Value<String> payloadJson;
  final Value<SyncStatus> syncStatus;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<int> localVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.featureName = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String featureName,
    required String actionType,
    required String payloadJson,
    required SyncStatus syncStatus,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       featureName = Value(featureName),
       actionType = Value(actionType),
       payloadJson = Value(payloadJson),
       syncStatus = Value(syncStatus);
  static Insertable<SyncQueueEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? featureName,
    Expression<String>? actionType,
    Expression<String>? payloadJson,
    Expression<String>? syncStatus,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<int>? localVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (featureName != null) 'feature_name': featureName,
      if (actionType != null) 'action_type': actionType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (localVersion != null) 'local_version': localVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? featureName,
    Value<String>? actionType,
    Value<String>? payloadJson,
    Value<SyncStatus>? syncStatus,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<int>? localVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      featureName: featureName ?? this.featureName,
      actionType: actionType ?? this.actionType,
      payloadJson: payloadJson ?? this.payloadJson,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      localVersion: localVersion ?? this.localVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (featureName.present) {
      map['feature_name'] = Variable<String>(featureName.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $SyncQueueTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('featureName: $featureName, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('localVersion: $localVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, InspectionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _mineIdMeta = const VerificationMeta('mineId');
  @override
  late final GeneratedColumn<String> mineId = GeneratedColumn<String>(
    'mine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectorIdMeta = const VerificationMeta(
    'inspectorId',
  );
  @override
  late final GeneratedColumn<String> inspectorId = GeneratedColumn<String>(
    'inspector_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InspectionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InspectionStatus>($InspectionsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<InspectionCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  ).withConverter<InspectionCategory>($InspectionsTable.$convertercategory);
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    mineId,
    inspectorId,
    status,
    category,
    createdAt,
    updatedAt,
    localVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('mine_id')) {
      context.handle(
        _mineIdMeta,
        mineId.isAcceptableOrUnknown(data['mine_id']!, _mineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mineIdMeta);
    }
    if (data.containsKey('inspector_id')) {
      context.handle(
        _inspectorIdMeta,
        inspectorId.isAcceptableOrUnknown(
          data['inspector_id']!,
          _inspectorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectorIdMeta);
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
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  InspectionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      mineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mine_id'],
      )!,
      inspectorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspector_id'],
      )!,
      status: $InspectionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      category: $InspectionsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InspectionStatus, String, String> $converterstatus =
      const EnumNameConverter(InspectionStatus.values);
  static JsonTypeConverter2<InspectionCategory, String, String>
  $convertercategory = const EnumNameConverter(InspectionCategory.values);
}

class InspectionEntity extends DataClass
    implements Insertable<InspectionEntity> {
  final String localId;
  final String? serverId;
  final String mineId;
  final String inspectorId;
  final InspectionStatus status;
  final InspectionCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;
  const InspectionEntity({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.inspectorId,
    required this.status,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['mine_id'] = Variable<String>(mineId);
    map['inspector_id'] = Variable<String>(inspectorId);
    {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['category'] = Variable<String>(
        $InspectionsTable.$convertercategory.toSql(category),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['local_version'] = Variable<int>(localVersion);
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      mineId: Value(mineId),
      inspectorId: Value(inspectorId),
      status: Value(status),
      category: Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      localVersion: Value(localVersion),
    );
  }

  factory InspectionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      mineId: serializer.fromJson<String>(json['mineId']),
      inspectorId: serializer.fromJson<String>(json['inspectorId']),
      status: $InspectionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      category: $InspectionsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'mineId': serializer.toJson<String>(mineId),
      'inspectorId': serializer.toJson<String>(inspectorId),
      'status': serializer.toJson<String>(
        $InspectionsTable.$converterstatus.toJson(status),
      ),
      'category': serializer.toJson<String>(
        $InspectionsTable.$convertercategory.toJson(category),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'localVersion': serializer.toJson<int>(localVersion),
    };
  }

  InspectionEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? mineId,
    String? inspectorId,
    InspectionStatus? status,
    InspectionCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) => InspectionEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    mineId: mineId ?? this.mineId,
    inspectorId: inspectorId ?? this.inspectorId,
    status: status ?? this.status,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    localVersion: localVersion ?? this.localVersion,
  );
  InspectionEntity copyWithCompanion(InspectionsCompanion data) {
    return InspectionEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      mineId: data.mineId.present ? data.mineId.value : this.mineId,
      inspectorId: data.inspectorId.present
          ? data.inspectorId.value
          : this.inspectorId,
      status: data.status.present ? data.status.value : this.status,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('mineId: $mineId, ')
          ..write('inspectorId: $inspectorId, ')
          ..write('status: $status, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    mineId,
    inspectorId,
    status,
    category,
    createdAt,
    updatedAt,
    localVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.mineId == this.mineId &&
          other.inspectorId == this.inspectorId &&
          other.status == this.status &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.localVersion == this.localVersion);
}

class InspectionsCompanion extends UpdateCompanion<InspectionEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> mineId;
  final Value<String> inspectorId;
  final Value<InspectionStatus> status;
  final Value<InspectionCategory> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> localVersion;
  final Value<int> rowid;
  const InspectionsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.mineId = const Value.absent(),
    this.inspectorId = const Value.absent(),
    this.status = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String mineId,
    required String inspectorId,
    required InspectionStatus status,
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       mineId = Value(mineId),
       inspectorId = Value(inspectorId),
       status = Value(status);
  static Insertable<InspectionEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? mineId,
    Expression<String>? inspectorId,
    Expression<String>? status,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? localVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (mineId != null) 'mine_id': mineId,
      if (inspectorId != null) 'inspector_id': inspectorId,
      if (status != null) 'status': status,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (localVersion != null) 'local_version': localVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? mineId,
    Value<String>? inspectorId,
    Value<InspectionStatus>? status,
    Value<InspectionCategory>? category,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? localVersion,
    Value<int>? rowid,
  }) {
    return InspectionsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      mineId: mineId ?? this.mineId,
      inspectorId: inspectorId ?? this.inspectorId,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (mineId.present) {
      map['mine_id'] = Variable<String>(mineId.value);
    }
    if (inspectorId.present) {
      map['inspector_id'] = Variable<String>(inspectorId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InspectionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $InspectionsTable.$convertercategory.toSql(category.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('mineId: $mineId, ')
          ..write('inspectorId: $inspectorId, ')
          ..write('status: $status, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionFindingsTable extends InspectionFindings
    with TableInfo<$InspectionFindingsTable, InspectionFindingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionFindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requirementIdMeta = const VerificationMeta(
    'requirementId',
  );
  @override
  late final GeneratedColumn<String> requirementId = GeneratedColumn<String>(
    'requirement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FindingStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FindingStatus>($InspectionFindingsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<FindingSeverity, String>
  severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  ).withConverter<FindingSeverity>($InspectionFindingsTable.$converterseverity);
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    inspectionId,
    requirementId,
    description,
    status,
    severity,
    createdAt,
    updatedAt,
    localVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_findings';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionFindingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('requirement_id')) {
      context.handle(
        _requirementIdMeta,
        requirementId.isAcceptableOrUnknown(
          data['requirement_id']!,
          _requirementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requirementIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
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
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  InspectionFindingEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionFindingEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      requirementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requirement_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: $InspectionFindingsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      severity: $InspectionFindingsTable.$converterseverity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}severity'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
    );
  }

  @override
  $InspectionFindingsTable createAlias(String alias) {
    return $InspectionFindingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FindingStatus, String, String> $converterstatus =
      const EnumNameConverter(FindingStatus.values);
  static JsonTypeConverter2<FindingSeverity, String, String>
  $converterseverity = const EnumNameConverter(FindingSeverity.values);
}

class InspectionFindingEntity extends DataClass
    implements Insertable<InspectionFindingEntity> {
  final String localId;
  final String? serverId;
  final String inspectionId;
  final String requirementId;
  final String description;
  final FindingStatus status;
  final FindingSeverity severity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;
  const InspectionFindingEntity({
    required this.localId,
    this.serverId,
    required this.inspectionId,
    required this.requirementId,
    required this.description,
    required this.status,
    required this.severity,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['inspection_id'] = Variable<String>(inspectionId);
    map['requirement_id'] = Variable<String>(requirementId);
    map['description'] = Variable<String>(description);
    {
      map['status'] = Variable<String>(
        $InspectionFindingsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['severity'] = Variable<String>(
        $InspectionFindingsTable.$converterseverity.toSql(severity),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['local_version'] = Variable<int>(localVersion);
    return map;
  }

  InspectionFindingsCompanion toCompanion(bool nullToAbsent) {
    return InspectionFindingsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      inspectionId: Value(inspectionId),
      requirementId: Value(requirementId),
      description: Value(description),
      status: Value(status),
      severity: Value(severity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      localVersion: Value(localVersion),
    );
  }

  factory InspectionFindingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionFindingEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      requirementId: serializer.fromJson<String>(json['requirementId']),
      description: serializer.fromJson<String>(json['description']),
      status: $InspectionFindingsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      severity: $InspectionFindingsTable.$converterseverity.fromJson(
        serializer.fromJson<String>(json['severity']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'requirementId': serializer.toJson<String>(requirementId),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(
        $InspectionFindingsTable.$converterstatus.toJson(status),
      ),
      'severity': serializer.toJson<String>(
        $InspectionFindingsTable.$converterseverity.toJson(severity),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'localVersion': serializer.toJson<int>(localVersion),
    };
  }

  InspectionFindingEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? inspectionId,
    String? requirementId,
    String? description,
    FindingStatus? status,
    FindingSeverity? severity,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) => InspectionFindingEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    inspectionId: inspectionId ?? this.inspectionId,
    requirementId: requirementId ?? this.requirementId,
    description: description ?? this.description,
    status: status ?? this.status,
    severity: severity ?? this.severity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    localVersion: localVersion ?? this.localVersion,
  );
  InspectionFindingEntity copyWithCompanion(InspectionFindingsCompanion data) {
    return InspectionFindingEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      requirementId: data.requirementId.present
          ? data.requirementId.value
          : this.requirementId,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFindingEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('requirementId: $requirementId, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    inspectionId,
    requirementId,
    description,
    status,
    severity,
    createdAt,
    updatedAt,
    localVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionFindingEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.inspectionId == this.inspectionId &&
          other.requirementId == this.requirementId &&
          other.description == this.description &&
          other.status == this.status &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.localVersion == this.localVersion);
}

class InspectionFindingsCompanion
    extends UpdateCompanion<InspectionFindingEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> inspectionId;
  final Value<String> requirementId;
  final Value<String> description;
  final Value<FindingStatus> status;
  final Value<FindingSeverity> severity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> localVersion;
  final Value<int> rowid;
  const InspectionFindingsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.requirementId = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionFindingsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String inspectionId,
    required String requirementId,
    required String description,
    required FindingStatus status,
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       inspectionId = Value(inspectionId),
       requirementId = Value(requirementId),
       description = Value(description),
       status = Value(status);
  static Insertable<InspectionFindingEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? inspectionId,
    Expression<String>? requirementId,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? severity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? localVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (requirementId != null) 'requirement_id': requirementId,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (localVersion != null) 'local_version': localVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionFindingsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? inspectionId,
    Value<String>? requirementId,
    Value<String>? description,
    Value<FindingStatus>? status,
    Value<FindingSeverity>? severity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? localVersion,
    Value<int>? rowid,
  }) {
    return InspectionFindingsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      inspectionId: inspectionId ?? this.inspectionId,
      requirementId: requirementId ?? this.requirementId,
      description: description ?? this.description,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (requirementId.present) {
      map['requirement_id'] = Variable<String>(requirementId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InspectionFindingsTable.$converterstatus.toSql(status.value),
      );
    }
    if (severity.present) {
      map['severity'] = Variable<String>(
        $InspectionFindingsTable.$converterseverity.toSql(severity.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFindingsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('requirementId: $requirementId, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ViolationsTable extends Violations
    with TableInfo<$ViolationsTable, ViolationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ViolationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<String> inspectionId = GeneratedColumn<String>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _findingIdMeta = const VerificationMeta(
    'findingId',
  );
  @override
  late final GeneratedColumn<String> findingId = GeneratedColumn<String>(
    'finding_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mineIdMeta = const VerificationMeta('mineId');
  @override
  late final GeneratedColumn<String> mineId = GeneratedColumn<String>(
    'mine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ViolationSeverity, String>
  severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ViolationSeverity>($ViolationsTable.$converterseverity);
  @override
  late final GeneratedColumnWithTypeConverter<ViolationStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ViolationStatus>($ViolationsTable.$converterstatus);
  static const VerificationMeta _assignedToMeta = const VerificationMeta(
    'assignedTo',
  );
  @override
  late final GeneratedColumn<String> assignedTo = GeneratedColumn<String>(
    'assigned_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    inspectionId,
    findingId,
    mineId,
    title,
    description,
    severity,
    status,
    assignedTo,
    dueDate,
    detectedAt,
    createdAt,
    updatedAt,
    localVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'violations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ViolationEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('finding_id')) {
      context.handle(
        _findingIdMeta,
        findingId.isAcceptableOrUnknown(data['finding_id']!, _findingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_findingIdMeta);
    }
    if (data.containsKey('mine_id')) {
      context.handle(
        _mineIdMeta,
        mineId.isAcceptableOrUnknown(data['mine_id']!, _mineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mineIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('assigned_to')) {
      context.handle(
        _assignedToMeta,
        assignedTo.isAcceptableOrUnknown(data['assigned_to']!, _assignedToMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
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
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  ViolationEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ViolationEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspection_id'],
      )!,
      findingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finding_id'],
      )!,
      mineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mine_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      severity: $ViolationsTable.$converterseverity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}severity'],
        )!,
      ),
      status: $ViolationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      assignedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_to'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
    );
  }

  @override
  $ViolationsTable createAlias(String alias) {
    return $ViolationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ViolationSeverity, String, String>
  $converterseverity = const EnumNameConverter(ViolationSeverity.values);
  static JsonTypeConverter2<ViolationStatus, String, String> $converterstatus =
      const EnumNameConverter(ViolationStatus.values);
}

class ViolationEntity extends DataClass implements Insertable<ViolationEntity> {
  final String localId;
  final String? serverId;
  final String inspectionId;
  final String findingId;
  final String mineId;
  final String title;
  final String description;
  final ViolationSeverity severity;
  final ViolationStatus status;
  final String? assignedTo;
  final DateTime? dueDate;
  final DateTime detectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;
  const ViolationEntity({
    required this.localId,
    this.serverId,
    required this.inspectionId,
    required this.findingId,
    required this.mineId,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    this.assignedTo,
    this.dueDate,
    required this.detectedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['inspection_id'] = Variable<String>(inspectionId);
    map['finding_id'] = Variable<String>(findingId);
    map['mine_id'] = Variable<String>(mineId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['severity'] = Variable<String>(
        $ViolationsTable.$converterseverity.toSql(severity),
      );
    }
    {
      map['status'] = Variable<String>(
        $ViolationsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || assignedTo != null) {
      map['assigned_to'] = Variable<String>(assignedTo);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['detected_at'] = Variable<DateTime>(detectedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['local_version'] = Variable<int>(localVersion);
    return map;
  }

  ViolationsCompanion toCompanion(bool nullToAbsent) {
    return ViolationsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      inspectionId: Value(inspectionId),
      findingId: Value(findingId),
      mineId: Value(mineId),
      title: Value(title),
      description: Value(description),
      severity: Value(severity),
      status: Value(status),
      assignedTo: assignedTo == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTo),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      detectedAt: Value(detectedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      localVersion: Value(localVersion),
    );
  }

  factory ViolationEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ViolationEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      inspectionId: serializer.fromJson<String>(json['inspectionId']),
      findingId: serializer.fromJson<String>(json['findingId']),
      mineId: serializer.fromJson<String>(json['mineId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      severity: $ViolationsTable.$converterseverity.fromJson(
        serializer.fromJson<String>(json['severity']),
      ),
      status: $ViolationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      assignedTo: serializer.fromJson<String?>(json['assignedTo']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'inspectionId': serializer.toJson<String>(inspectionId),
      'findingId': serializer.toJson<String>(findingId),
      'mineId': serializer.toJson<String>(mineId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'severity': serializer.toJson<String>(
        $ViolationsTable.$converterseverity.toJson(severity),
      ),
      'status': serializer.toJson<String>(
        $ViolationsTable.$converterstatus.toJson(status),
      ),
      'assignedTo': serializer.toJson<String?>(assignedTo),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'localVersion': serializer.toJson<int>(localVersion),
    };
  }

  ViolationEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? inspectionId,
    String? findingId,
    String? mineId,
    String? title,
    String? description,
    ViolationSeverity? severity,
    ViolationStatus? status,
    Value<String?> assignedTo = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    DateTime? detectedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) => ViolationEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    inspectionId: inspectionId ?? this.inspectionId,
    findingId: findingId ?? this.findingId,
    mineId: mineId ?? this.mineId,
    title: title ?? this.title,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    status: status ?? this.status,
    assignedTo: assignedTo.present ? assignedTo.value : this.assignedTo,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    detectedAt: detectedAt ?? this.detectedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    localVersion: localVersion ?? this.localVersion,
  );
  ViolationEntity copyWithCompanion(ViolationsCompanion data) {
    return ViolationEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      findingId: data.findingId.present ? data.findingId.value : this.findingId,
      mineId: data.mineId.present ? data.mineId.value : this.mineId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      severity: data.severity.present ? data.severity.value : this.severity,
      status: data.status.present ? data.status.value : this.status,
      assignedTo: data.assignedTo.present
          ? data.assignedTo.value
          : this.assignedTo,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ViolationEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('findingId: $findingId, ')
          ..write('mineId: $mineId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('status: $status, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('dueDate: $dueDate, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    inspectionId,
    findingId,
    mineId,
    title,
    description,
    severity,
    status,
    assignedTo,
    dueDate,
    detectedAt,
    createdAt,
    updatedAt,
    localVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ViolationEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.inspectionId == this.inspectionId &&
          other.findingId == this.findingId &&
          other.mineId == this.mineId &&
          other.title == this.title &&
          other.description == this.description &&
          other.severity == this.severity &&
          other.status == this.status &&
          other.assignedTo == this.assignedTo &&
          other.dueDate == this.dueDate &&
          other.detectedAt == this.detectedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.localVersion == this.localVersion);
}

class ViolationsCompanion extends UpdateCompanion<ViolationEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> inspectionId;
  final Value<String> findingId;
  final Value<String> mineId;
  final Value<String> title;
  final Value<String> description;
  final Value<ViolationSeverity> severity;
  final Value<ViolationStatus> status;
  final Value<String?> assignedTo;
  final Value<DateTime?> dueDate;
  final Value<DateTime> detectedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> localVersion;
  final Value<int> rowid;
  const ViolationsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.findingId = const Value.absent(),
    this.mineId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.severity = const Value.absent(),
    this.status = const Value.absent(),
    this.assignedTo = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ViolationsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String inspectionId,
    required String findingId,
    required String mineId,
    required String title,
    required String description,
    required ViolationSeverity severity,
    required ViolationStatus status,
    this.assignedTo = const Value.absent(),
    this.dueDate = const Value.absent(),
    required DateTime detectedAt,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       inspectionId = Value(inspectionId),
       findingId = Value(findingId),
       mineId = Value(mineId),
       title = Value(title),
       description = Value(description),
       severity = Value(severity),
       status = Value(status),
       detectedAt = Value(detectedAt);
  static Insertable<ViolationEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? inspectionId,
    Expression<String>? findingId,
    Expression<String>? mineId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? severity,
    Expression<String>? status,
    Expression<String>? assignedTo,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? localVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (findingId != null) 'finding_id': findingId,
      if (mineId != null) 'mine_id': mineId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (severity != null) 'severity': severity,
      if (status != null) 'status': status,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (dueDate != null) 'due_date': dueDate,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (localVersion != null) 'local_version': localVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ViolationsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? inspectionId,
    Value<String>? findingId,
    Value<String>? mineId,
    Value<String>? title,
    Value<String>? description,
    Value<ViolationSeverity>? severity,
    Value<ViolationStatus>? status,
    Value<String?>? assignedTo,
    Value<DateTime?>? dueDate,
    Value<DateTime>? detectedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? localVersion,
    Value<int>? rowid,
  }) {
    return ViolationsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      inspectionId: inspectionId ?? this.inspectionId,
      findingId: findingId ?? this.findingId,
      mineId: mineId ?? this.mineId,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<String>(inspectionId.value);
    }
    if (findingId.present) {
      map['finding_id'] = Variable<String>(findingId.value);
    }
    if (mineId.present) {
      map['mine_id'] = Variable<String>(mineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(
        $ViolationsTable.$converterseverity.toSql(severity.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ViolationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (assignedTo.present) {
      map['assigned_to'] = Variable<String>(assignedTo.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ViolationsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('findingId: $findingId, ')
          ..write('mineId: $mineId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('status: $status, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('dueDate: $dueDate, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localVersion: $localVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, AlertEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _mineIdMeta = const VerificationMeta('mineId');
  @override
  late final GeneratedColumn<String> mineId = GeneratedColumn<String>(
    'mine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    mineId,
    title,
    message,
    severity,
    createdAt,
    isRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('mine_id')) {
      context.handle(
        _mineIdMeta,
        mineId.isAcceptableOrUnknown(data['mine_id']!, _mineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mineIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  AlertEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      mineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mine_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class AlertEntity extends DataClass implements Insertable<AlertEntity> {
  final String localId;
  final String? serverId;
  final String mineId;
  final String title;
  final String message;
  final String severity;
  final DateTime createdAt;
  final bool isRead;
  const AlertEntity({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    required this.isRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['mine_id'] = Variable<String>(mineId);
    map['title'] = Variable<String>(title);
    map['message'] = Variable<String>(message);
    map['severity'] = Variable<String>(severity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      mineId: Value(mineId),
      title: Value(title),
      message: Value(message),
      severity: Value(severity),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  factory AlertEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      mineId: serializer.fromJson<String>(json['mineId']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String>(json['message']),
      severity: serializer.fromJson<String>(json['severity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'mineId': serializer.toJson<String>(mineId),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String>(message),
      'severity': serializer.toJson<String>(severity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  AlertEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? mineId,
    String? title,
    String? message,
    String? severity,
    DateTime? createdAt,
    bool? isRead,
  }) => AlertEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    mineId: mineId ?? this.mineId,
    title: title ?? this.title,
    message: message ?? this.message,
    severity: severity ?? this.severity,
    createdAt: createdAt ?? this.createdAt,
    isRead: isRead ?? this.isRead,
  );
  AlertEntity copyWithCompanion(AlertsCompanion data) {
    return AlertEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      mineId: data.mineId.present ? data.mineId.value : this.mineId,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('mineId: $mineId, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    mineId,
    title,
    message,
    severity,
    createdAt,
    isRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.mineId == this.mineId &&
          other.title == this.title &&
          other.message == this.message &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.isRead == this.isRead);
}

class AlertsCompanion extends UpdateCompanion<AlertEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> mineId;
  final Value<String> title;
  final Value<String> message;
  final Value<String> severity;
  final Value<DateTime> createdAt;
  final Value<bool> isRead;
  final Value<int> rowid;
  const AlertsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.mineId = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String mineId,
    required String title,
    required String message,
    required String severity,
    this.createdAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       mineId = Value(mineId),
       title = Value(title),
       message = Value(message),
       severity = Value(severity);
  static Insertable<AlertEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? mineId,
    Expression<String>? title,
    Expression<String>? message,
    Expression<String>? severity,
    Expression<DateTime>? createdAt,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (mineId != null) 'mine_id': mineId,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? mineId,
    Value<String>? title,
    Value<String>? message,
    Value<String>? severity,
    Value<DateTime>? createdAt,
    Value<bool>? isRead,
    Value<int>? rowid,
  }) {
    return AlertsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      mineId: mineId ?? this.mineId,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (mineId.present) {
      map['mine_id'] = Variable<String>(mineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('mineId: $mineId, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorrectiveActionsTable extends CorrectiveActions
    with TableInfo<$CorrectiveActionsTable, CorrectiveActionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorrectiveActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _violationIdMeta = const VerificationMeta(
    'violationId',
  );
  @override
  late final GeneratedColumn<String> violationId = GeneratedColumn<String>(
    'violation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedToMeta = const VerificationMeta(
    'assignedTo',
  );
  @override
  late final GeneratedColumn<String> assignedTo = GeneratedColumn<String>(
    'assigned_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CorrectiveActionStatus, String>
  status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CorrectiveActionStatus>(
        $CorrectiveActionsTable.$converterstatus,
      );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifiedAtMeta = const VerificationMeta(
    'verifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> verifiedAt = GeneratedColumn<DateTime>(
    'verified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evidenceMeta = const VerificationMeta(
    'evidence',
  );
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
    'evidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    violationId,
    title,
    description,
    assignedTo,
    priority,
    dueDate,
    status,
    submittedAt,
    verifiedAt,
    evidence,
    localVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'corrective_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CorrectiveActionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('violation_id')) {
      context.handle(
        _violationIdMeta,
        violationId.isAcceptableOrUnknown(
          data['violation_id']!,
          _violationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_violationIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('assigned_to')) {
      context.handle(
        _assignedToMeta,
        assignedTo.isAcceptableOrUnknown(data['assigned_to']!, _assignedToMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedToMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    }
    if (data.containsKey('verified_at')) {
      context.handle(
        _verifiedAtMeta,
        verifiedAt.isAcceptableOrUnknown(data['verified_at']!, _verifiedAtMeta),
      );
    }
    if (data.containsKey('evidence')) {
      context.handle(
        _evidenceMeta,
        evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta),
      );
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  CorrectiveActionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorrectiveActionEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      violationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}violation_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      assignedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_to'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: $CorrectiveActionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      ),
      verifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}verified_at'],
      ),
      evidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence'],
      ),
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CorrectiveActionsTable createAlias(String alias) {
    return $CorrectiveActionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CorrectiveActionStatus, String, String>
  $converterstatus = const EnumNameConverter(CorrectiveActionStatus.values);
}

class CorrectiveActionEntity extends DataClass
    implements Insertable<CorrectiveActionEntity> {
  final String localId;
  final String? serverId;
  final String violationId;
  final String title;
  final String description;
  final String assignedTo;
  final String priority;
  final DateTime dueDate;
  final CorrectiveActionStatus status;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final String? evidence;
  final int localVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CorrectiveActionEntity({
    required this.localId,
    this.serverId,
    required this.violationId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
    required this.status,
    this.submittedAt,
    this.verifiedAt,
    this.evidence,
    required this.localVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['violation_id'] = Variable<String>(violationId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['assigned_to'] = Variable<String>(assignedTo);
    map['priority'] = Variable<String>(priority);
    map['due_date'] = Variable<DateTime>(dueDate);
    {
      map['status'] = Variable<String>(
        $CorrectiveActionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    if (!nullToAbsent || verifiedAt != null) {
      map['verified_at'] = Variable<DateTime>(verifiedAt);
    }
    if (!nullToAbsent || evidence != null) {
      map['evidence'] = Variable<String>(evidence);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CorrectiveActionsCompanion toCompanion(bool nullToAbsent) {
    return CorrectiveActionsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      violationId: Value(violationId),
      title: Value(title),
      description: Value(description),
      assignedTo: Value(assignedTo),
      priority: Value(priority),
      dueDate: Value(dueDate),
      status: Value(status),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
      verifiedAt: verifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedAt),
      evidence: evidence == null && nullToAbsent
          ? const Value.absent()
          : Value(evidence),
      localVersion: Value(localVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CorrectiveActionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorrectiveActionEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      violationId: serializer.fromJson<String>(json['violationId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      assignedTo: serializer.fromJson<String>(json['assignedTo']),
      priority: serializer.fromJson<String>(json['priority']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: $CorrectiveActionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
      verifiedAt: serializer.fromJson<DateTime?>(json['verifiedAt']),
      evidence: serializer.fromJson<String?>(json['evidence']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'violationId': serializer.toJson<String>(violationId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'assignedTo': serializer.toJson<String>(assignedTo),
      'priority': serializer.toJson<String>(priority),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(
        $CorrectiveActionsTable.$converterstatus.toJson(status),
      ),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
      'verifiedAt': serializer.toJson<DateTime?>(verifiedAt),
      'evidence': serializer.toJson<String?>(evidence),
      'localVersion': serializer.toJson<int>(localVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CorrectiveActionEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? violationId,
    String? title,
    String? description,
    String? assignedTo,
    String? priority,
    DateTime? dueDate,
    CorrectiveActionStatus? status,
    Value<DateTime?> submittedAt = const Value.absent(),
    Value<DateTime?> verifiedAt = const Value.absent(),
    Value<String?> evidence = const Value.absent(),
    int? localVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CorrectiveActionEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    violationId: violationId ?? this.violationId,
    title: title ?? this.title,
    description: description ?? this.description,
    assignedTo: assignedTo ?? this.assignedTo,
    priority: priority ?? this.priority,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
    verifiedAt: verifiedAt.present ? verifiedAt.value : this.verifiedAt,
    evidence: evidence.present ? evidence.value : this.evidence,
    localVersion: localVersion ?? this.localVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CorrectiveActionEntity copyWithCompanion(CorrectiveActionsCompanion data) {
    return CorrectiveActionEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      violationId: data.violationId.present
          ? data.violationId.value
          : this.violationId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      assignedTo: data.assignedTo.present
          ? data.assignedTo.value
          : this.assignedTo,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      verifiedAt: data.verifiedAt.present
          ? data.verifiedAt.value
          : this.verifiedAt,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorrectiveActionEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('violationId: $violationId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('evidence: $evidence, ')
          ..write('localVersion: $localVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    violationId,
    title,
    description,
    assignedTo,
    priority,
    dueDate,
    status,
    submittedAt,
    verifiedAt,
    evidence,
    localVersion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorrectiveActionEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.violationId == this.violationId &&
          other.title == this.title &&
          other.description == this.description &&
          other.assignedTo == this.assignedTo &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.submittedAt == this.submittedAt &&
          other.verifiedAt == this.verifiedAt &&
          other.evidence == this.evidence &&
          other.localVersion == this.localVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CorrectiveActionsCompanion
    extends UpdateCompanion<CorrectiveActionEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> violationId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> assignedTo;
  final Value<String> priority;
  final Value<DateTime> dueDate;
  final Value<CorrectiveActionStatus> status;
  final Value<DateTime?> submittedAt;
  final Value<DateTime?> verifiedAt;
  final Value<String?> evidence;
  final Value<int> localVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CorrectiveActionsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.violationId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.assignedTo = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.evidence = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorrectiveActionsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String violationId,
    required String title,
    required String description,
    required String assignedTo,
    required String priority,
    required DateTime dueDate,
    required CorrectiveActionStatus status,
    this.submittedAt = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.evidence = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       violationId = Value(violationId),
       title = Value(title),
       description = Value(description),
       assignedTo = Value(assignedTo),
       priority = Value(priority),
       dueDate = Value(dueDate),
       status = Value(status);
  static Insertable<CorrectiveActionEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? violationId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? assignedTo,
    Expression<String>? priority,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<DateTime>? submittedAt,
    Expression<DateTime>? verifiedAt,
    Expression<String>? evidence,
    Expression<int>? localVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (violationId != null) 'violation_id': violationId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (verifiedAt != null) 'verified_at': verifiedAt,
      if (evidence != null) 'evidence': evidence,
      if (localVersion != null) 'local_version': localVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorrectiveActionsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? violationId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? assignedTo,
    Value<String>? priority,
    Value<DateTime>? dueDate,
    Value<CorrectiveActionStatus>? status,
    Value<DateTime?>? submittedAt,
    Value<DateTime?>? verifiedAt,
    Value<String?>? evidence,
    Value<int>? localVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CorrectiveActionsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      violationId: violationId ?? this.violationId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      evidence: evidence ?? this.evidence,
      localVersion: localVersion ?? this.localVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (violationId.present) {
      map['violation_id'] = Variable<String>(violationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (assignedTo.present) {
      map['assigned_to'] = Variable<String>(assignedTo.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $CorrectiveActionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (verifiedAt.present) {
      map['verified_at'] = Variable<DateTime>(verifiedAt.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorrectiveActionsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('violationId: $violationId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('evidence: $evidence, ')
          ..write('localVersion: $localVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditTrailsTable extends AuditTrails
    with TableInfo<$AuditTrailsTable, AuditTrailEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditTrailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousStateMeta = const VerificationMeta(
    'previousState',
  );
  @override
  late final GeneratedColumn<String> previousState = GeneratedColumn<String>(
    'previous_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newStateMeta = const VerificationMeta(
    'newState',
  );
  @override
  late final GeneratedColumn<String> newState = GeneratedColumn<String>(
    'new_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    entityType,
    entityId,
    action,
    previousState,
    newState,
    actorId,
    timestamp,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_trails';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditTrailEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
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
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('previous_state')) {
      context.handle(
        _previousStateMeta,
        previousState.isAcceptableOrUnknown(
          data['previous_state']!,
          _previousStateMeta,
        ),
      );
    }
    if (data.containsKey('new_state')) {
      context.handle(
        _newStateMeta,
        newState.isAcceptableOrUnknown(data['new_state']!, _newStateMeta),
      );
    } else if (isInserting) {
      context.missing(_newStateMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  AuditTrailEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditTrailEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      previousState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_state'],
      ),
      newState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_state'],
      )!,
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
    );
  }

  @override
  $AuditTrailsTable createAlias(String alias) {
    return $AuditTrailsTable(attachedDatabase, alias);
  }
}

class AuditTrailEntity extends DataClass
    implements Insertable<AuditTrailEntity> {
  final String localId;
  final String? serverId;
  final String entityType;
  final String entityId;
  final String action;
  final String? previousState;
  final String newState;
  final String actorId;
  final DateTime timestamp;
  final String? comment;
  const AuditTrailEntity({
    required this.localId,
    this.serverId,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.previousState,
    required this.newState,
    required this.actorId,
    required this.timestamp,
    this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || previousState != null) {
      map['previous_state'] = Variable<String>(previousState);
    }
    map['new_state'] = Variable<String>(newState);
    map['actor_id'] = Variable<String>(actorId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  AuditTrailsCompanion toCompanion(bool nullToAbsent) {
    return AuditTrailsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      previousState: previousState == null && nullToAbsent
          ? const Value.absent()
          : Value(previousState),
      newState: Value(newState),
      actorId: Value(actorId),
      timestamp: Value(timestamp),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory AuditTrailEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditTrailEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      previousState: serializer.fromJson<String?>(json['previousState']),
      newState: serializer.fromJson<String>(json['newState']),
      actorId: serializer.fromJson<String>(json['actorId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'previousState': serializer.toJson<String?>(previousState),
      'newState': serializer.toJson<String>(newState),
      'actorId': serializer.toJson<String>(actorId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  AuditTrailEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    String? entityType,
    String? entityId,
    String? action,
    Value<String?> previousState = const Value.absent(),
    String? newState,
    String? actorId,
    DateTime? timestamp,
    Value<String?> comment = const Value.absent(),
  }) => AuditTrailEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    previousState: previousState.present
        ? previousState.value
        : this.previousState,
    newState: newState ?? this.newState,
    actorId: actorId ?? this.actorId,
    timestamp: timestamp ?? this.timestamp,
    comment: comment.present ? comment.value : this.comment,
  );
  AuditTrailEntity copyWithCompanion(AuditTrailsCompanion data) {
    return AuditTrailEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      previousState: data.previousState.present
          ? data.previousState.value
          : this.previousState,
      newState: data.newState.present ? data.newState.value : this.newState,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditTrailEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('previousState: $previousState, ')
          ..write('newState: $newState, ')
          ..write('actorId: $actorId, ')
          ..write('timestamp: $timestamp, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    entityType,
    entityId,
    action,
    previousState,
    newState,
    actorId,
    timestamp,
    comment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditTrailEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.previousState == this.previousState &&
          other.newState == this.newState &&
          other.actorId == this.actorId &&
          other.timestamp == this.timestamp &&
          other.comment == this.comment);
}

class AuditTrailsCompanion extends UpdateCompanion<AuditTrailEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> previousState;
  final Value<String> newState;
  final Value<String> actorId;
  final Value<DateTime> timestamp;
  final Value<String?> comment;
  final Value<int> rowid;
  const AuditTrailsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.previousState = const Value.absent(),
    this.newState = const Value.absent(),
    this.actorId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditTrailsCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String action,
    this.previousState = const Value.absent(),
    required String newState,
    required String actorId,
    this.timestamp = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action),
       newState = Value(newState),
       actorId = Value(actorId);
  static Insertable<AuditTrailEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? previousState,
    Expression<String>? newState,
    Expression<String>? actorId,
    Expression<DateTime>? timestamp,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (previousState != null) 'previous_state': previousState,
      if (newState != null) 'new_state': newState,
      if (actorId != null) 'actor_id': actorId,
      if (timestamp != null) 'timestamp': timestamp,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditTrailsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<String?>? previousState,
    Value<String>? newState,
    Value<String>? actorId,
    Value<DateTime>? timestamp,
    Value<String?>? comment,
    Value<int>? rowid,
  }) {
    return AuditTrailsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      previousState: previousState ?? this.previousState,
      newState: newState ?? this.newState,
      actorId: actorId ?? this.actorId,
      timestamp: timestamp ?? this.timestamp,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (previousState.present) {
      map['previous_state'] = Variable<String>(previousState.value);
    }
    if (newState.present) {
      map['new_state'] = Variable<String>(newState.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditTrailsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('previousState: $previousState, ')
          ..write('newState: $newState, ')
          ..write('actorId: $actorId, ')
          ..write('timestamp: $timestamp, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MinesTable mines = $MinesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $InspectionFindingsTable inspectionFindings =
      $InspectionFindingsTable(this);
  late final $ViolationsTable violations = $ViolationsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $CorrectiveActionsTable correctiveActions =
      $CorrectiveActionsTable(this);
  late final $AuditTrailsTable auditTrails = $AuditTrailsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    mines,
    syncQueue,
    inspections,
    inspectionFindings,
    violations,
    alerts,
    correctiveActions,
    auditTrails,
  ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String email,
  required UserRole role,
  required String permissions,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> email,
  Value<UserRole> role,
  Value<String> permissions,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UserRole, UserRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UserRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserEntity,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
          UserEntity,
          PrefetchHooks Function()
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
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<UserRole> role = const Value.absent(),
                Value<String> permissions = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                role: role,
                permissions: permissions,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required UserRole role,
                required String permissions,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                role: role,
                permissions: permissions,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, UserEntity>(table),
                  BaseReferences<_$AppDatabase, $UsersTable, UserEntity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserEntity,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
      UserEntity,
      PrefetchHooks Function()
    >;
typedef $$MinesTableCreateCompanionBuilder = MinesCompanion Function({
  required String localId,
  Value<String?> serverId,
  required String name,
  required String mineCode,
  required double latitude,
  required double longitude,
  required MineStatus status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> localVersion,
  Value<int> rowid,
});
typedef $$MinesTableUpdateCompanionBuilder = MinesCompanion Function({
  Value<String> localId,
  Value<String?> serverId,
  Value<String> name,
  Value<String> mineCode,
  Value<double> latitude,
  Value<double> longitude,
  Value<MineStatus> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> localVersion,
  Value<int> rowid,
});

class $$MinesTableFilterComposer extends Composer<_$AppDatabase, $MinesTable> {
  $$MinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
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

  ColumnFilters<String> get mineCode => $composableBuilder(
    column: $table.mineCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MineStatus, MineStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MinesTable> {
  $$MinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
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

  ColumnOrderings<String> get mineCode => $composableBuilder(
    column: $table.mineCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MinesTable> {
  $$MinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mineCode =>
      $composableBuilder(column: $table.mineCode, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MineStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );
}

class $$MinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MinesTable,
          MineEntity,
          $$MinesTableFilterComposer,
          $$MinesTableOrderingComposer,
          $$MinesTableAnnotationComposer,
          $$MinesTableCreateCompanionBuilder,
          $$MinesTableUpdateCompanionBuilder,
          (MineEntity, BaseReferences<_$AppDatabase, $MinesTable, MineEntity>),
          MineEntity,
          PrefetchHooks Function()
        > {
  $$MinesTableTableManager(_$AppDatabase db, $MinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mineCode = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<MineStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MinesCompanion(
                localId: localId,
                serverId: serverId,
                name: name,
                mineCode: mineCode,
                latitude: latitude,
                longitude: longitude,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String name,
                required String mineCode,
                required double latitude,
                required double longitude,
                required MineStatus status,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MinesCompanion.insert(
                localId: localId,
                serverId: serverId,
                name: name,
                mineCode: mineCode,
                latitude: latitude,
                longitude: longitude,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MinesTable, MineEntity>(table),
                  BaseReferences<_$AppDatabase, $MinesTable, MineEntity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MinesTable,
      MineEntity,
      $$MinesTableFilterComposer,
      $$MinesTableOrderingComposer,
      $$MinesTableAnnotationComposer,
      $$MinesTableCreateCompanionBuilder,
      $$MinesTableUpdateCompanionBuilder,
      (MineEntity, BaseReferences<_$AppDatabase, $MinesTable, MineEntity>),
      MineEntity,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String localId,
  Value<String?> serverId,
  required String featureName,
  required String actionType,
  required String payloadJson,
  required SyncStatus syncStatus,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<int> localVersion,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> localId,
  Value<String?> serverId,
  Value<String> featureName,
  Value<String> actionType,
  Value<String> payloadJson,
  Value<SyncStatus> syncStatus,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<int> localVersion,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureName => $composableBuilder(
    column: $table.featureName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
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
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureName => $composableBuilder(
    column: $table.featureName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
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
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get featureName => $composableBuilder(
    column: $table.featureName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueEntity,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueEntity,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntity>,
          ),
          SyncQueueEntity,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> featureName = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                localId: localId,
                serverId: serverId,
                featureName: featureName,
                actionType: actionType,
                payloadJson: payloadJson,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastError: lastError,
                localVersion: localVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String featureName,
                required String actionType,
                required String payloadJson,
                required SyncStatus syncStatus,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                localId: localId,
                serverId: serverId,
                featureName: featureName,
                actionType: actionType,
                payloadJson: payloadJson,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastError: lastError,
                localVersion: localVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncQueueTable,
                    SyncQueueEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueEntity,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueEntity,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueEntity>,
      ),
      SyncQueueEntity,
      PrefetchHooks Function()
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      required String localId,
      Value<String?> serverId,
      required String mineId,
      required String inspectorId,
      required InspectionStatus status,
      Value<InspectionCategory> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> localVersion,
      Value<int> rowid,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<String> mineId,
      Value<String> inspectorId,
      Value<InspectionStatus> status,
      Value<InspectionCategory> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> localVersion,
      Value<int> rowid,
    });

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectorId => $composableBuilder(
    column: $table.inspectorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionStatus, InspectionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionCategory, InspectionCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectorId => $composableBuilder(
    column: $table.inspectorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
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

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get mineId =>
      $composableBuilder(column: $table.mineId, builder: (column) => column);

  GeneratedColumn<String> get inspectorId => $composableBuilder(
    column: $table.inspectorId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InspectionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          InspectionEntity,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (
            InspectionEntity,
            BaseReferences<_$AppDatabase, $InspectionsTable, InspectionEntity>,
          ),
          InspectionEntity,
          PrefetchHooks Function()
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> mineId = const Value.absent(),
                Value<String> inspectorId = const Value.absent(),
                Value<InspectionStatus> status = const Value.absent(),
                Value<InspectionCategory> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion(
                localId: localId,
                serverId: serverId,
                mineId: mineId,
                inspectorId: inspectorId,
                status: status,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String mineId,
                required String inspectorId,
                required InspectionStatus status,
                Value<InspectionCategory> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionsCompanion.insert(
                localId: localId,
                serverId: serverId,
                mineId: mineId,
                inspectorId: inspectorId,
                status: status,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionsTable, InspectionEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionsTable,
                    InspectionEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      InspectionEntity,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (
        InspectionEntity,
        BaseReferences<_$AppDatabase, $InspectionsTable, InspectionEntity>,
      ),
      InspectionEntity,
      PrefetchHooks Function()
    >;
typedef $$InspectionFindingsTableCreateCompanionBuilder =
    InspectionFindingsCompanion Function({
      required String localId,
      Value<String?> serverId,
      required String inspectionId,
      required String requirementId,
      required String description,
      required FindingStatus status,
      Value<FindingSeverity> severity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> localVersion,
      Value<int> rowid,
    });
typedef $$InspectionFindingsTableUpdateCompanionBuilder =
    InspectionFindingsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<String> inspectionId,
      Value<String> requirementId,
      Value<String> description,
      Value<FindingStatus> status,
      Value<FindingSeverity> severity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> localVersion,
      Value<int> rowid,
    });

class $$InspectionFindingsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionFindingsTable> {
  $$InspectionFindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requirementId => $composableBuilder(
    column: $table.requirementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FindingStatus, FindingStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FindingSeverity, FindingSeverity, String>
  get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionFindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionFindingsTable> {
  $$InspectionFindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requirementId => $composableBuilder(
    column: $table.requirementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
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

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionFindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionFindingsTable> {
  $$InspectionFindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requirementId => $composableBuilder(
    column: $table.requirementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FindingStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FindingSeverity, String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );
}

class $$InspectionFindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionFindingsTable,
          InspectionFindingEntity,
          $$InspectionFindingsTableFilterComposer,
          $$InspectionFindingsTableOrderingComposer,
          $$InspectionFindingsTableAnnotationComposer,
          $$InspectionFindingsTableCreateCompanionBuilder,
          $$InspectionFindingsTableUpdateCompanionBuilder,
          (
            InspectionFindingEntity,
            BaseReferences<
              _$AppDatabase,
              $InspectionFindingsTable,
              InspectionFindingEntity
            >,
          ),
          InspectionFindingEntity,
          PrefetchHooks Function()
        > {
  $$InspectionFindingsTableTableManager(
    _$AppDatabase db,
    $InspectionFindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionFindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionFindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionFindingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> requirementId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<FindingStatus> status = const Value.absent(),
                Value<FindingSeverity> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFindingsCompanion(
                localId: localId,
                serverId: serverId,
                inspectionId: inspectionId,
                requirementId: requirementId,
                description: description,
                status: status,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String inspectionId,
                required String requirementId,
                required String description,
                required FindingStatus status,
                Value<FindingSeverity> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFindingsCompanion.insert(
                localId: localId,
                serverId: serverId,
                inspectionId: inspectionId,
                requirementId: requirementId,
                description: description,
                status: status,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $InspectionFindingsTable,
                    InspectionFindingEntity
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionFindingsTable,
                    InspectionFindingEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionFindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionFindingsTable,
      InspectionFindingEntity,
      $$InspectionFindingsTableFilterComposer,
      $$InspectionFindingsTableOrderingComposer,
      $$InspectionFindingsTableAnnotationComposer,
      $$InspectionFindingsTableCreateCompanionBuilder,
      $$InspectionFindingsTableUpdateCompanionBuilder,
      (
        InspectionFindingEntity,
        BaseReferences<
          _$AppDatabase,
          $InspectionFindingsTable,
          InspectionFindingEntity
        >,
      ),
      InspectionFindingEntity,
      PrefetchHooks Function()
    >;
typedef $$ViolationsTableCreateCompanionBuilder = ViolationsCompanion Function({
  required String localId,
  Value<String?> serverId,
  required String inspectionId,
  required String findingId,
  required String mineId,
  required String title,
  required String description,
  required ViolationSeverity severity,
  required ViolationStatus status,
  Value<String?> assignedTo,
  Value<DateTime?> dueDate,
  required DateTime detectedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> localVersion,
  Value<int> rowid,
});
typedef $$ViolationsTableUpdateCompanionBuilder = ViolationsCompanion Function({
  Value<String> localId,
  Value<String?> serverId,
  Value<String> inspectionId,
  Value<String> findingId,
  Value<String> mineId,
  Value<String> title,
  Value<String> description,
  Value<ViolationSeverity> severity,
  Value<ViolationStatus> status,
  Value<String?> assignedTo,
  Value<DateTime?> dueDate,
  Value<DateTime> detectedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> localVersion,
  Value<int> rowid,
});

class $$ViolationsTableFilterComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get findingId => $composableBuilder(
    column: $table.findingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ViolationSeverity, ViolationSeverity, String>
  get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ViolationStatus, ViolationStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
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

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ViolationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get findingId => $composableBuilder(
    column: $table.findingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
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

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ViolationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ViolationsTable> {
  $$ViolationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get inspectionId => $composableBuilder(
    column: $table.inspectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get findingId =>
      $composableBuilder(column: $table.findingId, builder: (column) => column);

  GeneratedColumn<String> get mineId =>
      $composableBuilder(column: $table.mineId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ViolationSeverity, String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ViolationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );
}

class $$ViolationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ViolationsTable,
          ViolationEntity,
          $$ViolationsTableFilterComposer,
          $$ViolationsTableOrderingComposer,
          $$ViolationsTableAnnotationComposer,
          $$ViolationsTableCreateCompanionBuilder,
          $$ViolationsTableUpdateCompanionBuilder,
          (
            ViolationEntity,
            BaseReferences<_$AppDatabase, $ViolationsTable, ViolationEntity>,
          ),
          ViolationEntity,
          PrefetchHooks Function()
        > {
  $$ViolationsTableTableManager(_$AppDatabase db, $ViolationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ViolationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ViolationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ViolationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> inspectionId = const Value.absent(),
                Value<String> findingId = const Value.absent(),
                Value<String> mineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<ViolationSeverity> severity = const Value.absent(),
                Value<ViolationStatus> status = const Value.absent(),
                Value<String?> assignedTo = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ViolationsCompanion(
                localId: localId,
                serverId: serverId,
                inspectionId: inspectionId,
                findingId: findingId,
                mineId: mineId,
                title: title,
                description: description,
                severity: severity,
                status: status,
                assignedTo: assignedTo,
                dueDate: dueDate,
                detectedAt: detectedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String inspectionId,
                required String findingId,
                required String mineId,
                required String title,
                required String description,
                required ViolationSeverity severity,
                required ViolationStatus status,
                Value<String?> assignedTo = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                required DateTime detectedAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ViolationsCompanion.insert(
                localId: localId,
                serverId: serverId,
                inspectionId: inspectionId,
                findingId: findingId,
                mineId: mineId,
                title: title,
                description: description,
                severity: severity,
                status: status,
                assignedTo: assignedTo,
                dueDate: dueDate,
                detectedAt: detectedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                localVersion: localVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ViolationsTable, ViolationEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ViolationsTable,
                    ViolationEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ViolationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ViolationsTable,
      ViolationEntity,
      $$ViolationsTableFilterComposer,
      $$ViolationsTableOrderingComposer,
      $$ViolationsTableAnnotationComposer,
      $$ViolationsTableCreateCompanionBuilder,
      $$ViolationsTableUpdateCompanionBuilder,
      (
        ViolationEntity,
        BaseReferences<_$AppDatabase, $ViolationsTable, ViolationEntity>,
      ),
      ViolationEntity,
      PrefetchHooks Function()
    >;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String localId,
  Value<String?> serverId,
  required String mineId,
  required String title,
  required String message,
  required String severity,
  Value<DateTime> createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> localId,
  Value<String?> serverId,
  Value<String> mineId,
  Value<String> title,
  Value<String> message,
  Value<String> severity,
  Value<DateTime> createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mineId => $composableBuilder(
    column: $table.mineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get mineId =>
      $composableBuilder(column: $table.mineId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$AlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertsTable,
          AlertEntity,
          $$AlertsTableFilterComposer,
          $$AlertsTableOrderingComposer,
          $$AlertsTableAnnotationComposer,
          $$AlertsTableCreateCompanionBuilder,
          $$AlertsTableUpdateCompanionBuilder,
          (
            AlertEntity,
            BaseReferences<_$AppDatabase, $AlertsTable, AlertEntity>,
          ),
          AlertEntity,
          PrefetchHooks Function()
        > {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> mineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion(
                localId: localId,
                serverId: serverId,
                mineId: mineId,
                title: title,
                message: message,
                severity: severity,
                createdAt: createdAt,
                isRead: isRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String mineId,
                required String title,
                required String message,
                required String severity,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion.insert(
                localId: localId,
                serverId: serverId,
                mineId: mineId,
                title: title,
                message: message,
                severity: severity,
                createdAt: createdAt,
                isRead: isRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlertsTable, AlertEntity>(table),
                  BaseReferences<_$AppDatabase, $AlertsTable, AlertEntity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertsTable,
      AlertEntity,
      $$AlertsTableFilterComposer,
      $$AlertsTableOrderingComposer,
      $$AlertsTableAnnotationComposer,
      $$AlertsTableCreateCompanionBuilder,
      $$AlertsTableUpdateCompanionBuilder,
      (AlertEntity, BaseReferences<_$AppDatabase, $AlertsTable, AlertEntity>),
      AlertEntity,
      PrefetchHooks Function()
    >;
typedef $$CorrectiveActionsTableCreateCompanionBuilder =
    CorrectiveActionsCompanion Function({
      required String localId,
      Value<String?> serverId,
      required String violationId,
      required String title,
      required String description,
      required String assignedTo,
      required String priority,
      required DateTime dueDate,
      required CorrectiveActionStatus status,
      Value<DateTime?> submittedAt,
      Value<DateTime?> verifiedAt,
      Value<String?> evidence,
      Value<int> localVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CorrectiveActionsTableUpdateCompanionBuilder =
    CorrectiveActionsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<String> violationId,
      Value<String> title,
      Value<String> description,
      Value<String> assignedTo,
      Value<String> priority,
      Value<DateTime> dueDate,
      Value<CorrectiveActionStatus> status,
      Value<DateTime?> submittedAt,
      Value<DateTime?> verifiedAt,
      Value<String?> evidence,
      Value<int> localVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CorrectiveActionsTableFilterComposer
    extends Composer<_$AppDatabase, $CorrectiveActionsTable> {
  $$CorrectiveActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get violationId => $composableBuilder(
    column: $table.violationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    CorrectiveActionStatus,
    CorrectiveActionStatus,
    String
  >
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
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
}

class $$CorrectiveActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CorrectiveActionsTable> {
  $$CorrectiveActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get violationId => $composableBuilder(
    column: $table.violationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
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
}

class $$CorrectiveActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorrectiveActionsTable> {
  $$CorrectiveActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get violationId => $composableBuilder(
    column: $table.violationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedTo => $composableBuilder(
    column: $table.assignedTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CorrectiveActionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get verifiedAt => $composableBuilder(
    column: $table.verifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CorrectiveActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CorrectiveActionsTable,
          CorrectiveActionEntity,
          $$CorrectiveActionsTableFilterComposer,
          $$CorrectiveActionsTableOrderingComposer,
          $$CorrectiveActionsTableAnnotationComposer,
          $$CorrectiveActionsTableCreateCompanionBuilder,
          $$CorrectiveActionsTableUpdateCompanionBuilder,
          (
            CorrectiveActionEntity,
            BaseReferences<
              _$AppDatabase,
              $CorrectiveActionsTable,
              CorrectiveActionEntity
            >,
          ),
          CorrectiveActionEntity,
          PrefetchHooks Function()
        > {
  $$CorrectiveActionsTableTableManager(
    _$AppDatabase db,
    $CorrectiveActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorrectiveActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorrectiveActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorrectiveActionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> violationId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> assignedTo = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<CorrectiveActionStatus> status = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<DateTime?> verifiedAt = const Value.absent(),
                Value<String?> evidence = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CorrectiveActionsCompanion(
                localId: localId,
                serverId: serverId,
                violationId: violationId,
                title: title,
                description: description,
                assignedTo: assignedTo,
                priority: priority,
                dueDate: dueDate,
                status: status,
                submittedAt: submittedAt,
                verifiedAt: verifiedAt,
                evidence: evidence,
                localVersion: localVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String violationId,
                required String title,
                required String description,
                required String assignedTo,
                required String priority,
                required DateTime dueDate,
                required CorrectiveActionStatus status,
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<DateTime?> verifiedAt = const Value.absent(),
                Value<String?> evidence = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CorrectiveActionsCompanion.insert(
                localId: localId,
                serverId: serverId,
                violationId: violationId,
                title: title,
                description: description,
                assignedTo: assignedTo,
                priority: priority,
                dueDate: dueDate,
                status: status,
                submittedAt: submittedAt,
                verifiedAt: verifiedAt,
                evidence: evidence,
                localVersion: localVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CorrectiveActionsTable, CorrectiveActionEntity>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CorrectiveActionsTable,
                    CorrectiveActionEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CorrectiveActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CorrectiveActionsTable,
      CorrectiveActionEntity,
      $$CorrectiveActionsTableFilterComposer,
      $$CorrectiveActionsTableOrderingComposer,
      $$CorrectiveActionsTableAnnotationComposer,
      $$CorrectiveActionsTableCreateCompanionBuilder,
      $$CorrectiveActionsTableUpdateCompanionBuilder,
      (
        CorrectiveActionEntity,
        BaseReferences<
          _$AppDatabase,
          $CorrectiveActionsTable,
          CorrectiveActionEntity
        >,
      ),
      CorrectiveActionEntity,
      PrefetchHooks Function()
    >;
typedef $$AuditTrailsTableCreateCompanionBuilder =
    AuditTrailsCompanion Function({
      required String localId,
      Value<String?> serverId,
      required String entityType,
      required String entityId,
      required String action,
      Value<String?> previousState,
      required String newState,
      required String actorId,
      Value<DateTime> timestamp,
      Value<String?> comment,
      Value<int> rowid,
    });
typedef $$AuditTrailsTableUpdateCompanionBuilder =
    AuditTrailsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> action,
      Value<String?> previousState,
      Value<String> newState,
      Value<String> actorId,
      Value<DateTime> timestamp,
      Value<String?> comment,
      Value<int> rowid,
    });

class $$AuditTrailsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditTrailsTable> {
  $$AuditTrailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
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

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newState => $composableBuilder(
    column: $table.newState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditTrailsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditTrailsTable> {
  $$AuditTrailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newState => $composableBuilder(
    column: $table.newState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditTrailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditTrailsTable> {
  $$AuditTrailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newState =>
      $composableBuilder(column: $table.newState, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$AuditTrailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditTrailsTable,
          AuditTrailEntity,
          $$AuditTrailsTableFilterComposer,
          $$AuditTrailsTableOrderingComposer,
          $$AuditTrailsTableAnnotationComposer,
          $$AuditTrailsTableCreateCompanionBuilder,
          $$AuditTrailsTableUpdateCompanionBuilder,
          (
            AuditTrailEntity,
            BaseReferences<_$AppDatabase, $AuditTrailsTable, AuditTrailEntity>,
          ),
          AuditTrailEntity,
          PrefetchHooks Function()
        > {
  $$AuditTrailsTableTableManager(_$AppDatabase db, $AuditTrailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditTrailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditTrailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditTrailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> previousState = const Value.absent(),
                Value<String> newState = const Value.absent(),
                Value<String> actorId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditTrailsCompanion(
                localId: localId,
                serverId: serverId,
                entityType: entityType,
                entityId: entityId,
                action: action,
                previousState: previousState,
                newState: newState,
                actorId: actorId,
                timestamp: timestamp,
                comment: comment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> serverId = const Value.absent(),
                required String entityType,
                required String entityId,
                required String action,
                Value<String?> previousState = const Value.absent(),
                required String newState,
                required String actorId,
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditTrailsCompanion.insert(
                localId: localId,
                serverId: serverId,
                entityType: entityType,
                entityId: entityId,
                action: action,
                previousState: previousState,
                newState: newState,
                actorId: actorId,
                timestamp: timestamp,
                comment: comment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditTrailsTable, AuditTrailEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AuditTrailsTable,
                    AuditTrailEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditTrailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditTrailsTable,
      AuditTrailEntity,
      $$AuditTrailsTableFilterComposer,
      $$AuditTrailsTableOrderingComposer,
      $$AuditTrailsTableAnnotationComposer,
      $$AuditTrailsTableCreateCompanionBuilder,
      $$AuditTrailsTableUpdateCompanionBuilder,
      (
        AuditTrailEntity,
        BaseReferences<_$AppDatabase, $AuditTrailsTable, AuditTrailEntity>,
      ),
      AuditTrailEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MinesTableTableManager get mines =>
      $$MinesTableTableManager(_db, _db.mines);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$InspectionFindingsTableTableManager get inspectionFindings =>
      $$InspectionFindingsTableTableManager(_db, _db.inspectionFindings);
  $$ViolationsTableTableManager get violations =>
      $$ViolationsTableTableManager(_db, _db.violations);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$CorrectiveActionsTableTableManager get correctiveActions =>
      $$CorrectiveActionsTableTableManager(_db, _db.correctiveActions);
  $$AuditTrailsTableTableManager get auditTrails =>
      $$AuditTrailsTableTableManager(_db, _db.auditTrails);
}
