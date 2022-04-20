import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/Icon.dart';

/// 通用appbar
/// 
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
AppBar MonitorAppbar({
  BuildContext context,
  String title = '',
  bool borderBottom = true,
}) {
  return AppBar(
    centerTitle: true,
    title: Text(title, style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),),
    backgroundColor: Colours.orangebg,
  );
}