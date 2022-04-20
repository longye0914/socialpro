import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class AlarmParent {
  String alert;
  String title;
  Map extras;

  AlarmParent({
    this.alert,
    this.title,
    this.extras,
  });

  //反序列化
  factory AlarmParent.fromJson(Map<String, dynamic> json) =>
      _$AlarmParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$AlarmParentToJson(this);
}

@JsonSerializable()
class AlarmInfo {
  int id;
  String content;
  String create_time;
  String alarm_type;
  int type;
  int j_type;

  AlarmInfo({
    this.id,
    this.content,
    this.create_time,
    this.alarm_type,
    this.type,
    this.j_type,
  });

  //反序列化
  factory AlarmInfo.fromJson(Map<String, dynamic> json) =>
      _$AlarmInfoFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$AlarmInfoToJson(this);
}
