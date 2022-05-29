part of 'data.dart';

IncomeitemlistParent _$IncomeitemlistParentFromJson(Map<String, dynamic> json) {
  return IncomeitemlistParent(
    code: json['code'] as int,
    msg: json['msg'] as String,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : Incomeitemlist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$IncomeitemlistParentToJson(
        IncomeitemlistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Incomeitemlist _$IncomeitemlistFromJson(Map<String, dynamic> json) {
  return Incomeitemlist(
    id: json['id'] as int,
    user_id: json['user_id'] as int,
    username: json['username'] as String,
    anthorid: json['anthorid'] as int,
    anthorname: json['anthorname'] as String,
    incomemon: json['incomemon'] as String,
    itemtype: json['itemtype'] as int,
    create_time: json['create_time'] as String,
    anchorIncomemon: json['anchorIncomemon'] as String,
  );
}

Map<String, dynamic> _$IncomeitemlistToJson(Incomeitemlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'username': instance.username,
      'anthorid': instance.anthorid,
      'anthorname': instance.anthorname,
      'incomemon': instance.incomemon,
      'itemtype': instance.itemtype,
      'create_time': instance.create_time,
    };
