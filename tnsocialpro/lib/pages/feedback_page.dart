import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:color_dart/color_dart.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';

class FeedbackPage extends StatefulWidget {
  String tk;
  FeedbackPage({Key key, @required this.tk}) : super(key: key);

  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static Map oldpwd = {"value": null, "verify": true};
  TextEditingController _contentTE = TextEditingController();

  SharedPreferences _prefs;
  String tk;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      tk = _prefs.getString('tk');
    });
  }

  /// 意见反馈
  feedSubmit() async {
    if (oldpwd['value'] == null) {
      return G.toast('请输入遇到的问题或建议信息');
    }
    if (!oldpwd['verify']) {
      return G.toast('请输入遇到的问题或建议信息少于6个字符');
    }

    try {
      var res = await G.req.user.feedBackReq(
          tk: widget.tk,
          content: oldpwd['value']);

      var data = res.data;

      if (data == null) return G.toast('问题反馈失败');

      int code = data['code'];
      if (20000 == code) {
        Navigator.pop(context);
        await G.toast('问题反馈成功');
      } else {
        G.toast('问题反馈失败');
      }
    } catch (e) {
      G.toast('问题反馈失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rgba(255, 255, 255, 1),
      appBar: customAppbar(
          context: context, borderBottom: false, title: '反馈建议'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 输入框
          Container(
            margin: EdgeInsets.only(top: 20, left: 18, right: 18),
            child: AButton.normal(
              width: 338,
              height: 210,
              plain: true,
              bgColor: rgba(255, 255, 255, 1),
              borderColor: Colors.grey,
              borderRadius: BorderRadius.circular(27.5),
              child: TextField(
                controller: _contentTE,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    filled: true,
                    focusColor: rgba(248, 248, 248, 1),
                    counterText: _contentTE.text.length.toString() + '/120',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    // contentPadding: EdgeInsets.all(15),
                    hintText: '请输入您的宝贵建议…',
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: rgba(218, 215, 229, 1),
                        fontWeight: FontWeight.w400
                    ),
                    fillColor: Colors.white),
                onChanged: (e) {
                  setState(() {
                    oldpwd['value'] = e;
                    oldpwd['verify'] = e.length < 6 ? false : true;
                  });
                },
            ),),
          ),
          Container(
            width: 290,
            height: 55,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30),
            child: AButton.normal(
                width: 290,
                height: 55,
                plain: true,
                bgColor: rgba(69, 65, 103, 1),
                borderColor: rgba(69, 65, 103, 1),
                borderRadius: BorderRadius.circular(27.5),
                child: Text(
                  '立即提交',
                  style: TextStyle(
                      color: rgba(255, 255, 255, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                color: rgba(255, 255, 255, 1),
                onPressed: () {
                  // 立即提交
                  feedSubmit();
                }),
          ),
        ],
      ),
    );
  }
}
