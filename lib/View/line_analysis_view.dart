import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/line_analysis/change_date_time_type.dart';
import 'package:line_analytics_app/Model/line_analysis/create_talk_list.dart';
import 'package:line_analytics_app/Model/line_analysis/line_analysis.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';
import 'package:line_analytics_app/Model/database/talks_db_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}


class LineAnalysisView extends StatefulWidget {
  const LineAnalysisView({Key? key}) : super(key: key);

  @override
  _LineAnalysisViewState createState() => _LineAnalysisViewState();
}

class _LineAnalysisViewState extends State<LineAnalysisView> {

  List<Talk>?  talkList;
  List<tTalk>? ttalkList;
  List<NumberOfTalks> talkN = [];


  String _data = '';

  String fileName1 = 'assets/line_data.txt';
  String fileName2 = 'assets/[LINE] しのちゃんとのトーク.txt';

  bool isDone = false;


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
        title: Text('LINE解析アプリ'),
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
        child: isDone ? Icon(Icons.done) : Icon(Icons.play_arrow),
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
    String n = '';


    for (var m in talkN) {
      n = n + '\n${m.date.year}年${m.date.month}月 \n'
          '${m.name1} : ${m.n1}件, ${m.name2} : ${m.n2}件';
    }


    return Text(n);
  }


  void loadButton() {

    if (!isDone) {
      talkList = createTalkList(_data);
      //db.createTable(talkList!);

      ttalkList = changeListType(talkList!);
      talkN = countNumberOfTalks(ttalkList!);
      isDone = true;
    }
  }

}

