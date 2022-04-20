import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class SignTempleParent {
  int code;
  String msg;
  List<SignTemple> data;

  SignTempleParent({
    this.code,
    this.msg,
    this.data,
  });

  //反序列化
  factory SignTempleParent.fromJson(Map<String, dynamic> json) => _$SignTempleParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SignTempleParentToJson(this);
}

@JsonSerializable()
class SignTemple {
  int id;
  String signinfo;
  int typeid;
  String typename;
  String create_time;
  bool isChoose;

  SignTemple({
    this.id,
    this.signinfo,
    this.typeid,
    this.typename,
    this.create_time,
    this.isChoose
  });

  //反序列化
  factory SignTemple.fromJson(Map<String, dynamic> json) =>
      _$SignTempleFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SignTempleToJson(this);
}
