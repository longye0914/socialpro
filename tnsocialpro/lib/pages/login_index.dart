import 'dart:async';
import 'dart:math';

import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/pages/policy_detail.dart';
import 'package:tnsocialpro/pages/tab_navigate.dart';
import 'package:tnsocialpro/utils/global.dart';

import 'genderinfo_page.dart';

class LoginIndex extends StatefulWidget {
  LoginIndex({Key key}) : super(key: key);

  _LoginIndexState createState() => _LoginIndexState();
}

class _LoginIndexState extends State<LoginIndex>
    with SingleTickerProviderStateMixin {
  // TextEditingController _userEtControllerPwdPhone = TextEditingController();
  // TextEditingController _userEtControllerPwd = TextEditingController();
  TextEditingController _userEtControllerPhone = TextEditingController();
  TextEditingController _userEtControllerCode = TextEditingController();
  bool isShowpwd = false, isClear = false, isClearP = false;

  static Map codephone = {"value": null, "verify": true};
  static Map msgCode = {"value": null, "verify": true};

  bool isShowButton2 = false;

  // bool isChoosed = false;

  /// 开始倒计时 时间
  int startTime;

  /// 当前倒计时 时间
  int countDownTime = 0;

  /// 总倒计时时长
  final int speed = 60;

  Timer _timer;
  SharedPreferences prefs;

  int id = 1;
  bool isRegister;
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .copyWith(textScaleFactor: 1),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // backgroundColor: rgba(255, 255, 255, 1),
            // appBar:
            //     customAppbar(context: null, borderBottom: false, title: '登录'),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              // color: rgba(255, 255, 255, 1),
              decoration: new BoxDecoration(
                // color: Colors.grey,
                // border: new Border.all(width: 2.0, color: Colors.transparent),
                // borderRadius: new BorderRadius.all(new Radius.circular(0)),
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/images/icon_loginvalidate.png'),
                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),
              // alignment: Alignment.centerLeft,
              // alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 120),
                    width: 108,
                    height: 69,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/icon_mainlogo.png',
                      width: 128,
                      height: 48.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text('聆  听  你  的  声  音',
                        style: TextStyle(
                            fontSize: 13,
                            color: rgba(255, 255, 255, 1),
                            fontWeight: FontWeight.w400)),
                  ),
                  Expanded(
                      child: Container(
                    // margin: EdgeInsets.only(top: 10),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            /// 输入手机号码
                            Container(
                                height: 55,
                                width: 290,
                                margin: EdgeInsets.only(top: 59),
                                padding: EdgeInsets.only(left: 26, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27.5),
                                    // rgba(255, 255, 255, 1)
                                    color: rgba(246, 246, 246, 1)),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 33,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '+86',
                                        style: TextStyle(
                                            color: rgba(69, 65, 103, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      height: 17,
                                      width: 1,
                                      color: rgba(150, 148, 166, 1),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          left: 0, right: 9, top: 19),
                                      // alignment: Alignment.centerLeft,
                                      // padding: EdgeInsets.only(top: 19, bottom: 19),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 190,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: _userEtControllerPhone,
                                        maxLength: 11,
                                        cursorColor: Colors.deepPurpleAccent,
                                        autofocus: true,
                                        // inputFormatters: [
                                        //   WhitelistingTextInputFormatter
                                        //       .digitsOnly
                                        // ],
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                            hintText: '请输入手机号',
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: rgba(150, 148, 166, 1),
                                                fontWeight: FontWeight.w400)),
                                        onChanged: (e) {
                                          // Text(
                                          //   _userEtControllerPhone.text,
                                          //   style: TextStyle(
                                          //       fontSize: 16,
                                          //       fontWeight: FontWeight.w500,
                                          //       color: rgba(12, 13, 15, 1)),
                                          // );
                                          RegExp regExp =
                                              RegExp(r'^((1[0-9]))\d{9}$');

                                          ///手机号验证
                                          // RegExp regExp = RegExp(
                                          //     '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
                                          setState(() {
                                            codephone['value'] = e;
                                            codephone['verify'] =
                                                regExp.hasMatch(e);
                                            if (null == codephone['value'] ||
                                                codephone['value']
                                                    .toString()
                                                    .isEmpty) {
                                              isShowButton2 = false;
                                            } else {
                                              isShowButton2 = true;
                                            }
                                            if (codephone['verify']) {
                                              isShowButton2 = true;
                                            } else {
                                              isShowButton2 = false;
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                )
                                // child: AButton.normal(
                                //   width: double.infinity,
                                //   height: 45,
                                //   plain: true,
                                //   bgColor: rgba(255, 255, 255, 1),
                                //   borderColor: rgba(255, 255, 255, 1),
                                //   padding: EdgeInsets.only(
                                //       left: 26, right: 10),
                                //   borderRadius: BorderRadius.circular(27.5),
                                //   child:
                                // ),
                                ),

                            /// 验证码
                            Container(
                              height: 55,
                              width: 290,
                              margin: EdgeInsets.only(top: 15),
                              padding: EdgeInsets.only(left: 26, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27.5),
                                  color: rgba(246, 246, 246, 1)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _userEtControllerCode,
                                      maxLength: 6,
                                      cursorColor: Colors.deepPurpleAccent,
                                      autofocus: true,
                                      // inputFormatters: [
                                      //   WhitelistingTextInputFormatter
                                      //       .digitsOnly
                                      // ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          hintText: '请输入验证码',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: rgba(150, 148, 166, 1),
                                              fontWeight: FontWeight.w400)),
                                      onChanged: (e) {
                                        setState(() {
                                          msgCode['value'] = e;
                                          msgCode['verify'] =
                                              e.length == 6 ? true : false;
                                        });
                                      },
                                    ),
                                  ),
                                  buildGetEmailCode()
                                ],
                              ),
                            ),

                            // 登录
                            isShowButton2
                                ? GestureDetector(
                                    onTap: () {
                                      // 登录
                                      loginCode();
                                    },
                                    child: Container(
                                      width: 290,
                                      height: 55,
                                      margin: EdgeInsets.only(top: 14),
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage(
                                              'assets/images/icon_loginchoosed.png'),
                                          //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                          // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                        ),
                                      ),
                                      // decoration: BoxDecoration(
                                      //     borderRadius:
                                      //     BorderRadius.circular(27.5),
                                      //     color: rgba(254, 107, 0, 1)),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '同意协议并登录',
                                          style: TextStyle(
                                              color: rgba(255, 255, 255, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 290,
                                    height: 55,
                                    margin: EdgeInsets.only(top: 14),
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(27.5)),
                                      image: new DecorationImage(
                                        image: new AssetImage(
                                            'assets/images/icon_loginunchoose.png'),
                                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                        centerSlice: new Rect.fromLTRB(
                                            270.0, 180.0, 1360.0, 730.0),
                                      ),
                                    ),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(27.5),
                                    //     color: rgba(255, 255, 255, 1)),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '同意协议并登录',
                                        style: TextStyle(
                                            color: rgba(255, 255, 255, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),

                            /// 协议
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // InkWell(
                                  //   child: Image.asset(
                                  //     isChoosed
                                  //         ? 'assets/images/icon_choosed.png'
                                  //         : 'assets/images/icon_normal.png',
                                  //     height: 15,
                                  //     width: 15,
                                  //   ),
                                  // ),
                                  InkWell(
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        '  用户注册即代表同意',
                                        style: TextStyle(
                                            color: rgba(255, 255, 255, 1),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      child: Text(
                                        ' 《用户协议》',
                                        style: TextStyle(
                                            color: rgba(255, 255, 255, 1),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  PolicyDetail(
                                                      title: '用户协议', data: '')),
                                        );
                                      }),
                                  InkWell(
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        '与',
                                        style: TextStyle(
                                            color: rgba(255, 255, 255, 1),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      child: Text(
                                        '《隐私政策》',
                                        style: TextStyle(
                                            color: rgba(255, 255, 255, 1),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  PolicyDetail(
                                                      title: '隐私政策', data: '')),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(bottom: 47),
                    width: 80,
                    height: 14,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/icon_bottomlogo.png',
                      width: 80,
                      height: 14,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          )),
      onWillPop: requestPop,
    );
  }

  Future<bool> requestPop() {
    return Future.value(false);
  }

  /// 验证码登录
  loginCode() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_userEtControllerPhone.text.isEmpty) {
      G.toast('请输入手机号');
      return;
    }
    if (!codephone['verify']) {
      G.toast('输入手机号有误');
      return;
    }
    if (_userEtControllerCode.text.isEmpty) {
      G.toast('请输入验证码');
      return;
    }
    if (!msgCode['verify']) {
      G.toast('输入6位验证码');
      return;
    }
    try {
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return new LoadingDialog();
      //     });
      var res = await G.req.user.loginCodeReq(
          phone: _userEtControllerPhone.text.toString().trim(),
          smsCode: _userEtControllerCode.text.toString().trim());
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return G.toast('登录失败');
      int code = data['code'];
      if (20000 == code) {
        try {
          // isRegister = prefs.getBool('isRegister');
          // print("isRegister");
          // print(isRegister);
          // if (isRegister==null ||!isRegister) {
          //   print("进入");
          //   dynamic xx = await EMClient.getInstance
          //       .createAccount(_userEtControllerPhone.text.toString().trim(), '12345678admin');
          //   print(xx);
          //   try {
          //     await EMClient.getInstance.login(_userEtControllerPhone.text.toString().trim(), '12345678admin');
          //   } on EMError catch (e) {
          //     print("ee1");
          //     print(e);
          //     // await G.toast('登录失败');
          //   } finally {
          //     print("ee2");
          //     // await G.toast('登录失败');
          //   }
          // } else {
          //   try {
          //     await EMClient.getInstance.login(_userEtControllerPhone.text.toString().trim(), '12345678admin');
          //   } on EMError catch (e) {
          //     print("ee3");
          //     print(e);
          //     // await G.toast('登录失败');
          //   } finally {
          //     // await G.toast('登录失败');
          //   }
          // }
          String tk = data['data']['token'];
          int account_id = data['data']['user']['id'];
          int gender = data['data']['user']['gender'];
          prefs.setString('tk', tk);
          prefs.setInt('account_id', account_id);
          prefs.setInt("infostate", 1);
          if (null != gender) {
            prefs.setInt('gender', gender);
          }
          prefs.setString(
              'phone', _userEtControllerPhone.text.toString().trim());
          if (null == gender) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GenderinfoPage(tk)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabNavigate(
                        tk,
                        _userEtControllerPhone.text.toString().trim(),
                        gender)));
          }
          await G.toast('登录成功');
        } on EMError catch (e) {
          print("eerrr");
          print(e);
          await G.toast('登录失败');
        } finally {}
      } else {
        G.toast('登录失败');
      }
    } catch (e) {
      G.toast('登录失败');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      startTime = prefs.getInt('startTime');

      int nowTime = G.getTime();

      if (startTime != null && startTime > 0) {
        if (nowTime - startTime > 60) {
          prefs.remove('startTime');
        } else {
          countDown();
        }
      }
    });
  }

  /// 倒计时
  countDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      int nowTime = G.getTime();
      int result = speed - (nowTime - startTime);
      if (result < 0) {
        prefs.remove('startTime');
        _timer?.cancel();
      }

      setState(() {
        countDownTime = result;
      });
    });
  }

  @override
  void dispose() {
    prefs.remove('startTime');
    _timer?.cancel();
    super.dispose();
  }

  /// 获取验证码
  GestureDetector buildGetEmailCode() {
    return GestureDetector(
      onTapDown: (e) {
        isClick = true;
        setState(() {});
      },
      onTapUp: (e) {
        isClick = false;
        print(countDownTime);
        setState(() {});
        if (countDownTime > 0) return;
        getMsgAuth();
      },
      // onTap: () {
      //   if (countDownTime > 0) return;
      //   getMsgAuth();
      // },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          countDownTime <= 0
              ? "获取验证码"
              : countDownTime < 10
                  ? '0$countDownTime'
                  : '$countDownTime',
          style: TextStyle(
              fontSize: 14,
              color: isClick ? Colors.black : rgba(150, 148, 166, 1),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  /// 短信权限
  getMsgAuth() async {
    // try {
    //   var res = await G.req.user.getCodeReq(
    //       phone: codephone['value'],
    //   );
    //   if (res.data == null) return;
    //   startTime = G.getTime();
    //   countDown();
    //   getRegisterFlag();
    // } catch (e) {
    //   G.toast('获取验证码失败');
    // }
    // try {
    //   var res = await G.req.user.getMsgtokenReq();
    //   if (res.data == null) return;
    //   String access_token = res.data['access_token'];
    //   if (access_token.isNotEmpty) {
    //     print(access_token);
    //     validateCodeReq(access_token, _randomBit(6));
    //   }
    //
    // } catch (e) {
    //   print(e);
    // }
    // RegExp regExp = RegExp(r'^((1[0-9]))\d{9}$');
    // codephone['verify'] =
    //     regExp.hasMatch(codephone['value']);

    if (!codephone['verify']) {
      G.toast("请输入正确的手机号");
      return;
    }

    try {
      var res = await G.req.user
          .getCodeReq(phone: _userEtControllerPhone.text.toString().trim());
      startTime = G.getTime();
      countDown();
      return;
      // if (res.data == null) return;
      // String access_token = res.data['access_token'];
      // if (access_token.isNotEmpty) {
      //   print(access_token);
      //   validateCodeReq(access_token, _randomBit(6));
      // }

    } catch (e) {
      print(e);
    }
  }

  _randomBit(int len) {
    String scopeF = '123456789'; //首位
    String scopeC = '0123456789'; //中间
    String result = '';
    for (int i = 0; i < len; i++) {
      if (i == 0) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }

  /// 短信验证码
  getMsgCode(String access_token, String codeVal) async {
    try {
      var res = await G.req.user.sendMsgCode(
          tk: access_token, phone: codephone['value'], tmapv: codeVal);

      if (res.data == null) return;
      String msg = res.data['msg'];
      // G.toast(msg);
      startTime = G.getTime();
      countDown();
      print("获取注册结果");
      getRegisterFlag();
    } catch (e) {
      G.toast('获取验证码失败');
    }
  }

  validateCodeReq(String access_token, String codeV) async {
    try {
      var res = await G.req.user
          .validateCodeReq(phone: codephone['value'], smsCode: codeV);

      if (res.data == null) return;
      String codeVal = res.data['data'];
      print(codeVal);
      getMsgCode(access_token, codeVal);
    } catch (e) {
      print(e);
    }
  }

  /// 是否注册
  getRegisterFlag() async {
    try {
      var res = await G.req.user.isRegisterUser(phone: codephone['value']);

      if (res.data == null) return;
      isRegister = res.data['success'];
      prefs.setBool('isRegister', isRegister);
      setState(() {});
    } catch (e) {}
  }

  @override
  bool get wantKeepAlive => true;
}
