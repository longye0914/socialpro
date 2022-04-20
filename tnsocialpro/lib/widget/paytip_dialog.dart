import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';

/**
 * 付费提示弹框
 */
class PaytipDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      // color: rgba(0, 0, 0, 0.8),
      child: new Center(
        child: new Container(
          decoration: new ShapeDecoration(
              color: rgba(255, 255, 255, 1),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(25)))),
          width: 260,
          height: 330,
          // padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(color: rgba(234, 117, 187, 1), width: 6), // 边色与边宽度
                        color: rgba(234, 117, 187, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 23, right: 14, top: 45),
                      height: 14,
                      width: 14,
                      alignment: Alignment.center,
                    ),
                    Container(
                      width: 180,
                      margin: EdgeInsets.only(right: 23, top: 45),
                      child: Text('打造平台内真实纯净的交友环境，保证用户的真实性',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: rgba(69, 65, 103, 1),
                              fontWeight: FontWeight.w400)),
                    ),
                  ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(color: rgba(234, 117, 187, 1), width: 6), // 边色与边宽度
                        color: rgba(234, 117, 187, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 23, right: 14, top: 20),
                      height: 14,
                      width: 14,
                      alignment: Alignment.center,
                    ),
                    Container(
                      width: 180,
                      margin: EdgeInsets.only(right: 23, top: 20),
                      child: Text('杜绝低端用户骚扰（未认证用户无法聊天），筛选掉广告等虚假用户',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: rgba(69, 65, 103, 1),
                              fontWeight: FontWeight.w400)),
                    ),
                  ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(color: rgba(234, 117, 187, 1), width: 6), // 边色与边宽度
                        color: rgba(234, 117, 187, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 23, right: 14, top: 20),
                      height: 14,
                      width: 14,
                      alignment: Alignment.center,
                    ),
                    Container(
                      width: 180,
                      margin: EdgeInsets.only(right: 23, top: 20),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Text.rich(
                          new TextSpan(
                            text: '认证后将获得平台赠送的',
                            style: new TextStyle(
                            color: rgba(69, 65, 103, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none),
                            children: <TextSpan>[
                            new TextSpan(
                              text: '1800甜甜券',
                              style: new TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none)),
                            new TextSpan(
                              text: '，快拿去和心仪的小姐姐语音/视频聊天吧~',
                              style: new TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none)),
                          ]),
                        ),
                      )
                    ),
                  ]),
              GestureDetector(
                onTap: () {
                  // 知道了
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    border: new Border.all(color: rgba(234, 117, 187, 1), width: 6), // 边色与边宽度
                    color: rgba(234, 117, 187, 1), // 底色
                    borderRadius: BorderRadius.all(new Radius.circular(25)),
                    shape: BoxShape.rectangle, // 默认值也是矩形
                  ),
                  // decoration: new BoxDecoration(
                  //   image: new DecorationImage(
                  //     image: new AssetImage('assets/images/icon_quickenter.png'),
                  //     //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  //     // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                  //   ),
                  // ),
                  margin: EdgeInsets.only(left: 54, right: 54, top: 35),
                  child: Text(
                    '知道了',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
