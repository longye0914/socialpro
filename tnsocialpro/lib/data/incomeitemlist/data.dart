import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class IncomeitemlistParent {
  int code;
  String msg;
  List<Incomeitemlist> data;
  bool success;

  IncomeitemlistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory IncomeitemlistParent.fromJson(Map<String, dynamic> json) =>
      _$IncomeitemlistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$IncomeitemlistParentToJson(this);
}

@JsonSerializable()
class Incomeitemlist {
  int id;
  int user_id;
  String username;
  int anthorid;
  String anthorname;
  String incomemon;
  int itemtype;
  String create_time;

  Incomeitemlist({
    this.id,
    this.user_id,
    this.username,
    this.anthorid,
    this.anthorname,
    this.incomemon,
    this.itemtype,
    this.create_time
  });

  //反序列化
  factory Incomeitemlist.fromJson(Map<String, dynamic> json) =>
      _$IncomeitemlistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$IncomeitemlistToJson(this);
}