class TalkItem {
  final int? id;
  final String time;
  final String name;
  final String content;

  TalkItem({
    this.id,
    required this.time,
    required this.name,
    required this.content,
});

  TalkItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        time = map['time'] as String,
        name = map['name'] as String,
        content = map['content'] as String;


}