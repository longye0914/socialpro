import 'dart:async';

import 'package:color_dart/color_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/event/loginout_event.dart';
import 'package:tnsocialpro/event/modifyfeedback_event.dart';
import 'package:tnsocialpro/event/modifyheadimg_event.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/pages/receiveorderpage.dart';
import 'package:tnsocialpro/pages/setting_page.dart';
import 'package:tnsocialpro/pages/withdrawpage.dart';
import 'package:tnsocialpro/utils/JhPickerTool.dart';
import 'package:tnsocialpro/utils/constants.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/utils/image_utils.dart';
import 'package:tnsocialpro/widget/LogoutDialog.dart';

import 'myinfo_page.dart';
import 'mypicture_page.dart';
import 'myvoicepage.dart';

class MineGirlPage extends StatefulWidget {
  MyInfoData myInfoData;
  String tk;
  int myinfonum, picCount, voiceCount;

  MineGirlPage(
      this.tk, this.myInfoData, this.myinfonum, this.picCount, this.voiceCount);

  _MineGirlPageState createState() => _MineGirlPageState();
}

class _MineGirlPageState extends State<MineGirlPage> {
  SharedPreferences _prefs;

  // int myinfonum = 20;
  // int videoSetFlag = 0, voiceSetFlag = 0, priimSetFlag = 0;
  // String videoOrder, voiceOrder, priviOrder;
  List<Picturelist> pictureList = [];
  List<Voicelist> voiceList = [];
  var _imgPath;

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: rgba(246, 243, 249, 1),
        alignment: Alignment.center,
        height: 750,
        child: Column(
          children: <Widget>[
            // 顶部
            Container(
              width: double.infinity,
              // height: 200,
              // alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 20),
              color: rgba(246, 243, 249, 1),
              // alignment: Alignment.center,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (null == widget.myInfoData) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginIndex()));
                      } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SettingPage(
                                    widget.myInfoData.phone, widget.tk)));
                      }
                    },
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 20, right: 26, bottom: 10),
                      child: Image.asset(
                        'assets/images/icon_mineset.png',
                        height: 19,
                        width: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(top: 6, left: 18),
                        child: new CircleAvatar(
                            backgroundImage: new NetworkImage(
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.userpic ||
                                        widget.myInfoData.userpic.isEmpty)
                                    ? ''
                                    : widget.myInfoData.userpic),
                            radius: 11.0),
                      ),
                      Container(
                        height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 35,
                                  width: 125,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      (null == widget.myInfoData ||
                                              widget
                                                  .myInfoData.username.isEmpty)
                                          ? ''
                                          : widget.myInfoData.username,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w500)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (null == widget.myInfoData) {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new LoginIndex()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new MyinfoPage(
                                                      widget.tk,
                                                      widget
                                                          .myInfoData.username,
                                                      widget.myInfoData.userpic,
                                                      widget.myInfoData.phone,
                                                      widget
                                                          .myInfoData.birthday,
                                                      widget.myInfoData.gender,
                                                      widget.myInfoData
                                                          .myselfintro,
                                                      widget.myInfoData
                                                          .bodylength,
                                                      widget.myInfoData.path,
                                                      widget.myInfoData
                                                          .signinfo)));
                                    }
                                  },
                                  child: Container(
                                    height: 34,
                                    width: 116,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: rgba(218, 215, 229, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    margin:
                                        EdgeInsets.only(left: 0, bottom: 15),
                                    child: Text(
                                        '我的资料  ' +
                                            widget.myinfonum.toString() +
                                            '%',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 22,
                                  width: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: rgba(209, 99, 242, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(18),
                                      )),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      (null == widget.myInfoData ||
                                              null == widget.myInfoData.age ||
                                              widget.myInfoData.age.isEmpty)
                                          ? '未知'
                                          : widget.myInfoData.age + '岁',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                                Container(
                                  height: 22,
                                  width: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: rgba(242, 197, 99, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(18),
                                      )),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      (null == widget.myInfoData ||
                                              widget.myInfoData.bodylength ==
                                                  null ||
                                              widget.myInfoData.bodylength
                                                  .isEmpty)
                                          ? '未知'
                                          : widget.myInfoData.bodylength + 'cm',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                                Container(
                                  height: 22,
                                  width: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: rgba(99, 182, 242, 1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(18),
                                      )),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      (null == widget.myInfoData ||
                                              widget.myInfoData.path == null)
                                          ? '未知'
                                          : widget.myInfoData.path,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                height: 60,
                margin:
                    EdgeInsets.only(left: 27, right: 27, top: 15, bottom: 15),
                decoration: BoxDecoration(
                    color: rgba(209, 99, 242, 1),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // null == widget.myInfoData.tianticket || widget.myInfoData.tianticket <= 0
                    (null != widget.myInfoData &&
                            1 == widget.myInfoData.infoflag &&
                            1 == widget.myInfoData.picflag &&
                            1 == widget.myInfoData.voiceflag &&
                            1 == widget.myInfoData.taskflag)
                        ? Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Text('收益',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: rgba(255, 255, 255, 1),
                                    fontWeight: FontWeight.w400)),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 25),
                            child: Text('完成接单任务，开始聊天赚钱',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: rgba(255, 255, 255, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          (null != widget.myInfoData &&
                                  1 == widget.myInfoData.infoflag &&
                                  1 == widget.myInfoData.picflag &&
                                  1 == widget.myInfoData.voiceflag &&
                                  1 == widget.myInfoData.taskflag)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 38,
                                      width: 38,
                                      margin: EdgeInsets.only(right: 6),
                                      child: Image.asset(
                                        'assets/images/icon_tiantianquan.png',
                                        height: 38,
                                        width: 38,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text(
                                        (null == widget.myInfoData ||
                                                null ==
                                                    widget.myInfoData
                                                        .tianticket ||
                                                widget.myInfoData.tianticket <=
                                                    0)
                                            ? '0'
                                            : widget.myInfoData.tianticket
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(255, 255, 255, 1),
                                            fontWeight: FontWeight.w500)),
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Image.asset(
                                    'assets/images/icon_rightwhite.png',
                                    height: 16,
                                    width: 8.9,
                                    fit: BoxFit.fill,
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                if (null == widget.myInfoData) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginIndex()));
                } else {
                  if (1 == widget.myInfoData.infoflag &&
                      1 == widget.myInfoData.picflag &&
                      1 == widget.myInfoData.voiceflag &&
                      1 == widget.myInfoData.taskflag) {
                    // 收益
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new WithdrawPage(
                                widget.tk,
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.tianticket ||
                                        widget.myInfoData.tianticket <= 0)
                                    ? 0
                                    : widget.myInfoData.tianticket,
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.tianmon ||
                                        widget.myInfoData.tianmon.isEmpty)
                                    ? '0'
                                    : widget.myInfoData.tianmon)));
                  } else {
                    // 完善资料
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ReceiveOrderPage(
                                widget.tk, widget.myInfoData)));
                  }
                }
              },
            ),
            Container(
              decoration: BoxDecoration(
                  color: rgba(246, 243, 249, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  )),
              width: double.infinity,
              // height: 315,
              // margin: EdgeInsets.only(top: 15),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 18, right: 18, bottom: 15),
                      decoration: BoxDecoration(
                          color: rgba(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                margin: EdgeInsets.only(left: 20),
                                child: Image.asset(
                                  'assets/images/icon_voice.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text('我的声音',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.voiceCount.toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                              Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: Image.asset(
                                  'assets/images/icon_right.png',
                                  height: 16,
                                  width: 8.9,
                                  fit: BoxFit.fill,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (null == widget.myInfoData) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginIndex()));
                      } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new MyvoicePage(
                                    widget.tk, widget.myInfoData.id)));
                      }
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 18, right: 18, bottom: 15),
                      decoration: BoxDecoration(
                          color: rgba(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 22,
                                width: 22,
                                margin: EdgeInsets.only(left: 20),
                                child: Image.asset(
                                  'assets/images/icon_picture.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text('我的照片',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.picCount.toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                              Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: Image.asset(
                                  'assets/images/icon_right.png',
                                  height: 16,
                                  width: 8.9,
                                  fit: BoxFit.fill,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (null == widget.myInfoData) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new LoginIndex()));
                      } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new MyPicturePage(
                                    widget.tk, widget.myInfoData.id)));
                      }
                    },
                  ),
                  // Container(
                  //   // height: 335,
                  //   margin: EdgeInsets.only(left: 18, right: 18, bottom: 15),
                  //   padding: EdgeInsets.only(bottom: 20, top: 5),
                  //   decoration: BoxDecoration(
                  //       color: rgba(255, 255, 255, 1),
                  //       borderRadius: BorderRadius.all(Radius.circular(12))),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       GestureDetector(
                  //         child: Container(
                  //             height: 50,
                  //             alignment: Alignment.center,
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Container(
                  //                       margin: EdgeInsets.only(left: 20),
                  //                       height: 22,
                  //                       width: 22,
                  //                       child: Image.asset(
                  //                         'assets/images/icon_picture.png',
                  //                         height: 22,
                  //                         width: 22,
                  //                         fit: BoxFit.fill,
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       width: 200,
                  //                       margin: EdgeInsets.only(left: 10),
                  //                       child: Text('我的照片',
                  //                           style: TextStyle(
                  //                               fontSize: 14,
                  //                               color: rgba(69, 65, 103, 1),
                  //                               fontWeight: FontWeight.w400)),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Text((null == pictureList || pictureList.isEmpty) ? '0' : (pictureList.length - 1).toString(),
                  //                         style: TextStyle(
                  //                             fontSize: 22,
                  //                             color: rgba(69, 65, 103, 1),
                  //                             fontWeight: FontWeight.w500)),
                  //                     Container(
                  //                       margin: EdgeInsets.only(right: 20, left: 10),
                  //                       child: Image.asset(
                  //                         'assets/images/icon_right.png',
                  //                         height: 16,
                  //                         width: 8.9,
                  //                         fit: BoxFit.fill,
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               ],
                  //             )
                  //         ),
                  //         onTap: () {
                  //           if (null == widget.myInfoData) {
                  //             Navigator.push(
                  //                 context,
                  //                 new MaterialPageRoute(
                  //                     builder: (context) => new LoginIndex()));
                  //           } else {
                  //             Navigator.push(
                  //                 context,
                  //                 new MaterialPageRoute(
                  //                     builder: (context) => new MyPicturePage(
                  //                         widget.tk, widget.myInfoData.id)));
                  //           }
                  //         },
                  //       ),
                  //       // (null == pictureList || pictureList.isEmpty)
                  //       //     ? Container(
                  //       //     height: 122,
                  //       //     width: 92,
                  //       //     decoration: BoxDecoration(
                  //       //         borderRadius: BorderRadius.circular(8),
                  //       //         color: rgba(245, 245, 245, 1)),
                  //       //     child: Stack(
                  //       //       children: <Widget>[
                  //       //         Container(
                  //       //             alignment: Alignment.center,
                  //       //             child: InkWell(
                  //       //                 onTap: () {
                  //       //                   BottomActionSheet.show(context, [
                  //       //                     '拍照',
                  //       //                     '选择图片',
                  //       //                   ], callBack: (i) {
                  //       //                     callBack(i);
                  //       //                     return;
                  //       //                   });
                  //       //                 },
                  //       //                 child: Container(
                  //       //                   height: 24,
                  //       //                   width: 24,
                  //       //                   alignment: Alignment.center,
                  //       //                   child: Image.asset('assets/images/icon_addpic.png',
                  //       //                       height: 24, width: 24, fit: BoxFit.fill),
                  //       //                 ))),
                  //       //       ],
                  //       //     )) : Container(
                  //       //   width: double.infinity,
                  //       //   color: rgba(255, 255, 255, 1),
                  //       //   height: 280,
                  //       //   // margin: EdgeInsets.all(10),
                  //       //   child: GridView.count(
                  //       //     physics: new BouncingScrollPhysics(),
                  //       //     //水平子Widget之间间距
                  //       //     crossAxisSpacing: 10,
                  //       //     //垂直子Widget之间间距
                  //       //     mainAxisSpacing: 10,
                  //       //     //GridView内边距
                  //       //     padding: EdgeInsets.all(10),
                  //       //     //一行的Widget数量
                  //       //     crossAxisCount: 3,
                  //       //     //子Widget宽高比例
                  //       //     childAspectRatio: 0.75,
                  //       //     //子Widget列表
                  //       //     children: getWidgetList(),
                  //       //   ),
                  //       // )
                  //       // Container(
                  //       //   margin: EdgeInsets.only(left: 15, right: 15),
                  //       //   child: UcarImagePicker(
                  //       //     tk: widget.tk,
                  //       //     maxCount: 5,
                  //       //     title: '',
                  //       //   ),
                  //       // )
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 18, right: 18, bottom: 20),
                    decoration: BoxDecoration(
                        color: rgba(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Text('接单设置',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w500)),
                        ),
                        GestureDetector(
                          child: Container(
                              height: 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 15, left: 20),
                                        height: 55,
                                        alignment: Alignment.center,
                                        child: Text('视频接单',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: rgba(69, 65, 103, 1),
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (0 ==
                                              widget.myInfoData.videosetflag) {
                                            widget.myInfoData.videosetflag = 1;
                                          } else {
                                            widget.myInfoData.videosetflag = 0;
                                          }
                                          updateVideoSet(
                                              widget.myInfoData.videoset,
                                              widget.myInfoData.videosetflag);
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 27.7,
                                          width: 45.7,
                                          child: Image.asset(
                                            (1 ==
                                                    widget.myInfoData
                                                        .videosetflag)
                                                ? 'assets/images/icon_switchchoosed.png'
                                                : 'assets/images/icon_switch.png',
                                            width: 47,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          (null == widget.myInfoData.videoset ||
                                                  widget.myInfoData.videoset
                                                      .isEmpty)
                                              ? ''
                                              : widget.myInfoData.videoset,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: rgba(69, 65, 103, 1),
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 23, left: 14),
                                        child: Image.asset(
                                          'assets/images/icon_right.png',
                                          height: 16,
                                          width: 8.9,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          onTap: () {
                            if (null == widget.myInfoData) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginIndex()));
                            } else {
                              // Pickers.showSinglePicker(context,
                              //   data: ['10Q/分钟', '50Q/分钟', '100Q/分钟', '150Q/分钟', '200Q/分钟', '250Q/分钟', '300Q/分钟', '350Q/分钟'],
                              //   selectData: videoOrder,
                              //   onConfirm: (p, position) {
                              //     setState(() {
                              //       videoOrder = p;
                              //       updateVideoSet(videoOrder, videoSetFlag);
                              //     });
                              //   },
                              //   // onChanged: (p) => print('数据发生改变：$p')
                              // );
                              var aa = [
                                '10Q/分钟',
                                '50Q/分钟',
                                '100Q/分钟',
                                '150Q/分钟',
                                '200Q/分钟',
                                '250Q/分钟',
                                '300Q/分钟',
                                '350Q/分钟'
                              ];
                              JhPickerTool.showStringPicker(context, data: aa,
                                  clickCallBack: (int index, var str) {
                                setState(() {
                                  widget.myInfoData.videoset = str;
                                  updateVideoSet(widget.myInfoData.videoset,
                                      widget.myInfoData.videosetflag);
                                });
                                // print(index);
                                // print(str);
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                              height: 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 15, left: 20),
                                        height: 55,
                                        alignment: Alignment.center,
                                        child: Text('语音接单',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: rgba(69, 65, 103, 1),
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (0 ==
                                              widget.myInfoData.voicesetflag) {
                                            widget.myInfoData.voicesetflag = 1;
                                          } else {
                                            widget.myInfoData.voicesetflag = 0;
                                          }
                                          updateVoiceSet(
                                              widget.myInfoData.voiceset,
                                              widget.myInfoData.voicesetflag);
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 27.7,
                                          width: 45.7,
                                          child: Image.asset(
                                            (1 ==
                                                    widget.myInfoData
                                                        .voicesetflag)
                                                ? 'assets/images/icon_switchchoosed.png'
                                                : 'assets/images/icon_switch.png',
                                            width: 47,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          (null == widget.myInfoData.voiceset ||
                                                  widget.myInfoData.voiceset
                                                      .isEmpty)
                                              ? ''
                                              : widget.myInfoData.voiceset,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: rgba(69, 65, 103, 1),
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 23, left: 14),
                                        child: Image.asset(
                                          'assets/images/icon_right.png',
                                          height: 16,
                                          width: 8.9,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          onTap: () {
                            if (null == widget.myInfoData) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginIndex()));
                            } else {
                              // Pickers.showSinglePicker(context,
                              //   data: ['10Q/分钟', '50Q/分钟', '100Q/分钟', '150Q/分钟', '200Q/分钟', '250Q/分钟', '300Q/分钟', '350Q/分钟'],
                              //   selectData: voiceOrder,
                              //   onConfirm: (p, position) {
                              //     setState(() {
                              //       voiceOrder = p;
                              //       updateVoiceSet(voiceOrder, voiceSetFlag);
                              //     });
                              //   },
                              //   // onChanged: (p) => print('数据发生改变：$p')
                              // );
                              var bb = [
                                '10Q/分钟',
                                '50Q/分钟',
                                '100Q/分钟',
                                '150Q/分钟',
                                '200Q/分钟',
                                '250Q/分钟',
                                '300Q/分钟',
                                '350Q/分钟'
                              ];
                              JhPickerTool.showStringPicker(context, data: bb,
                                  clickCallBack: (int index, var str) {
                                setState(() {
                                  widget.myInfoData.voiceset = str;
                                  updateVoiceSet(widget.myInfoData.voiceset,
                                      widget.myInfoData.voicesetflag);
                                });
                                // print(index);
                                // print(str);
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                              height: 55,
                              margin: EdgeInsets.only(bottom: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 15, left: 20),
                                        height: 55,
                                        alignment: Alignment.center,
                                        child: Text('私聊收费',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: rgba(69, 65, 103, 1),
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // if (0 == priimSetFlag) {
                                          //   priimSetFlag = 1;
                                          // } else {
                                          //   priimSetFlag = 0;
                                          // }
                                          // updatePriimSet(priviOrder, priimSetFlag);
                                          // setState(() {
                                          // });
                                        },
                                        child: Container(
                                          height: 27.7,
                                          width: 45.7,
                                          // child: Image.asset((1 == priimSetFlag) ? 'assets/images/icon_switchchoosed.png' : 'assets/images/icon_switch.png', width: 47, height: 30,),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          (null == widget.myInfoData.priimset ||
                                                  widget.myInfoData.priimset
                                                      .isEmpty)
                                              ? ''
                                              : widget.myInfoData.priimset,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: rgba(69, 65, 103, 1),
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 23, left: 14),
                                        child: Image.asset(
                                          'assets/images/icon_right.png',
                                          height: 16,
                                          width: 8.9,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          onTap: () {
                            if (null == widget.myInfoData) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginIndex()));
                            } else {
                              var cc = [
                                '1Q/条',
                                '5Q/条',
                                '10Q/条',
                                '15Q/条',
                                '20Q/条',
                                '25Q/条',
                                '30Q/条',
                                '35Q/条'
                              ];
                              JhPickerTool.showStringPicker(context, data: cc,
                                  clickCallBack: (int index, var str) {
                                setState(() {
                                  widget.myInfoData.priimset = str;
                                  updatePriimSet(widget.myInfoData.priimset,
                                      widget.myInfoData.priimsetflag);
                                });
                                // print(index);
                                // print(str);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // List<Widget> getWidgetList() {
  //   return ((pictureList.length > 6) ? pictureList.sublist(0, 6) : pictureList).map((Picturelist item) {
  //     return (0 == item.id) ? Container(
  //         height: 122,
  //         width: 92,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             color: rgba(245, 245, 245, 1)),
  //         child: Stack(
  //           children: <Widget>[
  //             Container(
  //                 alignment: Alignment.center,
  //                 child: InkWell(
  //                     onTap: () {
  //                       BottomActionSheet.show(context, [
  //                         '拍照',
  //                         '选择图片',
  //                       ], callBack: (i) {
  //                         callBack(i);
  //                         return;
  //                       });
  //                     },
  //                     child: Container(
  //                       height: 24,
  //                       width: 24,
  //                       alignment: Alignment.center,
  //                       child: Image.asset('assets/images/icon_addpic.png',
  //                           height: 24, width: 24, fit: BoxFit.fill),
  //                     ))),
  //           ],
  //         )) :
  //     Container(
  //         height: 137,
  //         width: 103,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             color: rgba(245, 245, 245, 1)),
  //         child: Stack(
  //           children: <Widget>[
  //             Container(
  //                 alignment: Alignment.center,
  //                 child: InkWell(
  //                     onTap: () {
  //                       // 查看大图
  //                       Navigator.push(
  //                           context,
  //                           new MaterialPageRoute(
  //                               builder: (context) =>
  //                               new MyheadImgPage(
  //                                   widget.tk, widget.myInfoData.id, pictureList.indexOf(item))));
  //                     },
  //                     child: Container(
  //                       height: 137,
  //                       width: 103,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           color: rgba(245, 245, 245, 1)),
  //                       alignment: Alignment.center,
  //                       child: Image.network(item.url, height: 137,
  //                           width: 103, fit: BoxFit.cover),
  //                     ))),
  //           ],
  //         ));
  //   }).toList();
  // }

  void callBack(i) {
    if (i == 0) {
      print('拍照');
      _getImage(0);
    } else if (i == 1) {
      print('选择照片');
      _getImage(1);
    }
  }

  Future _getImage(int type) async {
    var image;
    if (0 == type) {
      image = await ImageUtils.getImagecamera();
    } else if (1 == type) {
      image = await ImageUtils.getImagegallery();
    }
    setState(() {
      _imgPath = image;
      if (null != _imgPath) {
        G.loadingomm.show(context);
        _fileUplodImg(_imgPath);
      }
    });
  }

  /// 上传图片
  updateHeadimgInfo(String picUrl) async {
    // if (null == picUrl || picUrl.isEmpty) {
    //   G.toast('请选择用户头像');
    //   return;
    // }
    try {
      var res = await G.req.shop.updateUserpicReq(
          tk: this.widget.tk, url: picUrl, user_id: widget.myInfoData.id);

      var data = res.data;

      if (data == null) return null;
      G.loading.hide(context);
      int code = data['code'];
      print("updateHeadimgInfo图片");
      if (20000 == code) {
        getUserPicture();
        G.toast('上传成功');
      } else {
        G.toast('上传失败');
      }
    } catch (e) {
      G.toast('上传失败');
    }
  }

  /// 用户头像上传
  void _fileUplodImg(String filePath) async {
    // String path = filePath.path;
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);

    ///创建Dio
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': this.widget.tk,
    });
    Dio _uoloadImgDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(filePath, filename: name)});

    ///发送post
    Response response = await _uoloadImgDio.post(
      Constants.requestUrl + "qiniuphone/upLoadImage",
      data: formdata,

      ///这里是发送请求回调函数
      ///[progress] 当前的进度
      ///[total] 总进度
      onSendProgress: (int progress, int total) {
        print("当前进度是 $progress 总进度是 $total");
      },
    );

    ///服务器响应结果
    if (response.statusCode == 200) {
      Map map = response.data;
      // 0 表示正常，1 表示该场景下违规，2 表示疑似违规
      // int verify = map['data']['verify'];
      // if (0 == verify || 2 == verify) {
      var avatar = map['data'];
      // app 上传
      updateHeadimgInfo(avatar);
    } else {
      G.loading.hide(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // AutoOrientation.portraitUpMode();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
    });
    if (null == widget.myInfoData) {
      getUserInfo(false);
      // getUserVoice();
    }
  }

  /// 获取个人信息
  getUserInfo(bool isRefresh) async {
    try {
      print("isRefresh--$isRefresh");
      var res = await G.req.shop.getUserInfoReq(
        tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            widget.myInfoData = MyInfoParent.fromJson(res.data).data;
            if (null != widget.myInfoData) {
              if (isRefresh) {
                getUserPicture();
                getUserVoice();
              } else {
                if (0 == widget.picCount) {
                  getUserPicture();
                }
                if (0 == widget.voiceCount) {
                  getUserVoice();
                }
              }
              widget.myinfonum = 20;
              // videoSetFlag = widget.myInfoData.videosetflag;
              // voiceSetFlag = widget.myInfoData.voicesetflag;
              // priimSetFlag = widget.myInfoData.priimsetflag;
              // videoOrder = widget.myInfoData.videoset;
              // voiceOrder = widget.myInfoData.voiceset;
              // priviOrder = widget.myInfoData.priimset;
              if (null != widget.myInfoData.username &&
                  widget.myInfoData.username.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 20;
              }
              if (null != widget.myInfoData.userpic &&
                  widget.myInfoData.userpic.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              if (null != widget.myInfoData.birthday &&
                  widget.myInfoData.birthday.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              if (null != widget.myInfoData.bodylength &&
                  widget.myInfoData.bodylength.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              if (null != widget.myInfoData.path &&
                  widget.myInfoData.path.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              if (null != widget.myInfoData.signinfo &&
                  widget.myInfoData.signinfo.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              if (null != widget.myInfoData.myselfintro &&
                  widget.myInfoData.myselfintro.isNotEmpty) {
                widget.myinfonum = widget.myinfonum + 10;
              }
              // 资料
              if (100 == widget.myinfonum) {
                if (0 == widget.myInfoData.infoflag ||
                    null == widget.myInfoData.infoflag) {
                  // 更新资料更新
                  updateInfo(1);
                }
              } else {
                if (1 == widget.myInfoData.infoflag ||
                    null == widget.myInfoData.infoflag) {
                  // 更新资料更新
                  updateInfo(0);
                }
              }
              // 接单设置
              if (1 == widget.myInfoData.videosetflag ||
                  1 == widget.myInfoData.voicesetflag ||
                  1 == widget.myInfoData.priimsetflag) {
                if (0 == widget.myInfoData.taskflag ||
                    null == widget.myInfoData.taskflag) {
                  updateOrderTask(1);
                }
              } else {
                if (0 == widget.myInfoData.videosetflag &&
                    0 == widget.myInfoData.voicesetflag &&
                    0 == widget.myInfoData.priimsetflag) {
                  if (1 == widget.myInfoData.taskflag ||
                      null == widget.myInfoData.taskflag) {
                    updateOrderTask(0);
                  }
                }
              }
            }
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return LogoutDialog();
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return LogoutDialog();
            });
      }
    } catch (e) {}
  }

  /// 获取用户图片
  getUserPicture() async {
    try {
      print("minegirel获取图片");
      var res = await G.req.shop
          .getUserPictureReq(tk: widget.tk, user_id: widget.myInfoData.id);
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          pictureList.clear();
          // Picturelist pictureItem = new Picturelist();
          // pictureItem.id = 0;
          // pictureList.add(pictureItem);
          pictureList.addAll(PicturelistParent.fromJson(res.data).data);
          widget.picCount = (null == pictureList || pictureList.isEmpty)
              ? 0
              : pictureList.length;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  /// 资料更新状态
  updateInfo(int infoflag) async {
    try {
      var res = await G.req.shop
          .updateInfoReq(tk: this.widget.tk, infoflag: infoflag);
      var data = res.data;
      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      }
    } catch (e) {}
  }

  /// 接单设置状态
  updateOrderTask(int taskflag) async {
    try {
      var res = await G.req.shop
          .updateOrderTaskReq(tk: this.widget.tk, taskflag: taskflag);
      var data = res.data;
      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      }
    } catch (e) {}
  }

  /// 修改视频设置
  updateVideoSet(String videoset, int videosetflag) async {
    try {
      var res = await G.req.shop.videoSetReq(
          tk: this.widget.tk, videoset: videoset, videosetflag: videosetflag);
      var data = res.data;
      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      }
    } catch (e) {}
  }

  /// 修改音频设置
  updateVoiceSet(String voiceset, int voicesetflag) async {
    try {
      var res = await G.req.shop.voiceSetReq(
          tk: this.widget.tk, voiceset: voiceset, voicesetflag: voicesetflag);
      var data = res.data;
      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      }
    } catch (e) {}
  }

  /// 修改私聊设置
  updatePriimSet(String priimset, int priimsetflag) async {
    try {
      var res = await G.req.shop.priimSetReq(
          tk: this.widget.tk, priimset: priimset, priimsetflag: priimsetflag);
      var data = res.data;
      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        // setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      }
    } catch (e) {}
  }

  /// 获取用户音频
  getUserVoice() async {
    try {
      var res = await G.req.shop
          .getUserVoiceReq(tk: widget.tk, user_id: widget.myInfoData.id);
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          voiceList.clear();
          voiceList.addAll(VoicelistParent.fromJson(res.data).data);
          setState(() {
            widget.voiceCount =
            (null == voiceList || voiceList.isEmpty) ? 0 : voiceList.length;
          });
        }
      }
    } catch (e) {}
  }

  StreamSubscription<MyinfolistEvent> _infoSubsription;
  @override
  void dispose() {
    _infoSubsription.cancel();
    super.dispose();
  }

  //监听Bus events
  void _listen() {
    modifyFeedbackBus.on<ModifyFeedEvent>().listen((event) {
      print("modifyFeedbackBus图片");
      getUserPicture();
    });
    myvoiceBus.on<MyVoiceEvent>().listen((event) {
      getUserVoice();
    });
    modifyHeadBus.on<ModifyHeadEvent>().listen((event) {
      setState(() {
        widget.myInfoData.userpic = event.text;
//        getOldInfo();
      });
    });
    eventLoginoutBus.on<LoginoutEvent>().listen((event) {
      setState(() {
        _prefs.setString('tk', '');
        _prefs.setInt('account_id', 0);
        _prefs.setString('phone', '');
        _prefs.setBool('isRegister', false);
      });
    });
    _infoSubsription = myinfolistBus.on<MyinfolistEvent>().listen((event) {
      print("myinfolistBus-minegirl-");
      getUserInfo(event.isRefresh);
    });
  }

}
