/**
 * @desc    Flutter公共样式 | Q：282310962
 * @create  andy 2020/4/28
 */

import 'package:flutter/material.dart';
class GStyle {
  // 红点
  static badge(int count, {Color color = Colors.red, bool isdot = false, double height = 18.0, double width = 18.0}) {
  final _num = count > 99 ? '···' : count;
    return Container(alignment: Alignment.center, height: !isdot ? height : height/2, width: !isdot ? width : width/2,
     decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(100.0)),child: !isdot ? Text('$_num', style: TextStyle(color: Colors.white, fontSize: 12.0)) : null
    );
  }
  static const border = Divider(color: Color(0xffb9b9b9), height: 1.0, thickness: .5,);
  // __ 颜色
  static const backgroundColor = Color(0xffeeeeee);static const appbarColor = Color(0xff0091ea);
  static const tabbarColor = Color(0xfff5f5f5);static const primaryColor = Color(0xff0091ea);
  static const bg_fff = Color(0xffffffff);static const bg_fbfbfb = Color(0xfffbfbfb);
  static const bg_ebebeb = Color(0xffebebeb);static const bg_dbdbdb = Color(0xffdbdbdb);
  static const bg_0091ea = Color(0xff0091ea);static const c_fff = Color(0xffffffff);
  static const c_999 = Color(0xff999999);static const c_353535 = Color(0xff353535);static const c_0091ea = Color(0xff0091ea);
  // __ 间距
  static mt(double value) { return EdgeInsets.only(top: value); }static mb(double value) { return EdgeInsets.only(bottom: value); }
  static ml(double value) { return EdgeInsets.only(left: value); }static mr(double value) { return EdgeInsets.only(right: value); }
  static mtb(double value) { return EdgeInsets.symmetric(vertical: value); }static mlr(double value) { return EdgeInsets.symmetric(horizontal: value); }
  static margin(double value) { return EdgeInsets.all(value); }
  // __ 自定义图标
  static iconfont(int codePoint, {double size = 16.0, Color color}) {
   return Icon(IconData(codePoint, fontFamily: 'iconfont', matchTextDirection: true),
    size: size,color: color,
    );
  }
  // __ 自定义按钮
  static btnCustom(String title, { Color color = const Color(0xff0091ea), Color textColor = Colors.white, double borderRadius = 2.0, double height, double width = double.infinity, Function onPressed,
  }) {
   return Container(
    height: height,width: width,
     child: RaisedButton(
     child: Text(title),color: color,textColor: textColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
     onPressed: onPressed,
      ),
    );
  }
}
