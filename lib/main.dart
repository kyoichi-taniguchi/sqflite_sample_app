import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// class for data of application
class TodoItem {
  final int? id;
  final String content;

  final bool isDone;

  final DateTime createdAt;
  // contractor
  TodoItem({
   this.id,
   required this.content,
   this.isDone = false,
    required this.createdAt,
  });

  TodoItem.fromJsonMap(Map<String, dynamic> map)
    : id = map['id'] as int,
      content = map['content'] as String,
      isDone = map['isDone'] == 1,
      createdAt =
          DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int);

}

main() {
  runApp(SqliteExample());
}

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key? key}) : super(key: key);

  @override
  _SqliteExampleState createState() => _SqliteExampleState();
}






class _SqliteExampleState extends State<SqliteExample> {

  // define file name
  static const kDbFileName = 'sqflite_ex.db';
  // define table name
  static const kDbTableName = 'example_tbl';

  late Database _db;
  List<TodoItem> _todos = [];

  // create db table
  Future<void> _initDb() async {
    // create folder
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }

    // DataBase Path
    final dbPath = join(dbFolder, kDbFileName);

    // open dataBase and create table (if not exist)
    this._db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $kDbTableName(
            id INTEGER PRIMARY KEY,
            isDone BIT NOT NULL,
            content TEXT,
            createdAt INT)
            ''');
        },
    );

    // retrieves rows
    Future<void> _getTodoItems() async {
      // from json to List
      final List<Map<String, dynamic>> jsons =
        await this._db.rawQuery('SELECT * FROM $kDbTableName');
      print('${jsons.length} rows retrieves from db!');
      this._todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
    }

  }






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('todo example'),
        ),
        body: ListView(
          children: this._todos.map(_itemToListTile).toList(),
        ),
      ),
    );
  }




  ListTile _itemToListTile(TodoItem todo) => ListTile(
    title: Text(todo.content),
  );







}
