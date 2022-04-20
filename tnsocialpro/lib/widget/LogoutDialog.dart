import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/event/loginout_event.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/widget/a_button.dart';

class LogoutDialog extends Dialog {
  LogoutDialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: new ShapeDecoration(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(10)))),
            width: 260,
            height: 140,
            // padding: EdgeInsets.all(15),
            child: new Column(
              children: <Widget>[
//              GestureDetector(
//                onTap: () => Navigator.of(context).pop(),
//                child: Container(
//                  alignment: Alignment.topRight,
//                  child: Image.asset('assets/images/icon_clear.png',
//                    width: 15,  height: 15,
//                  ),
//                ),
//              ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    '登录已失效，请重新登录',
                    style: TextStyle(
                        color: rgba(89, 94, 104, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: AButton.normal(
                      width: 82,
                      child: Text(
                        '重新登录',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                      height: 35,
                      bgColor: rgba(234, 117, 187, 1),
                      color: Colors.white,
                      onPressed: () {
                        eventLoginoutBus.fire(new LoginoutEvent(true));
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginIndex()));
                      }),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ),
      ),
      onWillPop: requestPop,
    );
  }

  Future<bool> requestPop() {
    return new Future.value(false);
  }
}
