import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DataBase_internal {
  StoreRef? store;
  late String dbName;
  DataBase_internal(String dbName)  {
    this.dbName = dbName;
  }

  _getDb(String dbPath) async {
    print("Initializing db");
    var store = StoreRef.main();
    final appDocDir = await getApplicationDocumentsDirectory();
    Database db = await databaseFactoryIo
        .openDatabase(appDocDir.path + "/" + dbPath, version: 1);
    print("Successfully initialized db");
    return db;
  }

  Future<String> getData() async {
    // We use the database factory to open the database
    var category;
    Database db = await _getDb(this.dbName+'.db');
    var store = StoreRef.main();
    var vcat = await store.record(dbName).get(db);
    print("Got category");
    print(vcat);
    return vcat.toString();
  }

  Future<bool> storeData(var data) async {
    print("Storing offline");
    var db = _getDb(dbName+'.db');
    print("got db "+dbName);
    print(data);
    var store = StoreRef.main();
    var status = await store.record(dbName).put(db, data);
    print(status);
    print("db stored");
    return true;
  }

}