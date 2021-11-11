

import 'package:line_analytics_app/Model/talk_class.dart';


class NumberOfTalks {
  String name;
  int n;

  NumberOfTalks(
      this.name,
      this.n
      );
}

searchName(List<Talk> talkList) {
  List<NumberOfTalks> numbers = [];
  List<String> lNumbers = [];
  int c = 0;
  for ( var i=0; c < 2; i++) {
    if (lNumbers.contains(talkList[i].name) == false) {
      NumberOfTalks number = NumberOfTalks(talkList[i].name, 0);
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

  for (var i in numbers) {
    print('${i.name} : ${i.n}件');
  }

  return numbers;
}





// pref
// http://hono-wp.seesaa.net/article/451497045.html


