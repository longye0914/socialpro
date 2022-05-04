import 'dart:async';

import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/event/tabswitch_event.dart';
import 'package:tnsocialpro/utils/global.dart';

import 'login_index.dart';
import 'myinfo_page.dart';
import 'mypicture_page.dart';
import 'myvoicepage.dart';

/**
 * 接单任务
 */
class ReceiveOrderPage extends StatefulWidget {
  MyInfoData myInfoData;
  String tk;
  StreamSubscription infoSubscription, voiceSubscription;

  ReceiveOrderPage(this.tk, this.myInfoData);

  _ReceiveOrderPageState createState() => _ReceiveOrderPageState();
}

class _ReceiveOrderPageState extends State<ReceiveOrderPage>
    with WidgetsBindingObserver {
  // bool stepOne = false, stepTwo = false, stepThree = false, stepFour = false;
  // widget.myInfoData widget.myInfoData;
  // int myinfonum = 20;
  // int videoSetFlag, voiceSetFlag, priimSetFlag;

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            // color: rgba(255, 255, 255, 1),
            decoration: BoxDecoration(
              // color: Colors.grey,
              // border: new Border.all(width: 2.0, color: Colors.transparent),
              // borderRadius: new BorderRadius.all(new Radius.circular(0)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/icon_loginvalidate.png'),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60, right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 30,
                          padding: EdgeInsets.only(left: 15),
                          height: 30,
                          decoration: BoxDecoration(color: Colors.transparent),
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/icon_whiteback.png',
                            width: 8.9,
                            height: 16,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '接单任务',
                          style: TextStyle(
                              color: rgba(255, 255, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        child: Text(
                          '',
                          style: TextStyle(
                              color: rgba(255, 255, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                // NRow(
                //   margin: EdgeInsets.only(top: 35),
                //   color: Colors.transparent,
                //   leftChild: GestureDetector(
                //     onTap: () {
                //       myinfolistBus.fire(new MyinfolistEvent(true));
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       width: 8.9,
                //       height: 16,
                //       alignment: Alignment.centerLeft,
                //       child: Image.asset(
                //         'assets/images/icon_whiteback.png',
                //         width: 8.9,
                //         height: 16,
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //   ),
                //   centerChild: Container(
                //     margin: EdgeInsets.only(left: 120),
                //     child: Text(
                //       '接单任务',
                //       style: TextStyle(
                //           color: rgba(255, 255, 255, 1),
                //           fontSize: 18,
                //           fontWeight: FontWeight.w600),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    '完成以下任务即可开始聊天赚钱',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  alignment: Alignment.centerLeft,
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    'Step 1',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 25, right: 25, top: 5),
                  decoration: BoxDecoration(
                      color: rgba(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 6, left: 12),
                              child: Image.asset(
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.infoflag ||
                                        0 == widget.myInfoData.infoflag)
                                    ? 'assets/images/icon_ordernormal.png'
                                    : 'assets/images/icon_orderchoose.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text('完善全部资料',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                      (null == widget.myInfoData ||
                              null == widget.myInfoData.infoflag ||
                              0 == widget.myInfoData.infoflag)
                          ? GestureDetector(
                              onTap: () {
                                // 去完成资料
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
                                          builder: (context) => new MyinfoPage(
                                              widget.tk,
                                              widget.myInfoData.username,
                                              widget.myInfoData.userpic,
                                              widget.myInfoData.phone,
                                              widget.myInfoData.birthday,
                                              widget.myInfoData.gender,
                                              widget.myInfoData.myselfintro,
                                              widget.myInfoData.bodylength,
                                              widget.myInfoData.path,
                                              widget.myInfoData.signinfo)));
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/icon_orderbg.png'),
                                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                  ),
                                ),
                                child: Text('去完成',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(255, 255, 255, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  alignment: Alignment.centerLeft,
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    'Step 2',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 25, right: 25, top: 5),
                  decoration: BoxDecoration(
                      color: rgba(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 6, left: 12),
                              child: Image.asset(
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.voiceflag ||
                                        0 == widget.myInfoData.voiceflag)
                                    ? 'assets/images/icon_ordernormal.png'
                                    : 'assets/images/icon_orderchoose.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text('录制一段我的声音',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                      (null == widget.myInfoData ||
                              null == widget.myInfoData.voiceflag ||
                              0 == widget.myInfoData.voiceflag)
                          ? GestureDetector(
                              onTap: () {
                                // 去完成资料
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
                                          builder: (context) => new MyvoicePage(
                                              widget.tk,
                                              widget.myInfoData.id)));
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/icon_orderbg.png'),
                                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                  ),
                                ),
                                child: Text('去完成',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(255, 255, 255, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  alignment: Alignment.centerLeft,
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    'Step 3',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 25, right: 25, top: 5),
                  decoration: BoxDecoration(
                      color: rgba(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 6, left: 12),
                              child: Image.asset(
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.picflag ||
                                        0 == widget.myInfoData.picflag)
                                    ? 'assets/images/icon_ordernormal.png'
                                    : 'assets/images/icon_orderchoose.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text('上传3张我的真实照片',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                      (null == widget.myInfoData ||
                              null == widget.myInfoData.picflag ||
                              0 == widget.myInfoData.picflag)
                          ? GestureDetector(
                              onTap: () {
                                // 去完成资料
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
                                              new MyPicturePage(widget.tk,
                                                  widget.myInfoData.id)));
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/icon_orderbg.png'),
                                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                  ),
                                ),
                                child: Text('去完成',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(255, 255, 255, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  alignment: Alignment.centerLeft,
                  height: 20,
                  width: double.infinity,
                  child: Text(
                    'Step 4',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 25, right: 25, top: 5),
                  decoration: BoxDecoration(
                      color: rgba(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsets.only(right: 6, left: 12),
                              child: Image.asset(
                                (null == widget.myInfoData ||
                                        null == widget.myInfoData.taskflag ||
                                        0 == widget.myInfoData.taskflag)
                                    ? 'assets/images/icon_ordernormal.png'
                                    : 'assets/images/icon_orderchoose.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text('设置接单项目和金额',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                      (null == widget.myInfoData ||
                              null == widget.myInfoData.taskflag ||
                              0 == widget.myInfoData.taskflag)
                          ? GestureDetector(
                              onTap: () {
                                // 去完成资料
                                if (null == widget.myInfoData) {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new LoginIndex()));
                                } else {
                                  Navigator.pop(context);
                                  tabSwitchBus.fire(new TabSwitchBus(2));
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => new TabNavigate(widget.tk, 2, widget.myInfoData.phone, widget.myInfoData.gender)));
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                margin: EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/icon_orderbg.png'),
                                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                  ),
                                ),
                                child: Text('去完成',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(255, 255, 255, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 完成任务
                    if (null == widget.myInfoData.infoflag ||
                        0 == widget.myInfoData.infoflag) {
                      Fluttertoast.showToast(msg: '请完善全部资料');
                      return;
                    }
                    if (null == widget.myInfoData.voiceflag ||
                        0 == widget.myInfoData.voiceflag) {
                      Fluttertoast.showToast(msg: '录制一段我的声音');
                      return;
                    }
                    if (null == widget.myInfoData.picflag ||
                        0 == widget.myInfoData.picflag) {
                      Fluttertoast.showToast(msg: '上传3张我的真实照片');
                      return;
                    }
                    if (null == widget.myInfoData.taskflag ||
                        0 == widget.myInfoData.taskflag) {
                      Fluttertoast.showToast(msg: '设置接单项目和金额');
                      return;
                    }
                    print("接单页面，完成任务");
                    myinfolistBus.fire(new MyinfolistEvent(true));
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage(((null == widget.myInfoData ||
                                    null == widget.myInfoData.infoflag ||
                                    0 == widget.myInfoData.infoflag) ||
                                (null == widget.myInfoData.voiceflag ||
                                    0 == widget.myInfoData.voiceflag) ||
                                (null == widget.myInfoData.picflag ||
                                    0 == widget.myInfoData.picflag) ||
                                (null == widget.myInfoData.taskflag ||
                                    0 == widget.myInfoData.taskflag))
                            ? 'assets/images/icon_orderunfinish.png'
                            : 'assets/images/icon_orderfinished.png'),
                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 120, left: 42, right: 42),
                    child: Text(
                      '完成任务',
                      style: TextStyle(
                          color: ((null == widget.myInfoData ||
                                      null == widget.myInfoData.infoflag ||
                                      0 == widget.myInfoData.infoflag) ||
                                  (null == widget.myInfoData.voiceflag ||
                                      0 == widget.myInfoData.voiceflag) ||
                                  (null == widget.myInfoData.picflag ||
                                      0 == widget.myInfoData.picflag) ||
                                  (null == widget.myInfoData.taskflag ||
                                      0 == widget.myInfoData.taskflag))
                              ? rgba(150, 148, 166, 1)
                              : rgba(69, 65, 103, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Future.delayed(Duration.zero, () async {
    //   prefs = await SharedPreferences.getInstance();
    // });
    // if (null == widget.myInfoData) {
    getUserInfo();
    // }
  }

  @override
  void dispose() {
    print("999dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    if (widget.infoSubscription != null) {
      widget.infoSubscription.cancel();
    }
    if (widget.voiceSubscription != null) {
      widget.voiceSubscription.cancel();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getUserInfo();
  }

  /// 获取个人信息
  getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            widget.myInfoData = MyInfoParent.fromJson(res.data).data;
            // if (null != widget.myInfoData) {
            // if (widget.myInfoData.username.isNotEmpty) {
            //   myinfonum = myinfonum + 20;
            // }
            // if (widget.myInfoData.userpic.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // if (widget.myInfoData.birthday.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // if (widget.myInfoData.bodylength.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // if (widget.myInfoData.path.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // if (widget.myInfoData.signinfo.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // if (widget.myInfoData.myselfintro.isNotEmpty) {
            //   myinfonum = myinfonum + 10;
            // }
            // 资料
            // if (100 == myinfonum) {
            //   if (null == widget.myInfoData.infoflag || 0 == widget.myInfoData.infoflag) {
            //     // 更新资料更新
            //     updateInfo(1);
            //   }
            // } else {
            //   if (null == widget.myInfoData.infoflag || 1 == widget.myInfoData.infoflag) {
            //     // 更新资料更新
            //     updateInfo(0);
            //   }
            // }
            // // 接单设置
            // if (1 == videoSetFlag || 1 == voiceSetFlag || 1 == priimSetFlag) {
            //   if (null == widget.myInfoData.taskflag || 0 == widget.myInfoData.taskflag) {
            //     updateOrderTask(1);
            //   }
            // } else {
            //   if (0 == videoSetFlag && 0 == voiceSetFlag && 0 == priimSetFlag) {
            //     if (null == widget.myInfoData.taskflag || 1 == widget.myInfoData.taskflag) {
            //       updateOrderTask(0);
            //     }
            //   }
            // }
            // }
          });
        }
        // else if (1001 == code) {
        //   showDialog(
        //       context: context,
        //       builder: (context) {
        //         return LogoutDialog();
        //       });
        // }
      }
    } catch (e) {}
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
        // setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
        setState(() {
          // stepTwo = (1 == widget.myInfoData.voiceflag) ? true : false;
          // stepThree = (1 == widget.myInfoData.picflag) ? true : false;
        });
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
        // setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
        setState(() {});
      }
    } catch (e) {}
  }

  //监听Bus events
  void _listen() {
    widget.infoSubscription =
        myinfolistBus.on<MyinfolistEvent>().listen((event) {
          if(mounted){
            print("获取info");
            getUserInfo();
          }
    });
    widget.voiceSubscription = myvoiceBus.on<MyVoiceEvent>().listen((event) {
      print("获取info-voice");
      getUserInfo();
    });
  }
}
