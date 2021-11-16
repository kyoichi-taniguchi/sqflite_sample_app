import 'package:flutter/material.dart';
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
      title: widget.title,
      home: FilePickerDemo(),
    );
  }
}
