import 'package:tnsocialpro/widget/wx_expression.dart';
import 'package:tnsocialpro/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
// import 'package:w_popup_menu/w_popup_menu.dart';

class ChatTextBubble extends StatelessWidget {
  ChatTextBubble(this.body);
  final EMTextMessageBody body;
  @override
  Widget build(BuildContext context) {
    /*
    return WPopupMenu(
      menuHeight: 30,
      menuWidth: 120,
      onValueChanged: (e) {
        print(e);
      },
      actions: ['删除', '复制'],
      child: Container(
        padding: EdgeInsets.only(
          left: sWidth(13),
          right: sWidth(13),
          top: sHeight(9),
          bottom: sHeight(9),
        ),
        child: ExpressionText(
          body.content,
          TextStyle(
            color: Color.fromRGBO(51, 51, 51, 1),
            fontSize: sFontSize(17),
          ),
        ),
      ),
    );
    */
    return Container(
      padding: EdgeInsets.only(
        left: sWidth(13),
        right: sWidth(13),
        top: sHeight(9),
        bottom: sHeight(9),
      ),
      child: ExpressionText(
        body.content,
        TextStyle(
          color: Color.fromRGBO(51, 51, 51, 1),
          fontSize: sFontSize(17),
        ),
      ),
    );
  }
}
