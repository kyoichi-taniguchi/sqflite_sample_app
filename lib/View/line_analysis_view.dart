import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:line_analytics_app/Model/create_talk_list.dart';
import 'package:line_analytics_app/Model/line_analysis.dart';
import 'package:line_analytics_app/Model/talk_class.dart';
import 'package:line_analytics_app/Model/talks_db_controller.dart';

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

  int page = 0;
  TalksDb db = TalksDb();



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
        actions: <Widget>[
          IconButton(
              onPressed: () {
                page = 1;
                db.checkDb();
                },
              icon: Icon(Icons.analytics)),
          IconButton(onPressed: () {page = 0;}, icon: Icon(Icons.list)),
        ],
      ),
      body: Center(
        child: page == 0 ? talkListBuilder(talkList) : Text(printNumberOfTalks(talkList!))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: loadButton,
      ),
    );
  }

  Widget talkListBuilder(List<Talk>? talkList) {
    if (talkList == null) {
      return const Text('please tap');
    } else {
      return ListView.builder(
          itemCount: talkList.length,
          itemBuilder: (BuildContext context, int index) {
            return Text('${talkList[index].time} : ${talkList[index].name} : ${talkList[index].content}');
          }
      );
    }
  }

  String printNumberOfTalks (List<Talk> talkList) {
    //db.checkDb();
    List<NumberOfTalks> numbers = searchName(talkList);
    String n = '';
    for (var i in numbers) {
      n = '$n${i.name} : ${i.n}件\n';
    }
    return n;
  }

  void loadButton() {
    setState(() {
      talkList = createTalkList(_data);
      searchName(talkList!);
      db.createTable(talkList!);
    });
  }

}

