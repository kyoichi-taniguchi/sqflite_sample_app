

import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/change_date_time_type.dart';
import 'package:line_analytics_app/Model/talk_class.dart';


class NumberOfTalks {
  DateTime date;
  String name;
  int n;

  NumberOfTalks(
      this.date,
      this.name,
      this.n
      );
}

List<NumberOfTalks> searchName(List<Talk> talkList) {
  List<NumberOfTalks> numbers = [];
  List<String> lNumbers = [];
  int c = 0;
  for ( var i=0; c < 2; i++) {
    if (lNumbers.contains(talkList[i].name) == false) {
      NumberOfTalks number = NumberOfTalks(DateTime(2020) ,talkList[i].name, 0);
      numbers.add(number);
      lNumbers.add(talkList[i].name);
      c++;
    }
  }

  for (var m in talkList) {
    if (m.name == numbers[0].name) {
      numbers[0].n ++;
    } else{
      numbers[1].n++;
    }
  }

  return numbers;
}

List<NumberOfTalks> countNumberOfTalks(List<tTalk> ttalkList) {
  List<NumberOfTalks> talkN = [];
  List<String> talkDate = [];

  for (int i=0; i < ttalkList.length; i++) {
    int n = talkDate.indexOf(DateFormat('yyyy-MM').format(ttalkList[i].time));
    if (n < 0 ) {
      talkN.add(NumberOfTalks(ttalkList[i].time, ttalkList[i].name, 1));
      talkDate.add(DateFormat('yyyy-MM').format(ttalkList[i].time));
    } else {
      talkN[n].n++;
    }
  }

  for (var m in talkN) {
    print('${m.date.year}/${m.date.month} : ${m.n}');
  }

  return talkN;
}





// pref
// http://hono-wp.seesaa.net/article/451497045.html


