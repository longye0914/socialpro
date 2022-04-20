part of 'data.dart';

BannerlistParent _$BannerlistParentFromJson(Map<String, dynamic> json) {
  return BannerlistParent(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Bannerlist.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      success: json['success'] as bool,
  );
}

Map<String, dynamic> _$BannerlistParentToJson(BannerlistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Bannerlist _$BannerlistFromJson(Map<String, dynamic> json) {
  return Bannerlist(
    id: json['id'] as int,
    src: json['src'] as String,
    isjump: json['isjump'] as String,
    url: json['url'] as String,
    type: json['type'] as int
  );
}

Map<String, dynamic> _$BannerlistToJson(Bannerlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'src': instance.src,
      'isjump': instance.isjump,
      'url': instance.url,
      'type': instance.type
    };
