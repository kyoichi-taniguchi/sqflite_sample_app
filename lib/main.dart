import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_analytics_app/fileController.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:english_words/english_words.dart';

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

  final AsyncMemoizer _memoizer = AsyncMemoizer();

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
  }

  // retrieves rows
  Future<void> _getTodoItems() async {
    // from json to List
    final List<Map<String, dynamic>> jsons =
    await this._db.rawQuery('SELECT * FROM $kDbTableName');
    print('${jsons.length} rows retrieves from db!');
    this._todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }

  // insert records to the db table.
  Future<void> _addTodoItem(TodoItem todo) async {
    await this._db.transaction(
        (Transaction txn) async {
          final int id = await txn.rawInsert('''
            INSERT INTO $kDbTableName
              (content, isDone, createdAt)
            VALUES
              (
                "${todo.content}",
                ${todo.isDone ? 1 : 0},
                ${todo.createdAt.millisecondsSinceEpoch}
              )''');
          print('Inserted todo into item with id=$id.');
        }
    );
  }


  // Update records from the table
  Future<void> _toggleTodoItem(TodoItem todo) async {
    final count = await this._db.rawUpdate(
      '''
        UPDATE $kDbTableName
        SET isDone = ?
        WHERE id = ?
        ''',
      [if (todo.isDone ) 0 else
        1, todo.id],
    );
    print('Updated $count records in db.');
  }

  // Delete records in the table
  Future<void> _deleteTodoItem(TodoItem todo) async {
    final count = await this._db.rawDelete('''
        DELETE FROM $kDbTableName
        WHERE id = ${todo.id}
        ''');
    print('Deleted $count records in db');
  }

  // async db
  Future<bool> _asyncInit() async {
    await _memoizer.runOnce(() async {
      await _initDb();
      await _getTodoItems();
    });
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('todo sample'),
            ),
            body: ListView(
              children: this._todos.map(_itemToListTile).toList(),
            ),
            floatingActionButton: _buildFloatingActionButton(),
          ),
        );
      }
    );
  }

  Future<void> _updateUI() async {
    await _getTodoItems();
    setState(() {});
  }

  ListTile _itemToListTile(TodoItem todo) => ListTile(
    title: Text(
      todo.content,
      style: TextStyle(
        fontStyle: todo.isDone ? FontStyle.italic : null,
        color: todo.isDone ? Colors.grey : null,
        decoration: todo.isDone ? TextDecoration.lineThrough : null),
    ),
    subtitle: Text('id=${todo.id}\ncreated at ${todo.createdAt}'),
    isThreeLine: true,
    leading: IconButton(
      icon: Icon(
        todo.isDone ? Icons.check_box : Icons.check_box_outline_blank),
      onPressed: () async {
        await _toggleTodoItem(todo);
        _updateUI();
      },
    ),
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        await _deleteTodoItem(todo);
        _updateUI();
      },
    ),
  );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
        onPressed: () async {
          await _addTodoItem(
            TodoItem(content: generateWordPairs().first.asPascalCase,
                createdAt: DateTime.now(),
            ),
          );
          _updateUI();
        },
      child: const Icon(Icons.add),
    );
  }



}
