import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/constants.dart';

/// 用户管理相关
class ReqUser {
  final Dio _dio;

  ReqUser(this._dio);

  /// 验证码登录
  Future<Response> loginCodeReq({
    /// 手机号
    @required String phone,

    /// 密码
    @required String smsCode,
  }) {
    FormData formData = FormData.fromMap({
      "phone": phone,
      "smsCode": smsCode
    });
    return _dio.post('loginOrReg?', data: formData);
  }

  /// 用户是否注册
  Future<Response> isRegisterUser({
    @required String phone,
  }) {
    return _dio.get('isRegisterUser?', queryParameters: {
      "phone": phone,
    });
  }

  /// 获取验证码
  Future<Response> getCodeReq({
    @required String phone,
  }) {
    FormData formData = FormData.fromMap({
      "phone": phone,
    });
    print(_dio.options);
    return _dio.post(
      'sendSmsCode?',
      data: formData,
    );
  }
  /// 校验验证码
  Future<Response> validateCodeReq({
    @required String phone,
    @required String smsCode
  }) {
    FormData formData = FormData.fromMap({
      "phone": phone,
      "smsCode": smsCode
    });
    return _dio.post(
      'sendSmsCodeNum?',
      data: formData,
    );
  }

  // 校验原手机号
  Future<Response> submitBeforePhone({
    @required String tk,
    @required String phone,
    @required String code,
    @required int type,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _submitPhoneDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "phone": phone,
      "code": code,
      "type": type,
    });
    return _submitPhoneDio.post(Constants.requestUrl + 'check_code?',
        data: formData);
  }

  /// 获取隐私政策
  Future<Response> getSecretinfoReq({
    // 协议类型，1隐私协议，2服务协议
    @required int type,
  }) {
    return _dio.post('agreement?', queryParameters: {
      "type": type,
    });
  }

  /// 找回密码
  Future<Response> findPswReq({
    @required String phone,
    @required String code,
    @required String password,
  }) {
    FormData formData = FormData.fromMap({
      "phone": phone,
      "password": password,
      "code": code,
    });
    return _dio.post('find_password?', data: formData);
  }

  /// 注册
  Future<Response> regiserReq({
    @required String phone,
    @required String code,
    @required String pwd,
  }) {
    FormData formData = FormData.fromMap({
      "phone": phone,
      "pwd": pwd,
      "code": code,
    });
    return _dio.post('register?', data: formData);
  }

  /// 修改密码
  Future<Response> modifyPswReq({
    @required String tk,
    @required String old_password,
    @required String password,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _modifyPwdDio = Dio(_baseOptions);
    FormData formData = FormData.fromMap({
      "old_password": old_password,
      "password": password,
    });
    return _modifyPwdDio.post(Constants.requestUrl + 'edit_password?',
        data: formData);
  }

  /// 意见反馈
  Future<Response> feedBackReq({
    @required String tk,
    @required String content,
    @required String callinfo
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _feedBackDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap({
      "data": content,
      "callinfo": callinfo
    });
    return _feedBackDio.post(Constants.requestUrl + 'user/feedBack?',
        data: formdata);
  }

  /// 版本升级
  Future<Response> getVersionReq({
    @required String curversion,
    // 1安卓， 2 IOS， 3 ipad
    @required int plattype,
//    @required String channel,
  }) {
    return _dio.get('?', queryParameters: {
      "c": "version",
      "curversion": curversion,
      "plattype": plattype,
    });
  }

  /// 修改会员信息
  Future<Response> modifyUserinfoReq({
    @required String tk,
    @required String head_img,
  }) {
    return _dio.post('?', queryParameters: {
      "c": 'edit_info',
      "tk": tk,
      "head_img": head_img,
    });
  }

  /// 版本更新
  Future<Response> upgradeVersioninfoReq({
    @required String tk,
    // @required String curversion,
    // 1安卓， 2 IOS， 3 ipad
    @required int type,
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': tk,
    });
    Dio _versioniDio = Dio(_baseOptions);
    return _versioniDio
        .get(Constants.requestUrl + 'version?', queryParameters: {
      // "curversion": curversion,
      "type": type,
    });
  }

  /// 短信token
  Future<Response> getMsgtokenReq() {
    BaseOptions _options = new BaseOptions(
      baseUrl: 'http://a1.easemob.com',
        connectTimeout: 5000,
        receiveTimeout: 3000,
      // followRedirects:false,
      // validateStatus: (status) { return status < 500; },
        headers: {
          HttpHeaders.acceptHeader: "accept: application/json",
        },
      // headers: {
      //   // 'Accept':'application/json, text/plain, */*',
      //   // 'Authorization':"**",
      //   // 'User-Aagent':"4.1.0;android;6.0.1;default;A001",
      //   // "HZUID":"2",
      //   'Content-Type':'application/json',
      // }
    );
    ///创建Map 封装参数
    Map<String, dynamic> map = Map();
    map['grant_type']="client_credentials";
    map['client_id']="YXA6WP4LFIeUTQ-xUH_Lo7QQLA";
    map['client_secret']="YXA6qrXyU0Y0jd-Zes-M9WcYz9k-7g8";
    return Dio(_options).post('', data: map);
  }

  /// 发送短信验证码
  Future<Response> sendMsgCode({
    @required String tk,
    @required String phone,
    @required String tmapv
  }) {
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': 'Bearer ' + tk,
      'Content-Type': 'application/json',
    });
    Dio _sendMsgDio = Dio(_baseOptions);
    // FormData formdata = FormData.fromMap({
    //   "mobiles": [phone],
    //   "tid": "734",
    //   "tmap": {"p1": tmapv}
    // });
    Map<String, dynamic> map = Map();
    map['mobiles']= [phone];
    map['tid']="734";
    map['tmap']={"p1": tmapv};
    print(map);
    return _sendMsgDio.post('',
        data: map);
  }
}
