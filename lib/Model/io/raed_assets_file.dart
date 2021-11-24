import 'package:flutter/services.dart' show rootBundle;

class FileController {
  String _data = '';
  final String fileName1 = 'assets/line_data.txt';
  final String fileName2 = 'assets/[LINE] しのちゃんとのトーク.txt';

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }


  Future<String> readFile() async {
    await getFileData(fileName1).then((value) {
      _data = value;
    });
    return _data;
  }



}