import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class RowData {
  int id;

  RowData(Map map);

  Map toMap();

  void fromMap(Map map);

  String getInfo();
}

class SqlModule {
  final Future<Database> _db;
  List<String> tablesName = <String>[];

  /// Constructor of SqlModule
  ///
  /// [dbName] is the database name
  SqlModule(String dbName) : this._db = _createDB(dbName);

  /// Create database
  ///
  /// [dbName] is the database name
  static Future<Database> _createDB(
    String dbName,
  ) async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), dbName),
      // When the database is first created, create a table to store data.
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  /// Convenience method for create table in database
  ///
  /// [tablesInfo] is the information to create multiple table in the database
  /// [tablesInfo] = [{tableName1: columnInfo1}, ...]
  Future<void> createTable(
    List<Map<String, String>> tablesInfo,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same data is inserted
    // multiple times, it replaces the previous data.
    tablesInfo.forEach((table) {
      table.forEach((tableName, columnInfo) {
        db.execute(
          // Example of columnInfo: id INTEGER PRIMARY KEY, name TEXT, age INTEGER
          'CREATE TABLE $tableName($columnInfo)',
        );
      });
    });
  }

  /// Execute an SQL query with no return value
  Future<void> rawExecute(String sql, [List<dynamic> arguments]) async {
    // Get a reference to the database.
    final Database db = await this._db;

    db.execute(
      sql,
      arguments,
    );
  }

  /// Convenience method for query all data in the table of database
  ///
  /// [tableName] is the table name in the database
  Future<List<Map>> simpleQueryAll(
    String tableName,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Query the table for all The Dogs.
    return db.query(tableName);
  }

  /// Convenience method for insert row data in the table of database
  ///
  /// [tableName] is the table name in the database
  /// [rowData] is the row data in the table
  Future<void> simpleInsertRow(
    String tableName,
    Map rowData,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Insert the rowData into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same data is inserted
    // multiple times, it replaces the previous data.
    return db.insert(
      tableName,
      rowData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Convenience method for update row data in the table of database
  ///
  /// [tableName] is the table name in the database
  /// [rowId] is the row index in the table
  /// [rowData] is the row data in the table
  Future<int> simpleUpdateRow(
    String tableName,
    int rowId,
    Map rowData,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Update the given data.
    return db.update(
      tableName,
      rowData,
      // Ensure that the data has a matching id.
      where: 'id = ?',
      // Pass the rowId as a whereArg to prevent SQL injection.
      whereArgs: [rowId],
    );
  }

  /// Convenience method for delete row data in the table of database
  ///
  /// [tableName] is the table name in the database
  /// [rowId] is the row index in the table
  Future<int> simpleDeleteRow(
    String tableName,
    int rowId,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Remove the data from the database.
    return db.delete(
      tableName,
      // Use a `where` clause to delete a specific data.
      where: 'id = ?',
      // Pass the rowId as a whereArg to prevent SQL injection.
      whereArgs: [rowId],
    );
  }

  /// Convenience method for delete all data in the table of database
  ///
  /// [tableName] is the table name in the database
  Future<int> simpleDeleteAll(
    String tableName,
  ) async {
    // Get a reference to the database.
    final Database db = await this._db;

    // Remove the data from the database.
    return db.delete(tableName);
  }
}
