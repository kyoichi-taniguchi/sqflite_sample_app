import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';
import 'package:line_analytics_app/Model/database/talks_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class TalksDb {
  static const talksDbFileName = 'line_talks.db';
  static const talksDbTableName = 'line_talks_table';

  final AsyncMemoizer _memoizer = AsyncMemoizer();


  late Database _db;
  List<TalkItem> _talks = [];

  Future<void> _initDb() async {


    print('start initDb');
    final talksDbFolder = await getDatabasesPath();
    if (!await Directory(talksDbFolder).exists()) {
      await Directory(talksDbFolder).create(recursive: true);
    }

    final dbPath = join(talksDbFolder, talksDbFileName);
    print('combine path');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE $talksDbTableName("
            "id INTEGER PRIMARY KEY,"
            "time TEXT NOT NULL,"
            "name TEXT NOT NULL,"
            "content TEXT NOT NULL"
            ")"
        );
      },
    );
    print('db opened');
  }

  Future<void> _getTalkItems() async {
    // from json to List
    print('start get items');
    final List<Map<String, dynamic>> jsons =
    await this._db.rawQuery('SELECT * FROM $talksDbTableName');
    print('${jsons.length} rows retrieves from db!');
    this._talks = jsons.map((json) => TalkItem.fromJsonMap(json)).toList();
  }

  Future<void> _addTalksItem(TalkItem talkItem) async {
    await _db.transaction((Transaction txn) async {
      final int id = await txn.rawInsert('''
            INSERT INTO $talksDbTableName
              (time, name, content)
            VALUES
              (
                "${talkItem.time}",
                "${talkItem.name}",
                "${talkItem.content}"
              )''');
      print('Inserted todo into item with id=$id.');
    });
  }

  Future<bool> _asyncInit() async {
    await _memoizer.runOnce(() async {

      await _initDb();
      print('init okey');
      await _getTalkItems();
    });
    return true;
  }


  void createTable(List<Talk> talkList) {
    _initDb();


    for (int i = 0; i < talkList.length; i++) {
      TalkItem talk = TalkItem(
          time: talkList[i].time,
          name: talkList[i].name,
          content: talkList[i].content);
      print('item created');
      _addTalksItem(talk);
      print('add!');
    }





  }

  void checkDb() {
    print('start async init');

    _getTalkItems();
    for (int i=0; i < _talks.length; i++) {
      print(_talks[i].content);
    }

}

}

