part of 'data.dart';

WithdrawlistParent _$WithdrawlistParentFromJson(Map<String, dynamic> json) {
  return WithdrawlistParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Withdrawlist.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      success: json['success'] as bool,
  );
}

Map<String, dynamic> _$WithdrawlistParentToJson(WithdrawlistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Withdrawlist _$WithdrawlistFromJson(Map<String, dynamic> json) {
  return Withdrawlist(
    id: json['id'] as int,
    withdrawmon: json['withdrawmon'] as String,
    applystatus: json['applystatus'] as int,
    create_time: json['create_time'] as String,
  );
}

Map<String, dynamic> _$WithdrawlistToJson(Withdrawlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'withdrawmon': instance.withdrawmon,
      'applystatus': instance.applystatus,
      'create_time': instance.create_time,
    };
