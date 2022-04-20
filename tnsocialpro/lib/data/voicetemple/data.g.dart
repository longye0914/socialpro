
part of 'data.dart';

VoiceTempleParent _$VoiceTempleParentFromJson(Map<String, dynamic> json) {
  return VoiceTempleParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
          ? null
          : VoiceTemple.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$VoiceTempleParentToJson(VoiceTempleParent instance) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'data': instance.data,
};

VoiceTemple _$VoiceTempleFromJson(Map<String, dynamic> json) {
  return VoiceTemple(
      id: json['id'] as int,
      voicetemple: json['voicetemple'] as String,
      create_time: json['create_time'] as String,
  );
}

Map<String, dynamic> _$VoiceTempleToJson(VoiceTemple instance) => <String, dynamic>{
      'id': instance.id,
      'voicetemple': instance.voicetemple,
      'create_time': instance.create_time,
    };
