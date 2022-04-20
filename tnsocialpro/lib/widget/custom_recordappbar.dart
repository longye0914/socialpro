
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/utils/global.dart';

/// 通用appbar
/// 
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
AppBar customRecordAppbar({
  BuildContext context,
  String title = '',
  bool borderBottom = true,
  String tk,
  int old_id,
  List actions
}) {
  return AppBar(
    centerTitle: true,
    title: Text(title, style: TextStyle(
      color: Colours.backbg,
      fontSize: 18,
    ),),
    backgroundColor: Colors.white,
    elevation: 0,
    leading: context == null ? new Container() : GestureDetector(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 10,
              height: 18,
              margin: EdgeInsets.only(left: 14),
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/icon_back.png', width: 10,
                height: 18, fit: BoxFit.fill,),
            ),
            Container(
              child: Text('返回', style: TextStyle(fontSize: 16, color: rgba(153, 153, 153, 1)),),
            ),
          ]
      ),
      onTap: () {
        Navigator.pop(context);
      },
    ),
    bottom: PreferredSize(
      child: Container(
        decoration: BoxDecoration(
          border: G.borderBottom(show: borderBottom)
        ),
      ),
      preferredSize: Size.fromHeight(0),
    ),
    actions: <Widget>[
//      GestureDetector(
//          child: Container(
//            alignment: Alignment.centerRight,
//            height: 30,
//            margin: EdgeInsets.only(right: 15),
//            child: Text('新增记录', style: TextStyle(fontSize: 17, color: rgba(0, 141, 255, 1)),),
//          ),
//          onTap: () {
//            // 新增记录
//            Navigator.push(
//                context,
//                new MaterialPageRoute(builder: (context) => new AddsignPage(tk, old_id))
//            );
//          }
//      ),
    ],
  );
}