part of 'data.dart';

PaylistParent _$PaylistParentFromJson(Map<String, dynamic> json) {
  return PaylistParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Paylist.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      success: json['success'] as bool,
  );
}

Map<String, dynamic> _$PaylistParentToJson(PaylistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Paylist _$PaylistFromJson(Map<String, dynamic> json) {
  return Paylist(
    id: json['id'] as int,
    amount: json['amount'] as String,
    states: json['states'] as int,
    paymenttime: json['paymenttime'] as String,
  );
}

Map<String, dynamic> _$PaylistToJson(Paylist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'states': instance.states,
      'paymenttime': instance.paymenttime,
    };
