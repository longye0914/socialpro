
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/colors.dart';

/// 通用appbar
/// 
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
AppBar messageAppbar({
  BuildContext context,
  String title = '',
  bool borderBottom = true,
  List actions
}) {
  return AppBar(
    centerTitle: true,
    title: MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
      child: Text(title, style: TextStyle(
        color:  Colors.white,
        fontSize: 18,
//      fontWeight: FontWeight.bold
      ),)),
    backgroundColor: Colours.vipbg,
    brightness: Brightness.light,
    elevation: 0,
    leading: context == null ? new Container() : InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 10,
            height: 18,
            margin: EdgeInsets.only(left: 13),
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/images/icon_backwhite.png',),
          ),
          Container(
//            margin: EdgeInsets.only(left: 4),
            child: MediaQuery(
              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
              child: Text('返回', style: TextStyle(fontSize: 16, color: Colors.white),)),
          ),
        ]
      ),
      onTap: () => Navigator.pop(context),
    ),
//    bottom: PreferredSize(
//      child: Container(
//        decoration: BoxDecoration(
//          border: G.borderBottom(show: borderBottom)
//        ),
//      ),
//      preferredSize: Size.fromHeight(0),
//    ),
    actions: actions,
  );
}