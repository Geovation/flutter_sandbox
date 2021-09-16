// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PersonsMoorData extends DataClass implements Insertable<PersonsMoorData> {
  final int id;
  final String name;
  final int age;
  final String role;
  PersonsMoorData(
      {@required this.id, this.name, @required this.age, this.role});
  factory PersonsMoorData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return PersonsMoorData(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      age: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}age']),
      role: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}role']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    return map;
  }

  PersonsMoorCompanion toCompanion(bool nullToAbsent) {
    return PersonsMoorCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
    );
  }

  factory PersonsMoorData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PersonsMoorData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'role': serializer.toJson<String>(role),
    };
  }

  PersonsMoorData copyWith({int id, String name, int age, String role}) =>
      PersonsMoorData(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        role: role ?? this.role,
      );
  @override
  String toString() {
    return (StringBuffer('PersonsMoorData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode, $mrjc(name.hashCode, $mrjc(age.hashCode, role.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonsMoorData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.role == this.role);
}

class PersonsMoorCompanion extends UpdateCompanion<PersonsMoorData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String> role;
  const PersonsMoorCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.role = const Value.absent(),
  });
  PersonsMoorCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.role = const Value.absent(),
  });
  static Insertable<PersonsMoorData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> age,
    Expression<String> role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (role != null) 'role': role,
    });
  }

  PersonsMoorCompanion copyWith(
      {Value<int> id, Value<String> name, Value<int> age, Value<String> role}) {
    return PersonsMoorCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsMoorCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $PersonsMoorTable extends PersonsMoor
    with TableInfo<$PersonsMoorTable, PersonsMoorData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PersonsMoorTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name =>
      _name ??= GeneratedColumn<String>('name', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _ageMeta = const VerificationMeta('age');
  GeneratedColumn<int> _age;
  @override
  GeneratedColumn<int> get age =>
      _age ??= GeneratedColumn<int>('age', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultValue: Constant(0));
  final VerificationMeta _roleMeta = const VerificationMeta('role');
  GeneratedColumn<String> _role;
  @override
  GeneratedColumn<String> get role =>
      _role ??= GeneratedColumn<String>('role', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, age, role];
  @override
  String get aliasedName => _alias ?? 'persons_moor';
  @override
  String get actualTableName => 'persons_moor';
  @override
  VerificationContext validateIntegrity(Insertable<PersonsMoorData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age'], _ageMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role'], _roleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonsMoorData map(Map<String, dynamic> data, {String tablePrefix}) {
    return PersonsMoorData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PersonsMoorTable createAlias(String alias) {
    return $PersonsMoorTable(_db, alias);
  }
}

abstract class _$AppMoorDatabase extends GeneratedDatabase {
  _$AppMoorDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PersonsMoorTable _personsMoor;
  $PersonsMoorTable get personsMoor => _personsMoor ??= $PersonsMoorTable(this);
  PersonDaoMoor _personDaoMoor;
  PersonDaoMoor get personDaoMoor =>
      _personDaoMoor ??= PersonDaoMoor(this as AppMoorDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [personsMoor];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PersonDaoMoorMixin on DatabaseAccessor<AppMoorDatabase> {
  $PersonsMoorTable get personsMoor => attachedDatabase.personsMoor;
}
