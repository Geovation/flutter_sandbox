import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/objectbox.g.dart';

import 'person_model.dart';

class PersonDaoObjectboxDB extends ChangeNotifier {
  final Store _store;
  Box<PersonObjectbox> _box;
  Stream<Query<PersonObjectbox>> _queryStream;
  List<PersonObjectbox> _persons = [];

  PersonDaoObjectboxDB(Directory dir)
      : _store = Store(
          getObjectBoxModel(),
          directory: dir.path + '/objectbox', // replace with a real name
        ) {
    _box = Box<PersonObjectbox>(_store);
    final qBuilder = _box.query()
      ..order(PersonObjectbox_.name, flags: Order.descending);
    _queryStream = qBuilder.watch(triggerImmediately: true);
  }

  void insert(PersonObjectbox person) async {
    _box.put(person);
    await getAll();
  }

  void update(PersonObjectbox person) async {
    _box.put(person);
    await getAll();
  }

  void delete(PersonObjectbox person) async {
    _box.remove(person.id);
    await getAll();
  }

  Future<List<PersonObjectbox>> getAll() async {
    // final queryText = _box.query(PersonObjectbox_.name.notNull()).build();
    List<PersonObjectbox> persons = _box.getAll(); //queryText.find();
    _persons = persons;
    // queryText.close();
    return persons;
  }

  int get getPersonsCount {
    return _box.count();
  }

  List<PersonObjectbox> get getPersonsList {
    return _persons;
  }
}
