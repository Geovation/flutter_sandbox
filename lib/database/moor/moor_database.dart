import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class PersonsMoor extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get age => integer().withDefault(Constant(0))();
  TextColumn get role => text().nullable()();
}

@UseMoor(tables: [PersonsMoor], daos: [PersonDaoMoor])
// _$AppDatabase is the name of the generated class
class AppMoorDatabase extends _$AppMoorDatabase {
  AppMoorDatabase()
      // Specify the location of the database file
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'moordb.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;
}

// Denote which tables this DAO can access
@UseDao(tables: [PersonsMoor])
class PersonDaoMoor extends DatabaseAccessor<AppMoorDatabase>
    with _$PersonDaoMoorMixin {
  final AppMoorDatabase db;

  // Called by the AppDatabase class
  PersonDaoMoor(this.db) : super(db);

  Future<List<PersonsMoorData>> getAllPersons() => select(personsMoor).get();
  Stream<List<PersonsMoorData>> watchAllPersons() =>
      select(personsMoor).watch();
  Future insertPerson(Insertable<PersonsMoorData> person) =>
      into(personsMoor).insert(person);
  Future updatePerson(Insertable<PersonsMoorData> person) =>
      update(personsMoor).replace(person);
  Future deletePerson(Insertable<PersonsMoorData> person) =>
      delete(personsMoor).delete(person);
}
