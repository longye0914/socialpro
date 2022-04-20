import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class WithdrawlistParent {
  int code;
  String msg;
  List<Withdrawlist> data;
  bool success;

  WithdrawlistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory WithdrawlistParent.fromJson(Map<String, dynamic> json) =>
      _$WithdrawlistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$WithdrawlistParentToJson(this);
}

@JsonSerializable()
class Withdrawlist {
  int id;
  String withdrawmon;
  int applystatus;
  String create_time;

  Withdrawlist({
    this.id,
    this.withdrawmon,
    this.applystatus,
    this.create_time
  });

  //反序列化
  factory Withdrawlist.fromJson(Map<String, dynamic> json) =>
      _$WithdrawlistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$WithdrawlistToJson(this);
}
