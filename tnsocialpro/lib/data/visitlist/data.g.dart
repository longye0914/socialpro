part of 'data.dart';

VisitlistParent _$VisitlistParentFromJson(Map<String, dynamic> json) {
  return VisitlistParent(
    code: json['code'] as int,
    msg: json['msg'] as String,
    data: (json['data'] as List)
        ?.map((e) =>
    e == null ? null : Visitlist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$VisitlistParentToJson(VisitlistParent instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'success': instance.success
    };

Visitlist _$VisitlistFromJson(Map<String, dynamic> json) {
  return Visitlist(
    id: json['id'] as int,
    follow_id: json['follow_id'] as int,
    user_id: json['user_id'] as int,
    username: json['username'] as String,
    userpic: json['userpic'] as String,
    create_time: json['create_time'] as String,
    shopUser: json['shopUser'] == null
        ? null
        : ShopUser.fromJson(json['shopUser'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VisitlistToJson(Visitlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'follow_id': instance.follow_id,
      'user_id': instance.user_id,
      'username': instance.username,
      'userpic': instance.userpic,
      'create_time': instance.create_time,
      'shopUser': instance.shopUser
    };

ShopUser _$ShopUserFromJson(Map<String, dynamic> json) {
  return ShopUser(
      id: json['id'] as int,
      phone: json['phone'] as String,
      userpic: json['userpic'] as String,
      username: json['username'] as String,
      gender: json['gender'] as int,
      email: json['email'] as String,
      age: json['age'] as String,
      path: json['path'] as String,
      birthday: json['birthday'] as String,
      signinfo: json['signinfo'] as String,
      bgpic: json['bgpic'] as String,
      bodylength: json['bodylength'] as String,
      tianticket: json['tianticket'] as int,
      myselfintro: json['myselfintro'] as String,
      tianmon: json['tianmon'] as String,
      infoflag: json['infoflag'] as int,
      picflag: json['picflag'] as int,
      voiceflag: json['voiceflag'] as int,
      taskflag: json['taskflag'] as int,
      videoset: json['videoset'] as String,
      videosetflag: json['videosetflag'] as int,
      voiceset: json['voiceset'] as String,
      voicesetflag: json['voicesetflag'] as int,
      priimset: json['priimset'] as String,
      priimsetflag: json['priimsetflag'] as int,
      type: json['type'] as String
  );
}

Map<String, dynamic> _$ShopUserToJson(ShopUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'userpic': instance.userpic,
      'username': instance.username,
      'gender': instance.gender,
      'email': instance.email,
      'age': instance.age,
      'path': instance.path,
      'birthday': instance.birthday,
      'signinfo': instance.signinfo,
      'bgpic': instance.bgpic,
      'bodylength': instance.bodylength,
      'tianticket': instance.tianticket,
      'myselfintro': instance.myselfintro,
      'tianmon': instance.tianmon,
      'infoflag': instance.infoflag,
      'picflag': instance.picflag,
      'voiceflag': instance.voiceflag,
      'taskflag': instance.taskflag,
      'videoset': instance.videoset,
      'videosetflag': instance.videosetflag,
      'voiceset': instance.voiceset,
      'voicesetflag': instance.voicesetflag,
      'priimset': instance.priimset,
      'priimsetflag': instance.priimsetflag,
      'type': instance.type
    };