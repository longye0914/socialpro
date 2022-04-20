import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';

class VideoRow extends StatelessWidget {
  final double height;
  final Widget leftChild;
  final Widget centerChild;
  final Widget rightChild;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border border;
  final Color color;
  final Function onPressed;

  /// ARow 行
  /// 
  /// ```
  /// @param {double} height 高度
  /// @param {Widget} leftChild 左侧内容
  /// @param {Widget} centerChild 中间内容
  /// @param {Widget} rightChild 右侧内容
  /// @param {EdgeInsets} padding 内边距
  /// @param {EdgeInsets} margin 外边距
  /// @param {Border} border 
  /// @param {Color} color 
  /// @param {Function} onPressed 点击回调
  /// ```
  VideoRow({
    Key key,
    this.height = 30,
    this.padding,
    this.leftChild,
    this.centerChild,
    this.rightChild,
    this.border,
    this.color,
    this.onPressed,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: onPressed == null ? Colors.transparent : null,
      splashColor: onPressed == null ? Colors.transparent : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color == null ? rgba(51, 51, 51, 1) : color,
          border: border == null ? Border(bottom: BorderSide(width: 0, color: Colors.transparent)) : border
        ),
        padding: padding == null ? EdgeInsets.symmetric(horizontal: 10) : padding,
        margin: margin == null ? EdgeInsets.only(bottom: 10) : margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // left
            leftChild == null ? Container() : leftChild,

            // center
            Expanded(
              child: centerChild == null ? Container() : centerChild
            ),
            
            // right
            rightChild == null ? Container() : rightChild
          ],
        ),
      ),
      onTap: () => onPressed == null ? (){} : onPressed(),
    );
  }
}