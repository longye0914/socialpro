
part of 'data.dart';

AlarmParent _$AlarmParentFromJson(Map<String, dynamic> json) {
  return AlarmParent(
      extras: json['extras'] as Map,
      alert: json['alert'] as String,
      title: json['title'] as String);
}

Map<String, dynamic> _$AlarmParentToJson(AlarmParent instance) => <String, dynamic>{
  'extras': instance.extras,
  'alert': instance.alert,
  'title': instance.title,
};

AlarmInfo _$AlarmInfoFromJson(Map<String, dynamic> json) {
  return AlarmInfo(
      id: json['id'] as int,
      content: json['content'] as String,
      create_time: json['create_time'] as String,
      alarm_type: json['alarm_type'] as String,
      type: json['type'] as int,
      j_type: json['j_type'] as int,
  );
}

Map<String, dynamic> _$AlarmInfoToJson(AlarmInfo instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'create_time': instance.create_time,
      'alarm_type': instance.alarm_type,
      'type': instance.type,
      'j_type': instance.j_type,
    };
