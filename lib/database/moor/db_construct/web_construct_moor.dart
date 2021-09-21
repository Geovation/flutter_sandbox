import 'package:moor/backends.dart';
import 'package:moor/moor_web.dart';

QueryExecutor constructDb() {
  return WebDatabase('moor_db');
}
