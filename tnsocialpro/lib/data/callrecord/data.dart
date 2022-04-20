import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class CallRecordParent {
  int code;
  String msg;
  List<CallRecordData> data;
  bool success;

  CallRecordParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory CallRecordParent.fromJson(Map<String, dynamic> json) =>
      _$CallRecordParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$CallRecordParentToJson(this);
}

@JsonSerializable()
class CallRecordData {
  int id;
  int user_id;
  String userpic;
  String username;
  int anthorid;
  String anthorname;
  String anthorpic;
  int calltype;
  String calllength;
  String create_time;
  String end_time;

  CallRecordData({
    this.id,
    this.user_id,
    this.userpic,
    this.username,
    this.anthorid,
    this.anthorname,
    this.anthorpic,
    this.calltype,
    this.calllength,
    this.create_time,
    this.end_time
  });

  //反序列化
  factory CallRecordData.fromJson(Map<String, dynamic> json) =>
      _$CallRecordDataFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$CallRecordDataToJson(this);
}
