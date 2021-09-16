import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'moor_database.g.dart';

class PersonsMoor extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get age => integer().withDefault(Constant(0))();
  TextColumn get role => text().nullable()();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moordb.sqlite'));
    return VmDatabase(
      file,
      logStatements: true,
    );
  });
}

@UseMoor(tables: [PersonsMoor], daos: [PersonDaoMoor])
// _$AppDatabase is the name of the generated class
class AppMoorDatabase extends _$AppMoorDatabase {
  bool isInDebugMode = true;

  // we tell the database where to store the data with this constructor
  AppMoorDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
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
