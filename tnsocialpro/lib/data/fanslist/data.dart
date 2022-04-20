import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class FanslistParent {
  int code;
  String msg;
  List<Fanslist> data;
  bool success;

  FanslistParent({
    this.code,
    this.msg,
    this.data,
    this.success
  });

  //反序列化
  factory FanslistParent.fromJson(Map<String, dynamic> json) =>
      _$FanslistParentFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$FanslistParentToJson(this);
}

@JsonSerializable()
class Fanslist {
  int id;
  int follow_id;
  int user_id;
  String username;
  String userpic;
  String create_time;
  ShopUser shopUser;

  Fanslist(
      {this.id, this.follow_id, this.user_id, this.username, this.userpic, this.create_time, this.shopUser});

  //反序列化
  factory Fanslist.fromJson(Map<String, dynamic> json) =>
      _$FanslistFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$FanslistToJson(this);
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
  String type;

  ShopUser(
      {this.id, this.phone, this.userpic, this.username, this.gender, this.email, this.age, this.path, this.birthday,
        this.signinfo, this.bgpic, this.bodylength, this.tianticket, this.myselfintro, this.tianmon, this.infoflag,
        this.picflag, this.voiceflag, this.taskflag, this.videoset, this.videosetflag, this.voiceset, this.voicesetflag,
        this.priimset, this.priimsetflag, this.type});

  //反序列化
  factory ShopUser.fromJson(Map<String, dynamic> json) =>
      _$ShopUserFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ShopUserToJson(this);
}
