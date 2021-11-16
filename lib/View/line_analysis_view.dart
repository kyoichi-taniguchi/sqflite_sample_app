import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/change_date_time_type.dart';
import 'package:line_analytics_app/Model/create_talk_list.dart';
import 'package:line_analytics_app/Model/line_analysis.dart';
import 'package:line_analytics_app/Model/talk_class.dart';
import 'package:line_analytics_app/Model/talks_db_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  List<tTalk>? ttalkList;
  List<NumberOfTalks> talkN = [];

  String _data = '';

  String fileName1 = 'assets/line_data.txt';
  String fileName2 = 'assets/[LINE] しのちゃんとのトーク.txt';

  int page = 0;
  TalksDb db = TalksDb();



  @override
  Widget build(BuildContext context) {



    getFileData(fileName2).then((value) {
      setState(() {
        _data = value;
      });
    });


    return Scaffold(
      appBar: AppBar(
        title: Text('txt file'),
        actions: <Widget>[
          IconButton(
              onPressed: () {page = 1;},
              icon: Icon(Icons.analytics)),
          IconButton(onPressed: () {page = 0;}, icon: Icon(Icons.list)),
        ],
      ),
      body: Center(
        child: switchWidget(page)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: loadButton,
      ),
    );
  }

  Widget talkListBuilder(List<Talk>? talkList) {
    if (ttalkList == null) {
      return const Text('please tap');
    } else {
      return ListView.builder(
          itemCount: ttalkList!.length,
          itemBuilder: (BuildContext context, int index) {
            return Text('${DateFormat('yyyy年MM月dd日HH:mm').format(ttalkList![index].time)} : '
                '${ttalkList![index].name} : ${ttalkList![index].content}');
          }
      );
    }
  }


  Widget switchWidget(int page) {

    if (page == 0) {
      return talkListBuilder(talkList);
    } else if (page == 1) {
      return printNumberOfTalks(talkList!);
    }
    return const Text('no pages');
  }

  Widget printNumberOfTalks (List<Talk> talkList) {
    //db.checkDb();
    List<NumberOfTalks> numbers = searchName(talkList);
    String n = '';
    for (var i in numbers) {
      n = '$n${i.name} : ${i.n}件\n';
    }

    for (var m in talkN) {
      n = n + '\n${m.date.year}/${m.date.month} : ${m.n}';
    }


    return Text(n);
  }


  void loadButton() {
    setState(() {
      talkList = createTalkList(_data);
      searchName(talkList!);
      //db.createTable(talkList!);

      ttalkList = changeListType(talkList!);
      talkN = countNumberOfTalks(ttalkList!);

    });
  }

}

