

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/io/raed_assets_file.dart';
import 'package:line_analytics_app/Model/line_analysis/change_date_time_type.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';
import 'package:line_analytics_app/View/line_analysis_view.dart';


class NumberOfTalks {
  DateTime date;
  String name1;
  int n1;
  String name2;
  int n2;

  NumberOfTalks(
      this.date,
      this.name1,
      this.n1,
      this.name2,
      this.n2,
      );
}
String searchFriendName(String data) {
  List<String> dataList = data.split('\n');
  String nameData = dataList[0].split(' ')[1];
  int needless = nameData.length - 'とのトーク履歴'.length -1;
  String friendName = nameData.substring(0, needless);

  return friendName;
}

Future<List<String>> searchName(List<tTalk> ttalkList) async {
  List<String> nameList = [];
  String _data = '';
  _data = await FileController().readFile();
  nameList.add(searchFriendName(_data));
  int c = 0;
  for ( var i=0; c < 1; i++) {
    if (nameList[0] != ttalkList[i].name) {
      nameList.add(ttalkList[i].name);
      c++;
    }
  }
  print(nameList);


  return nameList;
}



Future<List<NumberOfTalks>> countNumberOfTalks(List<tTalk> ttalkList) async {
  List<NumberOfTalks> talkN = [];
  List<String> talkDate = [];
  List<String> nameList = await searchName(ttalkList);

  for (int i=0; i < ttalkList.length; i++) {
    int n = talkDate.indexOf(DateFormat('yyyy-MM').format(ttalkList[i].time));
    if (n < 0 ) {
      // リスト2つを追加
      if (ttalkList[i].name == nameList[0] ){
        talkN.add(NumberOfTalks(ttalkList[i].time, nameList[0], 1, nameList[1], 0));
      } else {
        talkN.add(NumberOfTalks(ttalkList[i].time, nameList[1], 1, nameList[0], 0));
      }
      // 日付を登録
      talkDate.add(DateFormat('yyyy-MM').format(ttalkList[i].time));

    } else {
      if (ttalkList[i].name == talkN[n].name1) {
        talkN[n].n1++;
      } else {
        talkN[n].n2++;
      }

    }
  }

  for (var m in talkN) {
    if (m.name1 == nameList[1]) {
      String tmpName1 = '';
      int tmpN1 = 0;
      tmpName1 = m.name1;
      m.name1 = m.name2;
      m.name2 = tmpName1;

      tmpN1 = m.n1;
      m.n1 = m.n2;
      m.n2 = tmpN1;
    }
  }

  return talkN;
}

List<int> sumOfTalks(List<NumberOfTalks> talkN) {
  List<int> sum = [0, 0];
  for (var m in talkN) {
    sum[0] += m.n1;
    sum[1] += m.n2;
  }
  print(sum);
  return sum;
}

int countPeriod(List<tTalk> ttalkList) {
  DateTime startTime = ttalkList[0].time;
  DateTime endTime = ttalkList[ttalkList.length-1].time;

  final Duration difference = endTime.difference(startTime);


  return difference.inDays;
}

Future<List<int>> countNumberOfWords(List<tTalk> ttalkList) async {
  List<int> wordN = [0, 0];
  List<String> nameList = [];
  nameList = await searchName(ttalkList);
  for (var m in ttalkList) {
    if (m.name == nameList[0]) {
      wordN[0] += m.content.length;
    } else {
      wordN[1] += m.content.length;
    }
  }


  return wordN;
}