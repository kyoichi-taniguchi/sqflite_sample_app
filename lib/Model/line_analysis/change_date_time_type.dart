import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';

class tTalk {
  final DateTime time;
  final String name;
  final String content;

  tTalk({
   required this.time,
    required this.name,
    required this.content,
  });


}

tTalk changeTime(Talk talk) {
  int yaer = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minuts = 0;
  List<String> tmpDateList = [];
  RegExp yExp = RegExp(r"[0-9]{4}");
  yExp.allMatches(talk.time).forEach((match) {
    //print(match.group(0));
  });
  RegExp mExp = RegExp(r"[0-9]{2}");
  mExp.allMatches(talk.time).forEach((match) {
    tmpDateList.add(match.group(0).toString());
  });
  yaer = int.parse('${tmpDateList[0]}${tmpDateList[1]}');
  month = int.parse(tmpDateList[2]);
  day = int.parse(tmpDateList[3]);
  hour = int.parse(tmpDateList[4]);
  minuts = int.parse(tmpDateList[5]);

  DateTime date = DateTime(yaer, month, day, hour, minuts);
  tTalk ttalk = tTalk(time: date, name: talk.name, content: talk.content);

  //print(DateFormat('yyyy年MM月dd日HH:mm').format(date));


  return ttalk;
}

Future<List<tTalk>> changeListType(List<Talk> talkList) async {
  List<tTalk> talks = [];

  for (var m in talkList) {
    talks.add(changeTime(m));
  }

  return talks;
}