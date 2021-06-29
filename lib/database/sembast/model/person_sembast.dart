import 'package:flutter/cupertino.dart';

class PersonSembast {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Person.
  int id;

  final String name;
  final int age;
  final String role;

  PersonSembast({
    this.id,
    @required this.name,
    @required this.age,
    @required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'role': role,
    };
  }

  static PersonSembast fromMap(Map<String, dynamic> map) {
    return PersonSembast(
      name: map['name'],
      age: map['age'],
      role: map['role'],
    );
  }
}
