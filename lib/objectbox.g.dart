// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'database/objectbox/person_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(2, 1128630120072881664),
      name: 'PersonObjectbox',
      lastPropertyId: const IdUid(4, 9151239928270815849),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8903350627764079989),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4149893758428304879),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6319083223720844777),
            name: 'age',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 9151239928270815849),
            name: 'role',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 1128630120072881664),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [1373926479736956706],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        1541073422493386781,
        1359810892247412487,
        8919986360250797556,
        4853616470799157678
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    PersonObjectbox: EntityDefinition<PersonObjectbox>(
        model: _entities[0],
        toOneRelations: (PersonObjectbox object) => [],
        toManyRelations: (PersonObjectbox object) => {},
        getId: (PersonObjectbox object) => object.id,
        setId: (PersonObjectbox object, int id) {
          object.id = id;
        },
        objectToFB: (PersonObjectbox object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name);
          final roleOffset =
              object.role == null ? null : fbb.writeString(object.role);
          fbb.startTable(5);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.age);
          fbb.addOffset(3, roleOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PersonObjectbox(
              id: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 4),
              name: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              age: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              role: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [PersonObjectbox] entity fields to define ObjectBox queries.
class PersonObjectbox_ {
  /// see [PersonObjectbox.id]
  static final id =
      QueryIntegerProperty<PersonObjectbox>(_entities[0].properties[0]);

  /// see [PersonObjectbox.name]
  static final name =
      QueryStringProperty<PersonObjectbox>(_entities[0].properties[1]);

  /// see [PersonObjectbox.age]
  static final age =
      QueryIntegerProperty<PersonObjectbox>(_entities[0].properties[2]);

  /// see [PersonObjectbox.role]
  static final role =
      QueryStringProperty<PersonObjectbox>(_entities[0].properties[3]);
}
