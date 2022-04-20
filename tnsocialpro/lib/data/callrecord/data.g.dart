part of 'data.dart';

CallRecordParent _$CallRecordParentFromJson(Map<String, dynamic> json) {
  return CallRecordParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : CallRecordData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      success: json['success'] as bool,
  );
}

Map<String, dynamic> _$CallRecordParentToJson(CallRecordParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

CallRecordData _$CallRecordDataFromJson(Map<String, dynamic> json) {
  return CallRecordData(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      userpic: json['userpic'] as String,
      username: json['username'] as String,
      anthorid: json['anthorid'] as int,
      anthorname: json['anthorname'] as String,
      anthorpic: json['anthorpic'] as String,
      calltype: json['calltype'] as int,
      calllength: json['calllength'] as String,
      create_time: json['create_time'] as String,
      end_time: json['end_time'] as String
  );
}

Map<String, dynamic> _$CallRecordDataToJson(CallRecordData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'userpic': instance.userpic,
      'username': instance.username,
      'anthorid': instance.anthorid,
      'anthorname': instance.anthorname,
      'anthorpic': instance.anthorpic,
      'calltype': instance.calltype,
      'calllength': instance.calllength,
      'create_time': instance.create_time,
      'end_time': instance.end_time
    };
