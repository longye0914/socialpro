import 'package:color_dart/rgba_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HighopinionPage extends StatefulWidget {
  String tk;
  HighopinionPage(this.tk);
  _HighopinionPageState createState() => _HighopinionPageState();
}

class _HighopinionPageState extends State<HighopinionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: rgba(246, 243, 249, 1),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              decoration: new BoxDecoration(
                color: Colors.grey,
                // border: new Border.all(width: 2.0, color: Colors.transparent),
                borderRadius: new BorderRadius.all(new Radius.circular(0)),
                image: new DecorationImage(
                  image: new AssetImage('assets/images/icon_loginvalidate.png'),
                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // height: 44,
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 50, right: 26),
                    child: Text(
                      '编辑资料',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}