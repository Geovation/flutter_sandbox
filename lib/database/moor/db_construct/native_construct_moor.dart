import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;

LazyDatabase constructDb({bool logStatements = false}) {
  final executor = LazyDatabase(() async {
    final dataDir = await paths.getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dataDir.path, 'moordb.sqlite'));
    return VmDatabase(dbFile, logStatements: logStatements);
  });
  return executor;
}
