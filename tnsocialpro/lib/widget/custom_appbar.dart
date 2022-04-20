import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/global.dart';

/// 通用appbar
///
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
AppBar customAppbar(
    {BuildContext context,
    String title = '',
    bool borderBottom = true,
    List actions}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          color: rgba(69, 65, 103, 1),
          fontSize: 18,
          fontWeight: FontWeight.w600),
    ),
    backgroundColor: rgba(255, 255, 255, 1),
    elevation: 0,
    leading: context == null
        ? new Container()
        : InkWell(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/icon_back.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
            onTap: () => Navigator.pop(context),
          ),
    bottom: PreferredSize(
      child: Container(
        decoration: BoxDecoration(border: G.borderBottom(show: borderBottom)),
      ),
      preferredSize: Size.fromHeight(0),
    ),
    actions: actions,
  );
}
