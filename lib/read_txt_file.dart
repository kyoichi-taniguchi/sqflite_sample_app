import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:line_analytics_app/line_analysis.dart';

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}


class txtFileApp extends StatefulWidget {
  const txtFileApp({Key? key}) : super(key: key);

  @override
  _txtFileAppState createState() => _txtFileAppState();
}

class _txtFileAppState extends State<txtFileApp> {

  List<Talk>?  talkList;

  String _data = '';



  @override
  Widget build(BuildContext context) {

    getFileData('assets/line_data.txt').then((value) {
      setState(() {
        _data = value;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('txt file'),
      ),
      body: Center(
        child:
          talkList == null ? Text('please tap')
              : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child:
                    Text('${talkList![index].time} : ${talkList![index].name} : ${talkList![index].content}'),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: loadButton,
      ),
    );
  }

  void loadButton() {
    setState(() {
      talkList = lineAnalysis();
    });
  }
}
