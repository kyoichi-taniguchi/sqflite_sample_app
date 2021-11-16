import 'package:line_analytics_app/Model/line_analysis.dart';
import 'package:line_analytics_app/Model/talk_class.dart';

List<Talk> createTalkList(String strData) {
  // 返すリスト
  List<Talk> talkList = [];

  print('okey');

  // 加工中のリスト（データの行数が文字列と等しい）
  List<Talk> notFormatTalkList = [];

  // 文字列を改行文字で分割
  List<String> strTalkList = strData.split('\n');
  for (int row=0; row < strTalkList.length; row++ ) {
    // 文字列をタブ文字で分割
    List<String> talkRow = strTalkList[row].split('\t');

    // データを３個に揃える
    if (talkRow.length == 1) {
      talkRow.add('add');
      talkRow.add('add');
    }
    else if (talkRow.length == 2) {
      talkRow.add('add');
    } else if (talkRow.isEmpty) {
      talkRow = ['add', 'add', 'add'];
    }

    // Talk型に変換
    Talk tmpTalk = Talk(talkRow[0], talkRow[1], talkRow[2]);
    notFormatTalkList.add(tmpTalk);

  }
  talkList = formatTalkList(notFormatTalkList);

  return talkList;
}

List<Talk> formatTalkList(List<Talk> data) {
  List<Talk> formattedTalkList = [];

  // 日付が書いてある行番号
  int dateN = 0;
  for (int i=0; i < data.length; i++) {
    Talk row = data[i];

    // 日時を抽出
    RegExp dateExp = RegExp(r'^[0-9]{4}/[0-9]{2}/[0-9]{2}');
    Iterable<Match> dateMatches = dateExp.allMatches(row.time);
    for (Match m in dateMatches) {
      dateN = i;
    }

    // LINE１件を抽出して日時を追加
    RegExp exp = RegExp(r'^[0-9]{2}:[0-9]{2}');
    Iterable<Match> matches = exp.allMatches(row.time);
    for (Match m in matches) {
      row.time = data[dateN].time + row.time;
      //formattedTalkList.add(row);
    }

    // 改行されたトークを検索
    // リストの長さが3ではないまたは日時ではない場合
    if (row.name == 'add' || row.content == 'add' || i == dateN) {
          // 次が日時付きだったら、前のcontentに追加
      } else {
      //print(data[i].content);
      formattedTalkList.add(row);
    }



  }





  return formattedTalkList;
}