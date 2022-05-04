import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/constants.dart';

class ReqBusiness {
  Dio _dio;

  ReqBusiness(this._dio);

  /// 获取登陆者信息
  Future<Response> getUserInfoReq({
    @required String tk,
  }) {
    print("获取登陆者信息");
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getInfo?',
    );
  }

  /// 通过手机号获取信息
  Future<Response> getUserInfoByphone({
    @required String tk,
    @required String phone
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _userinfoDio = Dio(_baseOptions);
    return _userinfoDio.get(
      Constants.requestUrl + 'user/getUserInfoByphone?', queryParameters: {"phone": phone}
    );
  }

  /// 获取用户详情
  Future<Response> getUserDetailReq({
    @required String tk,
    @required int id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getUserDetail?', queryParameters: {'id': id}
    );
  }

  /// 更新甜甜券余额
  Future<Response> uploadTianticket({
    @required String tk,
    @required int tianticket,
    @required int type,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _updatetianDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap({
      "tianticket": tianticket,
      "type": type
    });
    return _updatetianDio.post(Constants.requestUrl + 'user/uploadTianticket?',
        data: formdata);
  }

  /// IM扣/收费操作
  Future<Response> incomeHandle({
    @required String tk,
    @required int user_id,
    @required String username,
    @required int anthorid,
    @required String anthorname,
    @required String incomemon,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _updatetianDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap({
      "user_id": user_id,
      "username": username,
      "anthorid": anthorid,
      "anthorname": anthorname,
      "incomemon": incomemon,
    });
    return _updatetianDio.post(Constants.requestUrl + 'call/incomeHandle?',
        data: formdata);
  }

  /// 更新提现余额
  Future<Response> uploadWithdrawData({
    @required String tk,
    @required int tianticket,
    @required String tianmon
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _updatetianDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap({
      "tianticket": tianticket,
      "tianmon": tianmon
    });
    return _updatetianDio.post(Constants.requestUrl + 'user/uploadWithdrawData?',
        data: formdata);
  }

  /// 女 获取在线用户
  Future<Response> getOnlineUserReq({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getOnlinelist',
    );
  }

  /// 女 获取最近来访
  Future<Response> getVisitUserReq({
    @required String tk,
    @required int follow_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getVisitlist?', queryParameters: {"follow_id": follow_id}
    );
  }

  // 女 最近来访
  Future<Response> visitUserReq({
    @required String tk,
    @required int user_id,
    @required int follow_id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "user_id": user_id,
      "follow_id": follow_id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/visitUser?',
        data: formData);
  }

  /// 女 获取喜欢我的
  Future<Response> getFanslistReq({
    @required String tk,
    @required int follow_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getFanslist?', queryParameters: {"follow_id": follow_id}
    );
  }

  /// 男 获取所有女用户列表
  Future<Response> getAllUserlistReq({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
      Constants.requestUrl + 'user/getAllUserlist',
    );
  }

  /// 男 获取喜欢我的
  Future<Response> getMyLikelistReq({
    @required String tk,
    @required int user_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getLikeMelist?', queryParameters: {"user_id": user_id}
    );
  }

  /// 女 获取我的图片列表
  Future<Response> getUserPictureReq({
    @required String tk,
    @required int user_id
  }) {
    print("获取我的图片列表");
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getUserPicture?', queryParameters: {"user_id": user_id}
    );
  }

  // 上传图片
  Future<Response> updateUserpicReq({
    @required String tk,
    @required String url,
    @required int user_id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "url": url,
      "user_id": user_id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/addUserPicture?',
        data: formData);
  }

  // 删除图片
  Future<Response> deletePictureReq({
    @required String tk,
    @required int id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "id": id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/deleteUserPicture?',
        data: formData);
  }

  /// 获取 留声机数据
  Future<Response> getUserRandomVoice({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getUserRandomVoice?'
    );
  }

  /// 女 获取音频列表
  Future<Response> getUserVoiceReq({
    @required String tk,
    @required int user_id
  }) {
    print("获取音频列表");
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getUserVoice?', queryParameters: {"user_id": user_id}
    );
  }

  /// 主播/机器人 获取通话记录列表
  Future<Response> getAnthorCalllistReq({
    @required String tk,
    @required int anthorid
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'call/anthorCalllist?', queryParameters: {"anthorid": anthorid}
    );
  }

  /// 用户 获取通话记录列表
  Future<Response> getUserCalllistReq({
    @required String tk,
    @required int user_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'call/userCalllist?', queryParameters: {"user_id": user_id}
    );
  }

  // 删除通话记录
  Future<Response> deleteCallrecordReq({
    @required String tk,
    @required int id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "id": id
    });
    return _editInfoDio.post(Constants.requestUrl + 'call/deleteCalllist?',
        data: formData);
  }

  // 上传音频
  Future<Response> updateUservoiceReq({
    @required String tk,
    @required String url,
    @required int user_id,
    @required int voicetime,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "url": url,
      "user_id": user_id,
      "voicetime": voicetime
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/addUserVoice?',
        data: formData);
  }

  // 删除音频
  Future<Response> deleteVoiceReq({
    @required String tk,
    @required int id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "id": id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/deleteUserVoice?',
        data: formData);
  }

  // 喜欢用户
  Future<Response> followUserReq({
    @required String tk,
    @required int follow_id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "follow_id": follow_id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/followUser?',
        data: formData);
  }

  // 取消喜欢用户
  Future<Response> cancelfollowUserReq({
    @required String tk,
    @required int follow_id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "follow_id": follow_id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/cancelfollowUser?',
        data: formData);
  }

  /// 获取是否对当前用户喜欢
  Future<Response> getFollowUserStateReq({
    @required String tk,
    @required int follow_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _articlelistDio = Dio(_baseOptions);
    return _articlelistDio.get(Constants.requestUrl + 'user/getFollowUserState?', queryParameters: {
      "follow_id": follow_id,
    });
  }

  // 设置展示/取消展示
  Future<Response> handleVoiceReq({
    @required String tk,
    @required int id,
    @required int showflag,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "id": id,
      "showflag": showflag,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/handleVoiceShow?',
        data: formData);
  }

  /// 获取banner list
  Future<Response> getBannerlistReq({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _articlelistDio = Dio(_baseOptions);
    return _articlelistDio.get(Constants.requestUrl + 'banner/getBannerlist?', queryParameters: {
      "type": 1,
    });
  }

  /// 语音/视频呼入
  Future<Response> callReq({
    @required String tk,
    @required int type,
    @required int utype,
    @required int uid,
    @required int
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _callReqDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({"type": type, "utype": utype, "uid": uid});
    return _callReqDio.post(Constants.requestUrl + 'call/callRequest?',
        data: formData);
  }

  /// 通话接听/挂断接口
  Future<Response> answerReq({
    @required String tk,
    @required int type,
    @required int time,
    @required String channel,
    @required int chat_type,
    @required int uid
  }) {
    BaseOptions _answerReqOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _answerReqDio = Dio(_answerReqOptions);
    FormData formData = FormData.fromMap({
      "type": type,
      "time": time,
      "channel": channel,
      "chat_type": chat_type,
      "uid": uid
    });
    return _answerReqDio.post(Constants.requestUrl + 'call/callHandle?',
        data: formData);
  }

  // 提交推送设备信息
  Future<Response> submitDeviceInfoReq({
    @required String tk,
    @required String register_id,
    @required String type,
    @required String device_id,
    @required int user_id
    // @required String remark,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _submitDeviDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "register_id": register_id,
      "type": type,
      "device_id": device_id,
      "user_id": user_id,
    });
    return _submitDeviDio.post(Constants.requestUrl + 'user/registerPushUser?',
        data: formData);
  }

  /// 退出 状态
  Future<Response> modifyLogoutState({
    @required String tk,
    @required int statusval
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    FormData formdata = FormData.fromMap({
      "statusval": statusval,
    });
    Dio _logOutDio = Dio(_baseOptions);
    return _logOutDio.post(Constants.requestUrl + 'user/modifyLogoutState?', data: formdata);
  }

  /// 退出登陆
  Future<Response> logOut({
    @required String tk,
    @required String phone
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    // FormData formdata = FormData.fromMap({
    //   "phone": phone,
    // });
    Dio _logOutDio = Dio(_baseOptions);
    return _logOutDio.post(Constants.requestUrl + 'logout?');
  }

  /// 获取隐私服务服务协议
  Future<Response> getArgreementReq({
    @required int type,
  }) {
    return _dio.get('agreement?', queryParameters: {"type": type});
  }

  // 完善登陆信息
  Future<Response> editLoginInfoeq({
    @required String tk,
    @required String username,
    @required String birthday,
    @required String bodylength,
    @required String age,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "username": username,
      "birthday": birthday,
      "bodylength": bodylength,
      "age": age
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editLogininfo?',
        data: formData);
  }

  // 编辑个人身高
  Future<Response> editBodylengReq({
    @required String tk,
    @required String bodylength,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "bodylength": bodylength,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editBodylength?',
        data: formData);
  }

  // 编辑个人名字
  Future<Response> editNameReq({
    @required String tk,
    @required String username,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "username": username,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserName?',
        data: formData);
  }

  // 编辑个人性别
  Future<Response> editGenderReq({
    @required String tk,
    @required int gender,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "gender": gender,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserGender?',
        data: formData);
  }

  // 编辑个人生日
  Future<Response> editBirthReq({
    @required String tk,
    @required String birthday,
    @required String age
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "birthday": birthday,
      "age": age
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserBirth?',
        data: formData);
  }

  // 编辑个人地址
  Future<Response> editPathReq({
    @required String tk,
    @required String path,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "path": path,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserPath?',
        data: formData);
  }

  // 更新用户状态
  Future<Response> updateUserBackorFont({
    @required String tk,
    @required int id,
    @required String type,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "id": id,
      "type": type,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateUserBackorFont?',
        data: formData);
  }

  // 发送消息通知
  Future<Response> chatPushMessage({
    @required String tk,
    @required int user_id,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "user_id": user_id,
    });
    return _editInfoDio.post(Constants.requestUrl + 'call/chatPushMessage?',
        data: formData);
  }


  // 编辑个人签名
  Future<Response> editSinginfoReq({
    @required String tk,
    @required String signinfo,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "signinfo": signinfo,
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserSigninfo?',
        data: formData);
  }

  // 编辑个人头像
  Future<Response> editHeadimgReq({
    @required String tk,
    @required String userpic
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "userpic": userpic
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/uploadAvatar?',
        data: formData);
  }

  // 编辑个人介绍
  Future<Response> editInfoReq({
    @required String tk,
    @required String myselfintro
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "myselfintro": myselfintro
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/editUserInfo?',
        data: formData);
  }

  // 资料全部更新状态
  Future<Response> updateInfoReq({
    @required String tk,
    @required int infoflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "infoflag": infoflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateInfoAll?',
        data: formData);
  }

  // 我的图片状态
  Future<Response> updatePicTaskReq({
    @required String tk,
    @required int picflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "picflag": picflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updatePictureTask?',
        data: formData);
  }

  // 我的声音录入状态
  Future<Response> updateVoiceTaskReq({
    @required String tk,
    @required int voiceflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "voiceflag": voiceflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateVoiceTask?',
        data: formData);
  }

  // 接单状态
  Future<Response> updateOrderTaskReq({
    @required String tk,
    @required int taskflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "taskflag": taskflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateOrderTask?',
        data: formData);
  }

  // 视频接单设置
  Future<Response> videoSetReq({
    @required String tk,
    @required String videoset,
    @required int videosetflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "videoset": videoset,
      "videosetflag": videosetflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateVideoSet?',
        data: formData);
  }

  // 音频接单设置
  Future<Response> voiceSetReq({
    @required String tk,
    @required String voiceset,
    @required int voicesetflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "voiceset": voiceset,
      "voicesetflag": voicesetflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updateVoiceSet?',
        data: formData);
  }

  // 私聊接单设置
  Future<Response> priimSetReq({
    @required String tk,
    @required String priimset,
    @required int priimsetflag
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "priimset": priimset,
      "priimsetflag": priimsetflag
    });
    return _editInfoDio.post(Constants.requestUrl + 'user/updatePriSet?',
        data: formData);
  }

  // 创建支付订单
  Future<Response> createOderReq({
    @required String tk,
    @required String commodity,
    @required String amount,
    @required int userId,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "userId": userId,
      "commodity": commodity,
      "amount": amount,
    });
    return _editInfoDio.post(Constants.requestUrl + 'pay/createOrder?',
        data: formData);
  }

  // 更新支付订单
  Future<Response> updateOrderReq({
    @required String tk,
    @required int orderno,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "orderno": orderno,
    });
    return _editInfoDio.post(Constants.requestUrl + 'pay/updateOrder?',
        data: formData);
  }

  // 创建提现订单
  Future<Response> createWithdraworderReq({
    @required String tk,
    @required String commodity,
    @required String amount,
    @required int userId,
    @required String name,
    @required String zfbName
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "userId": userId,
      "commodity": commodity,
      "amount": amount,
      "name": name,
      "zfbName": zfbName
    });
    return _editInfoDio.post(Constants.requestUrl + 'pay/createWithdrawOrder?',
        data: formData);
  }

  // 获取支付宝签名
  Future<Response> goAlipay({
    @required String tk,
    @required int orderno,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "orderno": orderno,
    });
    return _editInfoDio.post(Constants.requestUrl + 'pay/goAlipay?',
        data: formData);
  }

  // 微信充值支付
  Future<Response> wxRecharge({
    @required String tk,
    @required int orderno,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "orderno": orderno,
    });
    return _editInfoDio.post(Constants.requestUrl + 'wxpay/wxRecharge?',
        data: formData);
  }

  /**
   * 支付宝提现
   */
  Future<Response> goAliWithdraw({
    @required String tk,
    @required int orderno,
    @required String amount,
    @required int userid,
    @required String name,
    @required String zfbName,
    // @required String operator
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "orderno": orderno,
      "amount": amount,
      "userid": userid,
      "name": name,
      "zfbName": zfbName,
      // "operator": operator
    });
    return _editInfoDio.post(Constants.requestUrl + 'pay/alipayWithdraw?',
        data: formData);
  }

  /**
   * 微信提现
   */
  Future<Response> wechatWithdraw({
    @required String tk,
    @required String partnerTradeNo,
    @required String openid,
    @required String desc,
    @required String amount,
    @required int userid,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _editInfoDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "partnerTradeNo": partnerTradeNo,
      "openid": openid,
      "userid": userid,
      "desc": desc,
      "amount": amount,
    });
    return _editInfoDio.post(Constants.requestUrl + 'wxpay/wechatWithdraw?',
        data: formData);
  }

  /// 女 提现明细列表
  Future<Response> getWithdrawlistReq({
    @required String tk,
    @required int userid
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'pay/getWithdrawlist?', queryParameters: {"userid": userid}
    );
  }

  /// 女 收入明细列表
  Future<Response> getIncomeItemlistReq({
    @required String tk,
    @required int anthorid
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'pay/getIncomeItemlist?', queryParameters: {"anthorid": anthorid}
    );
  }

  /// 男 充值明细列表
  Future<Response> getRechargeDetail({
    @required String tk,
    @required int userid
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'pay/getRechargeDetail?', queryParameters: {"userid": userid}
    );
  }

  /// 女 支出明细列表
  Future<Response> getPayoutItemlist({
    @required String tk,
    @required int user_id
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'pay/getPayoutItemlist?', queryParameters: {"user_id": user_id}
    );
  }

  /// 声音模版
  Future<Response> getVoicetemplelist({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getVoicetemplelist?'
    );
  }

  /// 签名模版
  Future<Response> getSigntemplelist({
    @required String tk,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _calendarDio = Dio(_baseOptions);
    return _calendarDio.get(
        Constants.requestUrl + 'user/getSigntemplelist?'
    );
  }
}
