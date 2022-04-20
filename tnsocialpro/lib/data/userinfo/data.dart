import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class MyInfoParent {
  int code;
  String msg;
  MyInfoData data;
  bool success;

  MyInfoParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory MyInfoParent.fromJson(Map<String, dynamic> json) =>
      _$MyInfoParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$MyInfoParentToJson(this);
}

@JsonSerializable()
class MyInfoData {
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
  String type;
  int likedcount;

  MyInfoData(
      {this.id, this.phone, this.userpic, this.username, this.gender, this.email, this.age, this.path, this.birthday,
        this.signinfo, this.bgpic, this.bodylength, this.tianticket, this.myselfintro, this.tianmon, this.infoflag,
        this.picflag, this.voiceflag, this.taskflag, this.videoset, this.videosetflag, this.voiceset, this.voicesetflag,
        this.priimset, this.priimsetflag, this.type, this.likedcount});

  //反序列化
  factory MyInfoData.fromJson(Map<String, dynamic> json) =>
      _$MyInfoDataFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$MyInfoDataToJson(this);
}
