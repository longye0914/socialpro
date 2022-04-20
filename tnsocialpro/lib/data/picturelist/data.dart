import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class PicturelistParent {
  int code;
  String msg;
  List<Picturelist> data;
  bool success;

  PicturelistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory PicturelistParent.fromJson(Map<String, dynamic> json) =>
      _$PicturelistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PicturelistParentToJson(this);
}

@JsonSerializable()
class Picturelist {
  int id;
  int user_id;
  String url;

  Picturelist(
      {this.id, this.user_id, this.url});

  //反序列化
  factory Picturelist.fromJson(Map<String, dynamic> json) =>
      _$PicturelistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PicturelistToJson(this);
}
