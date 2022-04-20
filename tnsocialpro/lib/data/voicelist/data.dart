import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class VoicelistParent {
  int code;
  String msg;
  List<Voicelist> data;
  bool success;

  VoicelistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory VoicelistParent.fromJson(Map<String, dynamic> json) =>
      _$VoicelistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$VoicelistParentToJson(this);
}

@JsonSerializable()
class Voicelist {
  int id;
  int user_id;
  String url;
  int voicetime;
  int showflag;
  int isPlay;
  ShopUser shopUser;
  List<Piclist> userPics;
  int isFollow;

  Voicelist(
      {this.id, this.user_id, this.url, this.voicetime, this.showflag, this.isPlay, this.shopUser, this.userPics, this.isFollow});

  //反序列化
  factory Voicelist.fromJson(Map<String, dynamic> json) =>
      _$VoicelistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$VoicelistToJson(this);
}

@JsonSerializable()
class ShopUser {
  int id;
  String phone;
  String userpic;
  String username;
  int gender;
  String email;
  String age;
  String path;
  String birthday;
  String signinfo;
  String bgpic;
  String bodylength;
  int tianticket;
  String myselfintro;
  String tianmon;
  int infoflag;
  int picflag;
  int voiceflag;
  int taskflag;
  String videoset;
  int videosetflag;
  String voiceset;
  int voicesetflag;
  String priimset;
  int priimsetflag;
  int status;

  ShopUser(
      {this.id, this.phone, this.userpic, this.username, this.gender, this.email, this.age, this.path, this.birthday,
        this.signinfo, this.bgpic, this.bodylength, this.tianticket, this.myselfintro, this.tianmon, this.infoflag,
        this.picflag, this.voiceflag, this.taskflag, this.videoset, this.videosetflag, this.voiceset, this.voicesetflag,
        this.priimset, this.priimsetflag, this.status});

  //反序列化
  factory ShopUser.fromJson(Map<String, dynamic> json) =>
      _$ShopUserFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ShopUserToJson(this);
}

@JsonSerializable()
class Piclist {
  int id;
  int user_id;
  String url;

  Piclist(
      {this.id, this.user_id, this.url});

  //反序列化
  factory Piclist.fromJson(Map<String, dynamic> json) =>
      _$PiclistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PiclistToJson(this);
}

