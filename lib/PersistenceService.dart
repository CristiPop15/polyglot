import 'package:sqflite/sqflite.dart';

import 'IconsCollection.dart';

class PersistenceService {

  static final PersistenceService instance = PersistenceService._init();

  static Database? _database;

  var tableFavorite = "favorites";
  var tableCollection = "collections";
  var tableCollectionName = "collectionNames";

  var key = "key";
  var name = "name";
  var nameId = "nameId";

  PersistenceService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('polyglot.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    // print(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableFavorite (
        id $idType,
        $key $textType
        )
      ''');

    await db.execute('''
      CREATE TABLE $tableCollectionName (
        id $idType,
        $name $textType
        )
      ''');

    await db.execute('''
      CREATE TABLE $tableCollection (
        id $idType,
        $nameId INTEGER NOT NULL,
        $key $textType,
        FOREIGN KEY ($nameId) REFERENCES $tableCollectionName (id) ON DELETE CASCADE
        )
      ''');
  }

  void clearAll() async {
    final db = await instance.database;
    db.delete(tableFavorite);
    db.delete(tableCollection);
    db.delete(tableCollectionName);
  }

  Future<int> insertFavorites(String favoriteKey) async {
    final db = await instance.database;

    final id = await db.insert(tableFavorite, {key : favoriteKey});
    return id;
  }

  Future<void> deleteFavorites(String keyToDelete) async {
    final db = await instance.database;
    await db.delete(tableFavorite, where: '${key} = ?', whereArgs: [keyToDelete]);
  }

  Future<List<String>> readAllFavorites() async {
    final db = await instance.database;

    final result =
        await db.rawQuery('SELECT $key FROM $tableFavorite');

    return result.map((e) => e.values.toString()).toList();
  }

  Future<int> insertCollection(IconsCollection newCollection) async {
    final db = await instance.database;

    final id = await db.insert(tableCollectionName, {name : newCollection.name});

    newCollection.collections.keys.forEach((element) async {
      await db.insert(tableCollection, {nameId: id, key: element.key});
    });

    return id;
  }

  Future<List<IconsCollection>> readAllCollections() async {
    final db = await instance.database;

    List<IconsCollection> collections= [];

    await db.rawQuery("PRAGMA foreign_keys = ON");

    final nameResult = await db.rawQuery('SELECT * FROM $tableCollectionName');

    for(var iterator = 0; iterator < nameResult.length; iterator++) {
      Map collectionName = nameResult.elementAt(iterator);
      final result = await db.query(tableCollection, columns: [key],
          where: '$nameId = ?', whereArgs: [collectionName['id']]);

      IconsCollection collection = new IconsCollection(
          collectionName["id"] as int, collectionName[name] as String);

      for(var id = 0; id < result.length; id++) {
        Map collectionIcons = result.elementAt(id);
        collection.addFromKey(collectionIcons[key].toString());
      }

      collections.add(collection);
    }

    return collections;
  }

  Future<void> updateCollection(IconsCollection updateCollection) async {
    final db = await instance.database;

    await db.update(tableCollectionName, {name : updateCollection.name}, where: 'id = ?', whereArgs: [updateCollection.id]);

    await db.delete(tableCollection, where: '$nameId = ?', whereArgs: [updateCollection.id]);

    updateCollection.collections.keys.forEach((element) async {
      await db.insert(tableCollection, {nameId: updateCollection.id, key: element});
    });
  }

  Future<void> deleteCollection(int id) async {
    final db = await instance.database;

    await db.rawQuery("PRAGMA foreign_keys = ON");

    await db.delete(tableCollection, where: '$nameId = ?', whereArgs: [id]);
    await db.delete(tableCollectionName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> readColl() async {
    final db = await instance.database;

    await db.rawQuery("PRAGMA foreign_keys = ON");

    final result = await db.rawQuery('SELECT * FROM $tableCollectionName');

    print("collection name");
    print(result);

    final result1 = await db.rawQuery('SELECT * FROM $tableCollection');
    print(result1);

  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}