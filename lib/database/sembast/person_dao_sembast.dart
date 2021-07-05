import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_sandbox/database/sembast/model/person_sembast.dart';
import 'package:flutter_sandbox/database/sembast/sembast_database.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

PersonSembast snapshotToPerson(RecordSnapshot snapshot) {
  return PersonSembast.fromMap(snapshot.value as Map, id: snapshot.key as int);
}

class DbPersonsSembast extends ListBase<PersonSembast> {
  List<RecordSnapshot<int, Map<String, Object>>> list;
  List<PersonSembast> _cacheNotes;

  DbPersonsSembast(this.list) {
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  PersonSembast operator [](int index) {
    return _cacheNotes[index] ??= snapshotToPerson(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, PersonSembast value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class PersonDaoSembast extends ChangeNotifier {
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

  var personsTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object>>>,
      List<PersonSembast>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbPersonsSembast(snapshotList));
  });

  Stream<List<PersonSembast>> watch() async* {
    yield* _personStore
        .query(finder: Finder(sortOrders: [SortOrder('name')]))
        .onSnapshots(await _db)
        .transform(personsTransformer)
        .asBroadcastStream();
  }

  int get getPersonsCount {
    return _persons.length;
  }

  List<PersonSembast> get getPersonsList {
    return _persons;
  }
}
