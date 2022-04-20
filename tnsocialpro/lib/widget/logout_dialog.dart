import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      // color: rgba(0, 0, 0, 0.8),
      child: new Center(
        child: new Container(
          decoration: new ShapeDecoration(
              color: rgba(0, 0, 0, 0.8),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(6)))),
          width: 231,
          height: 180,
          padding: EdgeInsets.all(10),
          child: new Column(
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              new Text(
                '正在退出中...',
                style: TextStyle(
                    fontSize: 20,
                    color: rgba(255, 255, 255, 1),
                    fontWeight: FontWeight.w400),
                softWrap: false,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
