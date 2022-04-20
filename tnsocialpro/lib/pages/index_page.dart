import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/pages/tab_navigate.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/common_widgets.dart';

import 'genderinfo_page.dart';
import 'login_index.dart';
import 'logininfo_page.dart';
import 'mainunlock_page.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPageState();
}

/// 欢迎页
class IndexPageState extends State<IndexPage> {
  final _totalTime = 3.0;
  Timer _timer;
  num _value;
  SharedPreferences prefs;
  MyInfoData myInfoData;
  String tkV, phone;
  int infoV, genderV;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      tkV = prefs.getString('tk');
      getUserInfo();
    });
    _value = _totalTime;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_value == 0) {
        _timer.cancel();
        toNextPage();
        return;
      }
      setState(() {
        _value--;
      });
    });
  }

  void toNextPage() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
            (null == tkV || tkV.isEmpty || null == myInfoData)
                ? new LoginIndex() : (0 == infoV || 1 == infoV || null == infoV) ? new GenderinfoPage(tkV) : (2 == infoV) ? new LogininfoPage(tkV, genderV) :
              (3 == infoV) ?  ((1 == genderV) ? new MainUnlockPage(tkV, genderV, phone) : new TabNavigate(tkV, phone, genderV)) : new TabNavigate(tkV, phone, genderV)));
    // if (EMClient.getInstance.isLoginBefore == true) {
    //   // Navigator.of(context).pushReplacementNamed('/home');
    // } else {
    //   // Navigator.of(context).pushReplacementNamed('/login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            alignment: Alignment.center,
            image: AssetImage('assets/images/icon_splasebg.png'),
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment(0.9, -0.95),
            child: SizedBox(
              width: sWidth(40),
              height: sHeight(40),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: CircularProgressIndicator(
                      value: ((_totalTime - _value) / _totalTime).toDouble(),
                      backgroundColor: Colors.red,
                      strokeWidth: 1.5,
                    ),
                  ),
                  Positioned(
                    child: Text(
                      '${_value.toInt()}s',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sFontSize(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
  /// 获取个人信息
  getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: tkV,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
            infoV = myInfoData.likedcount;
            genderV = myInfoData.gender;
            phone = myInfoData.phone;
          });
        }
      }
    } catch (e) {}
  }
}
