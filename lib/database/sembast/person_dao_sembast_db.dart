import 'package:flutter/foundation.dart';
import 'package:flutter_sandbox/database/sembast/model/person.dart';
import 'package:flutter_sandbox/database/sembast/sembast_database.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class PersonDaoSembastDB extends ChangeNotifier {
  static const String PERSON_STORE_NAME = 'persons';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Person objects converted to Map
  final _personStore = intMapStoreFactory.store(PERSON_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.

  Future<Database> get _db async => (!kIsWeb)
      ? await SembastDatabase.instance.database
      : await databaseFactoryWeb.openDatabase('sembastWeb');

  List<PersonSembast> _persons = [];

  Future insert(PersonSembast person) async {
    await _personStore.add(await _db, person.toMap());
    await getAllSortedByName();
  }

  Future update(PersonSembast person) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(person.id));
    await _personStore.update(
      await _db,
      person.toMap(),
      finder: finder,
    );
    await getAllSortedByName();
  }

  Future delete(PersonSembast person) async {
    final finder = Finder(filter: Filter.byKey(person.id));
    await _personStore.delete(
      await _db,
      finder: finder,
    );
    await getAllSortedByName();
  }

  Future<List<PersonSembast>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _personStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Person> out of List<RecordSnapshot>
    List<PersonSembast> persons = recordSnapshots.map((snapshot) {
      final person = PersonSembast.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      person.id = snapshot.key;
      return person;
    }).toList();

    _persons = persons;
    notifyListeners();
    return persons;
  }

  int get getPersonsCount {
    return _persons.length;
  }

  List<PersonSembast> get getPersonsList {
    return _persons;
  }
}
