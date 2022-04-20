import 'package:color_dart/rgba_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/pages/receiveorderpage.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/card_onlineuser.dart';
import 'package:tnsocialpro/widget/row_noline.dart';

import 'login_index.dart';
import 'myinfo_page.dart';

/**
 * 接单任务提示
 */
class FinishOrdertipPage extends StatefulWidget {
  MyInfoData myInfoData;
  String tk;
  FinishOrdertipPage(this.tk, this.myInfoData);

  _FinishOrdertipPageState createState() => _FinishOrdertipPageState();
}

class _FinishOrdertipPageState extends State<FinishOrdertipPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // color: rgba(255, 255, 255, 1),
          decoration: new BoxDecoration(
              // color: Colors.grey,
              // border: new Border.all(width: 2.0, color: Colors.transparent),
              // borderRadius: new BorderRadius.all(new Radius.circular(0)),
              image: new DecorationImage(
              image: new AssetImage('assets/images/icon_loginvalidate.png'),
              fit: BoxFit.fill
            ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      myinfolistBus.fire(new MyinfolistEvent(true));
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 23,
                      height: 24,
                      margin: EdgeInsets.only(top: 55, left: 18),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/icon_close.png',
                        width: 23,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 43),
                    alignment: Alignment.topCenter,
                    height: 65,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/icon_finishtip.png',
                      width: 177,
                      height: 65,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // 去完成
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new ReceiveOrderPage(
                              widget.tk, widget.myInfoData)));
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage('assets/images/icon_orderfinished.png'),
                      //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                      // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 98, left: 76, right: 76),
                  child: Text(
                    '去完成',
                    style: TextStyle(
                        color: rgba(69, 65, 103, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          )
    ));
  }
}