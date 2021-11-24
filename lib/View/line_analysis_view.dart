import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_analytics_app/Model/io/raed_assets_file.dart';
import 'package:line_analytics_app/Model/line_analysis/change_date_time_type.dart';
import 'package:line_analytics_app/Model/line_analysis/create_talk_list.dart';
import 'package:line_analytics_app/Model/line_analysis/line_analysis.dart';
import 'package:line_analytics_app/Model/line_analysis/talk_class.dart';
import 'package:icofont_flutter/icofont_flutter.dart';





class LineAnalysisView extends StatefulWidget {
  const LineAnalysisView({Key? key}) : super(key: key);

  @override
  _LineAnalysisViewState createState() => _LineAnalysisViewState();
}

class _LineAnalysisViewState extends State<LineAnalysisView> {


  List<Talk>? _talkList;
  List<tTalk>? _ttalkList;
  List<NumberOfTalks> _talkN = [];
  List<int> _sumOfTalks = [0, 0];
  int _talkPeriod = 0;
  List<int> _wordN = [0, 0];


  late String _data;

  bool isDone = false;
  bool isLoading = false;


  int page = 1;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 185, 2, 0.7),
        title: const Text('LINE解析アプリ'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                if (_ttalkList != null) {
                  setState(() {
                    page = 1;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today)),
          IconButton(onPressed: () {
            setState(() {
              page = 0;
            });
          }, icon: const Icon(Icons.grid_on_rounded)),
        ],
      ),
      body: Center(
          child: switchWidget(page),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(25, 185, 2, 1),
        child: isDone ?
          const Icon(
              Icons.done,
          )
            : const Icon(Icons.add),
        onPressed: loadButton,
      ),
    );
  }

  Widget loadingView() {
    if (!isLoading) {
      return const Text('＋ボタンで解析したいトークを追加');
    } else {
      return const Text('解析中です\nしばらくお待ち下さい');
    }
  }


  Widget talkListBuilder(List<Talk>? talkList) {
    if (_ttalkList == null) {
      return loadingView();
    } else {
      return GridView.count(
          crossAxisCount: 2,
        children: [
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                      '合計トーク数',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  Text(
                      '友達 : ${_sumOfTalks[0]}件',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                      '自分 : ${_sumOfTalks[1]}件',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),
                  ),
                ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    '平均トーク数 / 日',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                Text(
                    '友達 : ${_sumOfTalks[0] * 10 ~/ _talkPeriod / 10}件',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                    '自分 : ${_sumOfTalks[1] * 10 ~/ _talkPeriod / 10}件',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    '合計文字数',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                Text(
                    '友達 : ${_wordN[0]}文字',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                    '自分 : ${_wordN[1]}文字',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    '平均文字数 / 日',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
                Text(
                    '友達 : ${_wordN[0] * 10 ~/ _talkPeriod / 10}文字',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                    '自分 : ${_wordN[1] * 10 ~/ _talkPeriod / 10}文字',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }


  Widget switchWidget(int page) {
    if (_talkList == null) {
      return loadingView();
    } else {
      if (page == 0) {
        return talkListBuilder(_talkList);
      } else if (page == 1) {
        return numberOfTalksListBuilder(_talkList!);
      }
      return const Text('no pages');
    }

  }

  Widget numberOfTalksListBuilder(List<Talk> talkList) {

      return ListView.builder(
        itemCount: _talkN.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateFormat('yyyy年MM月').format(_talkN[index].date),
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        const Icon(
                            IcoFontIcons.line,
                            color: Color.fromRGBO(25, 185, 2, 1),
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                        Text(
                          '${_talkN[index].name1} : ${_talkN[index].n1}件',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                        '${_talkN[index].name2} : ${_talkN[index].n2}件',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                        const Icon(
                            IcoFontIcons.line,
                            color: Color.fromRGBO(25, 185, 2, 1)
                        ),
                    ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        );

      return loadingView();
    }


    loadButton() async {
      List<Talk>? talkList;
      List<tTalk>? ttalkList;
      List<NumberOfTalks> talkN = [];
      List<int> sum = [0, 0];
      int talkPeriod = 0;
      List<int> wordN = [0, 0];
      String data = '';
      setState(() {
        isLoading = true;
      });

      if (!isDone) {
        data = await FileController().readFile();

        talkList = await createTalkList(data);
        //db.createTable(talkList!);

        ttalkList = await changeListType(talkList);
        talkN = await countNumberOfTalks(ttalkList);
        sum = sumOfTalks(talkN);
        talkPeriod = countPeriod(ttalkList);
        wordN = await countNumberOfWords(ttalkList);
        setState(() {
          _data = data;
          _talkList = talkList;
          _ttalkList = ttalkList;
          _talkN = talkN;
          _sumOfTalks = sum;
          _talkPeriod = talkPeriod;
          _wordN = wordN;
          isLoading = false;
          isDone = true;
        });
      }
    }

}