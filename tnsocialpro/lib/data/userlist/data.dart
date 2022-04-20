import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class UserlistParent {
  int code;
  String msg;
  List<MyUserData> data;
  bool success;

  UserlistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory UserlistParent.fromJson(Map<String, dynamic> json) =>
      _$UserlistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$UserlistParentToJson(this);
}

@JsonSerializable()
class MyUserData {
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

  MyUserData(
      {this.id, this.phone, this.userpic, this.username, this.gender, this.email,
        this.age, this.path, this.birthday, this.signinfo, this.bgpic, this.bodylength,
        this.tianticket, this.myselfintro, this.tianmon, this.infoflag, this.picflag, this.voiceflag, this.taskflag,
        this.videoset, this.videosetflag, this.voiceset, this.voicesetflag, this.priimset, this.priimsetflag, this.type});

  //反序列化
  factory MyUserData.fromJson(Map<String, dynamic> json) =>
      _$MyUserDataFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$MyUserDataToJson(this);
}
