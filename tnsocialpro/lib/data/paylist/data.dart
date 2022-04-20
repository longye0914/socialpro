import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class PaylistParent {
  int code;
  String msg;
  List<Paylist> data;
  bool success;

  PaylistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory PaylistParent.fromJson(Map<String, dynamic> json) =>
      _$PaylistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PaylistParentToJson(this);
}

@JsonSerializable()
class Paylist {
  int id;
  String amount;
  int states;
  String paymenttime;

  Paylist({
    this.id,
    this.amount,
    this.states,
    this.paymenttime
  });

  //反序列化
  factory Paylist.fromJson(Map<String, dynamic> json) =>
      _$PaylistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PaylistToJson(this);
}
