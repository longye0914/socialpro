import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class VoiceTempleParent {
  int code;
  String msg;
  List<VoiceTemple> data;

  VoiceTempleParent({
    this.code,
    this.msg,
    this.data,
  });

  //反序列化
  factory VoiceTempleParent.fromJson(Map<String, dynamic> json) => _$VoiceTempleParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$VoiceTempleParentToJson(this);
}

@JsonSerializable()
class VoiceTemple {
  int id;
  String voicetemple;
  String create_time;

  VoiceTemple({
    this.id,
    this.voicetemple,
    this.create_time,
  });

  //反序列化
  factory VoiceTemple.fromJson(Map<String, dynamic> json) =>
      _$VoiceTempleFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$VoiceTempleToJson(this);
}
