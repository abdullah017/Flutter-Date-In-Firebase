import 'package:hive_flutter/hive_flutter.dart';

dynamic localDB;

Future<void> registerlocalDbHive(String dbName) async {
  await Hive.initFlutter();
  localDB = await Hive.openBox(dbName);
}

hiveGet(String key) {
  return localDB.get(key);
}

hivePut(String key, dynamic value) {
  localDB.put(key, value);
}

hiveDelete(String? key) {
  localDB.delete(key);
}
