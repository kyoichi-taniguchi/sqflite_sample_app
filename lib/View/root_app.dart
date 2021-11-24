import 'package:flutter/material.dart';
import 'package:line_analytics_app/Model/io/share_extention.dart';
import 'package:line_analytics_app/View/line_analysis_view.dart';
import 'package:line_analytics_app/View/read_file_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      // delete "DEBUG" belt
      debugShowCheckedModeBanner: false,

      title: widget.title,
      theme: ThemeData.light(), // ライト用テーマ
      darkTheme: ThemeData.dark(), // ダーク用テーマ
      themeMode: ThemeMode.system, // システムの設定でテーマを自動変更
      home: LineAnalysisView(),
    );
  }
}
