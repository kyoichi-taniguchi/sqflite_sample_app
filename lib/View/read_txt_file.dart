import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:line_analytics_app/Model/create_talk_list.dart';
import 'package:line_analytics_app/Model/line_analysis.dart';
import 'package:line_analytics_app/Model/talk_class.dart';

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

  String fileName1 = 'assets/line_data.txt';
  String fileName2 = 'assets/[LINE] しのちゃんとのトーク.txt';



  @override
  Widget build(BuildContext context) {



    getFileData(fileName1).then((value) {
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
            itemCount: talkList!.length,
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
      talkList = createTalkList(_data);
      searchName(talkList!);
    });
  }

}
