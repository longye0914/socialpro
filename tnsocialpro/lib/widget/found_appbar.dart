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
AppBar FoundAppbar({
  String title = '',
}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    //返回按钮占位
    leading: Container(),
    title: Text(
      title,
      style: TextStyle(
          color: rgba(12, 13, 15, 1),
          fontSize: 16,
          fontWeight: FontWeight.w500),
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
  );
}
