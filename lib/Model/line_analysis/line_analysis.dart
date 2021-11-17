

import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/line_analysis/change_date_time_type.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';


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


List<String> searchName(List<tTalk> ttalkList) {
  List<String> nameList = [];
  int c = 0;
  for ( var i=0; c < 2; i++) {
    if (nameList.contains(ttalkList[i].name) == false) {
      nameList.add(ttalkList[i].name);
      c++;
    }
  }


  return nameList;
}

List<NumberOfTalks> countNumberOfTalks(List<tTalk> ttalkList) {
  List<NumberOfTalks> talkN = [];
  List<String> talkDate = [];
  List<String> nameList = searchName(ttalkList);

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
    print('\n${m.date.year}年${m.date.month}月 \n'
      '${m.name1} : ${m.n1}件, ${m.name2} : ${m.n2}件');
  }
  return talkN;
}





// pref
// http://hono-wp.seesaa.net/article/451497045.html


