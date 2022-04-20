import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/pages/tab_navigate.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/paytip_dialog.dart';

import 'mainunlock_page.dart';

/**
 * 交友诚意认证界面
 */
class EnterValiddatePage extends StatefulWidget {
  String tk, phone;
  EnterValiddatePage(this.tk, this.phone);

  _EnterValiddatePageState createState() => _EnterValiddatePageState();
}

class _EnterValiddatePageState extends State<EnterValiddatePage> {

  @override
  void initState() {
    super.initState();
  }

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
            fit: BoxFit.cover,
            image: new AssetImage('assets/images/icon_loginvalidate.png'),),),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 23,
                        height: 24,
                        margin: EdgeInsets.only(top: 55, left: 18),
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/icon_close.png',
                          width: 23,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 230),
                      width: 149,
                      height: 24,
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/icon_bottomlogo.png',
                        width: 149,
                        height: 24,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 13),
                      child: Text('「甜腻」已有4543位小姐姐加入',
                          style: TextStyle(
                              fontSize: 16,
                              color: rgba(255, 255, 255, 1),
                              fontWeight: FontWeight.w400)),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.only(left: 23, right: 23, top: 20),
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage('assets/images/icon_entervalidate.png'),
                                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 23),
                                            child: Text('交友诚意认证',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: rgba(69, 65, 103, 1),
                                                    fontWeight: FontWeight.w600)),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 30),
                                                child: Text('¥18',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: rgba(69, 65, 103, 1),
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 10, right: 20, top: 5),
                                                child: Text('原价¥188',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: rgba(150, 148, 166, 1),
                                                        decoration: TextDecoration.lineThrough,
                                                        decorationColor: rgba(150, 148, 166, 1),
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ],
                                          )
                                        ]),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      alignment: Alignment.center,
                                      child: Text('打造真实纯净的交友环境，解锁超值交友权益',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: rgba(69, 65, 103, 1),
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 140,
                                width: double.infinity,
                              )
                            ],
                          )
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 0,
                          top: 15,
                          child: GestureDetector(
                            onTap: () {
                              // 立即加入
                              _uploadTianticket();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new AssetImage('assets/images/icon_quickenter.png'),
                                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                  // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 50, right: 50),
                              child: Text(
                                '立即加入',
                                style: TextStyle(
                                    color: rgba(255, 255, 255, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                          ),
                        ),),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 60,
                          top: 10,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                            child: AButton.normal(
                                width: double.infinity,
                                height: 50,
                                plain: true,
                                bgColor: Colors.transparent,
                                borderColor: rgba(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(25),
                                child: Text(
                                  '付费说明及相关权益',
                                  style: TextStyle(
                                      color: rgba(255, 255, 255, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                color: rgba(255, 255, 255, 1),
                                onPressed: () {
                                  // 付费说明及相关权益
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PaytipDialog();
                                      });
                                }),
                          ),)
                      ],
                    )
                  ],
                ),
              ],
            ),
          )));
  }

  // 更新甜甜券
  _uploadTianticket() async {
    try {
      var res = await G.req.shop.uploadTianticket(
          tk: widget.tk,
          tianticket: 1800,
          type: 1
      );
      var data = res.data;
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        Navigator.pop(context);
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new TabNavigate(widget.tk, widget.phone, 1)));
      } else {
      }
    } catch (e) {
    }
  }
}