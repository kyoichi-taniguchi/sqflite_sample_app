import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


final _textController = TextEditingController();

final _fileName = 'editTextField.txt';

class FileApp extends StatefulWidget {
  const FileApp({Key? key}) : super(key: key);

  @override
  _FileAppState createState() => _FileAppState();
}

class _FileAppState extends State<FileApp> {

  String _out = '';

  // ファイルの出力処理
  void outButton() async {
    getFilePath().then((File file) {
      file.writeAsString(_textController.text);
    });
  }

  // ファイルの読み込み
  void loadButton() async {
    setState(() {
      load().then((String value) {
        setState(() {
          _out = value;
        });
      });
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('file入出力'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('テキストを入力してください'),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: true,
                controller: _textController,
                decoration: InputDecoration(
                    icon: Icon(Icons.arrow_forward)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('ファイルに出力する'),
                onPressed: outButton,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('出力したファイルを読み込む'),
                onPressed: loadButton,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('出力したファイルのない内容は $_out です'),
            ),
          ],
        ),
    );
  }
}

// テキストファイルの保存先パス
Future<File> getFilePath() async {
  final directory = await getTemporaryDirectory();
  return File(directory.path + '/' + _fileName);
}

Future<String> load() async {
  final file = await getFilePath();
  return file.readAsString();
}