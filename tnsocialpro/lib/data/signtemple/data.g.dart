
part of 'data.dart';

SignTempleParent _$SignTempleParentFromJson(Map<String, dynamic> json) {
  return SignTempleParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
          ? null
          : SignTemple.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SignTempleParentToJson(SignTempleParent instance) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'data': instance.data,
};

SignTemple _$SignTempleFromJson(Map<String, dynamic> json) {
  return SignTemple(
      id: json['id'] as int,
      signinfo: json['signinfo'] as String,
      typeid: json['typeid'] as int,
      typename: json['typename'] as String,
      create_time: json['create_time'] as String,
      isChoose: json['isChoose'] as bool
  );
}

Map<String, dynamic> _$SignTempleToJson(SignTemple instance) => <String, dynamic>{
      'id': instance.id,
      'signinfo': instance.signinfo,
      'typeid': instance.typeid,
      'typename': instance.typename,
      'create_time': instance.create_time,
      'isChoose': instance.isChoose
    };
