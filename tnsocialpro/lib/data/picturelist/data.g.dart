part of 'data.dart';

PicturelistParent _$PicturelistParentFromJson(Map<String, dynamic> json) {
  return PicturelistParent(
    code: json['code'] as int,
    msg: json['msg'] as String,
    data: (json['data'] as List)
        ?.map((e) =>
    e == null ? null : Picturelist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$PicturelistParentToJson(PicturelistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Picturelist _$PicturelistFromJson(Map<String, dynamic> json) {
  return Picturelist(
      id: json['id'] as int,
      user_id: json['phone'] as int,
      url: json['url'] as String,
  );
}

Map<String, dynamic> _$PicturelistToJson(Picturelist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'url': instance.url,
    };
