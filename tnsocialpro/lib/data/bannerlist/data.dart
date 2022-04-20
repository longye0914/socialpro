import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class BannerlistParent {
  int code;
  String msg;
  List<Bannerlist> data;
  bool success;

  BannerlistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory BannerlistParent.fromJson(Map<String, dynamic> json) =>
      _$BannerlistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$BannerlistParentToJson(this);
}

@JsonSerializable()
class Bannerlist {
  int id;
  String src;
  String isjump;
  String url;
  int type;

  Bannerlist({
    this.id,
    this.src,
    this.isjump,
    this.url,
    this.type
  });

  //反序列化
  factory Bannerlist.fromJson(Map<String, dynamic> json) =>
      _$BannerlistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$BannerlistToJson(this);
}
