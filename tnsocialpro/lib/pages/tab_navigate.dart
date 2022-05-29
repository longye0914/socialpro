import 'dart:async';
import 'dart:io';

import 'package:color_dart/color_dart.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/alarm/data.dart';
import 'package:tnsocialpro/data/bannerlist/data.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/event/chatrefresh_event.dart';
import 'package:tnsocialpro/event/loginout_event.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/tabswitch_event.dart';
import 'package:tnsocialpro/event/video_event.dart';
import 'package:tnsocialpro/pages/main_page.dart';
import 'package:tnsocialpro/pages/message_page.dart';
import 'package:tnsocialpro/pages/mine_page.dart';
import 'package:tnsocialpro/utils/global.dart';

import 'Receive_CallPage.dart';
import 'maingirl_page.dart';
import 'minegirl_page.dart';

enum Action { Ok, Cancel }

class TabNavigate extends StatefulWidget {
  String tk;
  int gender;
  String emaccount;

  TabNavigate(this.tk, this.emaccount, this.gender) {
    this.tk = tk;
    // this.currentIndex = currentIndex;
    this.emaccount = this.emaccount;
    this.gender = gender;
  }

  @override
  State<StatefulWidget> createState() => TabNavigateState();
}

class TabNavigateState extends State<TabNavigate> with WidgetsBindingObserver {
  String debugLable = 'Unknown';
  JPush jpush = new JPush();
  String registration_id, device_id;
  SharedPreferences prefs;
  final defaultColor = rgba(150, 148, 166, 100);
  final activeColor = rgba(69, 65, 163, 100);
  String sn;
  String path, _version, upremark, apkpath, _updateVersion;
  bool isForceUpdate = false;
  List<String> contentStr = [];
  String _choice = 'Nothing';
  static const durationV = const Duration(seconds: 1);
  static const testPlatform = const MethodChannel("com.demo.testphone");
  int count = 0;
  int currentIndex = 0;
  final PageController tabController = PageController(
    initialPage: 0,
  );
  int userId;
  String headimg;
  MyInfoData myInfoData;

  List<Picturelist> pictureList = [];
  List<Voicelist> voiceList = [];
  int myinfonum = 20;

  List<MyUserData> mainUser = [];
  List<Bannerlist> bannerListDatas = [];
  final List<MyUserData> visitUser = [];
  final List<MyUserData> fansUser = [];

  @override
  Widget build(BuildContext context) {
    _listen();
    return WillPopScope(
      child: MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .copyWith(textScaleFactor: 1),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            // backgroundColor: rgba(255, 255, 255, 1),
            body: PageView(
              controller: tabController,
              children: <Widget>[
                (1 == widget.gender)
                    ? MainPage(this.widget.tk, widget.gender, headimg, mainUser,
                        bannerListDatas)
                    : MainGirlPage(
                        this.widget.tk, userId, widget.gender, headimg),
                MessagePage(this.widget.tk, widget.gender, userId, headimg),
                // MineGirlPage(widget.tk),
                (1 == widget.gender)
                    ? MinePage(
                        this.widget.tk,
                        myInfoData,
                        (null == visitUser || visitUser.isEmpty)
                            ? 0
                            : visitUser.length,
                        (null == fansUser || fansUser.isEmpty)
                            ? 0
                            : fansUser.length)
                    : MineGirlPage(
                        this.widget.tk,
                        myInfoData,
                        myinfonum,
                        (null == pictureList || pictureList.isEmpty)
                            ? 0
                            : pictureList.length,
                        (null == voiceList || voiceList.isEmpty)
                            ? 0
                            : voiceList.length),
              ],
              physics: NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: rgba(255, 255, 255, 1),
                currentIndex: currentIndex,
                onTap: (index) async {
                  tabController.jumpToPage(index);
                  if(currentIndex == 2){

                  }
                  setState(() {
                    currentIndex = index;
                    // if (1 == index) {
                    //   userRefreshBus.fire(new UserRefreshEvent(true));
                    // }
                    // if (0 == index) {
                    //   myinfolistBus.fire(new MyinfolistEvent(true));
                    // }
                  });
                  // 刷新IM
                  // refreshUnreadIm();
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Image(
                        height: 28,
                        width: 28,
                        image: AssetImage('assets/images/main_normal.png'),
                        fit: BoxFit.fill,
                      ),
                      activeIcon: Image(
                          height: 28,
                          width: 28,
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/main_selected.png')),
                      title: Text(
                        '首页',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: currentIndex != 0 ? defaultColor : activeColor,
                        ),
                      )),
                  BottomNavigationBarItem(
                      icon: (0 == count)
                          ? Image(
                              height: 27,
                              width: 27,
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/chat_normal.png'))
                          : Stack(
                              alignment: Alignment(6, -4),
                              children: <Widget>[
                                Image(
                                    height: 27,
                                    width: 27,
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/chat_normal.png')),
                                badge(count),
                              ],
                            ),
                      activeIcon: (0 == count)
                          ? Image(
                              height: 27,
                              width: 27,
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/chat_choosed.png'))
                          : Stack(
                              alignment: Alignment(6, -4),
                              children: <Widget>[
                                Image(
                                    height: 27,
                                    width: 27,
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/chat_choosed.png')),
                                badge(count),
                              ],
                            ),
                      title: Text(
                        '消息',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: currentIndex != 1 ? defaultColor : activeColor,
                        ),
                      )),
                  BottomNavigationBarItem(
                      icon: Image(
                          height: 27,
                          width: 27,
                          image: AssetImage('assets/images/mine_normal.png')),
                      activeIcon: Image(
                          height: 27,
                          width: 27,
                          image: AssetImage('assets/images/mine_selected.png')),
                      title: Text(
                        '我的',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: currentIndex != 2 ? defaultColor : activeColor,
                        ),
                      )),
                ]),
          )),
      onWillPop: requestPop,
    );
  }

  // 红点
  static badge(int count,
      {Color color = Colors.red,
      bool isdot = false,
      double height = 18.0,
      double width = 18.0}) {
    final _num = count > 99 ? '···' : count;
    return Container(
        alignment: Alignment.center,
        height: !isdot ? height : height / 2,
        width: !isdot ? width : width / 2,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(100.0)),
        child: !isdot
            ? Text('$_num',
                style: TextStyle(color: Colors.white, fontSize: 12.0))
            : null);
  }

  Future<bool> requestPop() {
    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      widget.gender = prefs.getInt('gender');
      userId = prefs.getInt('account_id');
      // 消息
      // 获取个人信息
      getUserInfo();
      getAllUserData();
      getBannerlist();
      getVisitUserData();
      getMyLikelistData();
      if (null != widget.emaccount) {
        if (!EMClient.getInstance.isLoginBefore) {
          try {
            await EMClient.getInstance.login(widget.emaccount, 'adminTianNi');
          } on EMError catch (e) {
          } finally {}
        }
      }
    });
  }

  /// 获取个人信息
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: prefs.getString('tk'),
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
            if (null != myInfoData) {
              widget.gender = myInfoData.gender;
              userId = myInfoData.id;
              headimg = myInfoData.userpic;
              getUserPicture();
              getUserVoice();
              myinfonum = 20;
              if (null != myInfoData.username &&
                  myInfoData.username.isNotEmpty) {
                myinfonum = myinfonum + 20;
              }
              if (null != myInfoData.userpic && myInfoData.userpic.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              if (null != myInfoData.birthday &&
                  myInfoData.birthday.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              if (null != myInfoData.bodylength &&
                  myInfoData.bodylength.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              if (null != myInfoData.path && myInfoData.path.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              if (null != myInfoData.signinfo &&
                  myInfoData.signinfo.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              if (null != myInfoData.myselfintro &&
                  myInfoData.myselfintro.isNotEmpty) {
                myinfonum = myinfonum + 10;
              }
              // 资料
              if (100 == myinfonum) {
                if (0 == myInfoData.infoflag || null == myInfoData.infoflag) {
                  // 更新资料更新
                  updateInfo(1);
                }
              } else {
                if (1 == myInfoData.infoflag || null == myInfoData.infoflag) {
                  // 更新资料更新
                  updateInfo(0);
                }
              }
              // 接单设置
              if (1 == myInfoData.videosetflag ||
                  1 == myInfoData.voicesetflag ||
                  1 == myInfoData.priimsetflag) {
                if (0 == myInfoData.taskflag || null == myInfoData.taskflag) {
                  updateOrderTask(1);
                }
              } else {
                if (0 == myInfoData.videosetflag &&
                    0 == myInfoData.voicesetflag &&
                    0 == myInfoData.priimsetflag) {
                  if (1 == myInfoData.taskflag || null == myInfoData.taskflag) {
                    updateOrderTask(0);
                  }
                }
              }
            }
          });
        }
      }
    } catch (e) {}
  }

  /// 获取用户图片
  getUserPicture() async {
    try {
      print("主页获取图片");
      var res =
          await G.req.shop.getUserPictureReq(tk: widget.tk, user_id: userId);
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            pictureList.clear();
            pictureList.addAll(PicturelistParent.fromJson(res.data).data);
          });
        }
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
      var res =
          await G.req.shop.getUserVoiceReq(tk: widget.tk, user_id: userId);
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            voiceList.clear();
            voiceList.addAll(VoicelistParent.fromJson(res.data).data);
          });
        }
      }
    } catch (e) {}
  }

  /// 获取用户列表
  void getAllUserData() async {
    // 看过我
    try {
      var res = await G.req.shop.getAllUserlistReq(
        tk: widget.tk,
        currentPage: 1
      );
      setState(() {
        if (res.data != null) {
          mainUser.clear();
          mainUser.addAll(UserlistParent.fromJson(res.data).data);
        }
      });
    } catch (e) {
      // setState(() {
      // });
    }
  }

  /// 获取bannerlist
  getBannerlist() async {
    try {
      var res = await G.req.shop.getBannerlistReq(tk: widget.tk);
      if (res.data != null) {
        setState(() {
          bannerListDatas.clear();
          bannerListDatas.addAll(BannerlistParent.fromJson(res.data).data);
          // if (null == bannerListDatas || bannerListDatas.isEmpty) {
          //   Bannerlist bannerItem = new Bannerlist();
          //   bannerItem.src = 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/3.jpg';
          //   bannerListDatas.add(bannerItem);
          // }
        });
      }
    } catch (e) {}
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      jpush.setup(
        appKey: "7de928f2a3d4f23cc0faa999",
        channel: "developer-default",
        production: true,
        debug: true,
      );
      jpush.setUnShowAtTheForeground(unShow: true);

      jpush.applyPushAuthority(
          new NotificationSettingsIOS(sound: true, alert: true, badge: false));

      // Platform messages may fail, so we use a try/catch PlatformException.
      jpush.getRegistrationID().then((rid) {
        print("flutter get registration id : $rid");
        registration_id = rid;
        setState(() {
          debugLable = "flutter getRegistrationID: $rid";
          // 获取设备信息
          getDeviceInfo();
        });
      });

      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          _getJpushMessage(message);
          setState(() {
            debugLable = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          _getJpushMessage(message);
          setState(() {
            debugLable = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          _getJpushMessage(message);
          setState(() {
            debugLable = "flutter onReceiveMessage: $message";
          });
        },
        onReceiveNotificationAuthorization:
            (Map<String, dynamic> message) async {
          // _getJpushMessage(message);
          setState(() {
            debugLable = "flutter onReceiveNotificationAuthorization: $message";
          });
        },
      );
    } on PlatformException {
      print("JPUSH初始化失败");
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device_id = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      device_id = iosInfo.identifierForVendor;
    }
    setState(() {
      // 提交设备信息
      submitDeviceInfo();
    });
  }

  _getJpushMessage(Map<String, dynamic> message) {
    int id;
    String channel, head_img, name;
    if (Platform.isAndroid) {
      Map alarmData = AlarmParent.fromJson(message).extras;
      if (null != alarmData) {
        // G.toastLong(alarmData.toString());
        List<String> alarmlist = alarmData.toString().split(",");
        // G.toastLong(alarmlist.toString());
        List<String> alistJtype = alarmlist[4].split(':');
        String jtypeStr = alistJtype[2];
        if (jtypeStr.contains("0")) {
          channel = alarmlist[5];
          id = int.parse(alarmlist[6]);
          name = alarmlist[7];
          head_img = alarmlist[8].substring(0, alarmlist[8].length - 3);
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          // 语音通话
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ReceiveCallPage(
                //视频房间频道号写死，为了方便体验
                userName: name,
                head_img: (null == head_img || head_img.isEmpty)
                    ? ""
                    : head_img.replaceAll('\\', ''),
                channel: channel,
                tk: this.widget.tk,
                callFlag: false,
                typeVal: 0,
                uid: id,
              ),
            ),
          );
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("1")) {
          channel = alarmlist[5];
          id = int.parse(alarmlist[6]);
          name = alarmlist[7];
          head_img = alarmlist[8].substring(0, alarmlist[8].length - 3);
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          // 视频
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ReceiveCallPage(
                //视频房间频道号写死，为了方便体验
                userName: name,
                head_img: (null == head_img || head_img.isEmpty)
                    ? ""
                    : head_img.replaceAll('\\', ''),
                channel: channel,
                tk: this.widget.tk,
                callFlag: false,
                typeVal: 1,
                uid: id,
              ),
            ),
          );
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("2")) {
          // 挂断
          eventVideoBus.fire(new VideoEvent(true));
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("3")) {
          // 新消息
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          tabController.jumpToPage(1);
          setState(() {
            currentIndex = 1;
          });
        }
      }
    } else {
      // _openAlertDialog(message.toString());
      if (null != message) {
        List<String> alarml = message.toString().split("jtype:");
        List<String> alarmlist = alarml[2].split(',');
        String jtypeStr = alarmlist[0];
        if (jtypeStr.contains("0")) {
          channel = alarmlist[1];
          id = int.parse(alarmlist[2]);
          name = alarmlist[3];
          head_img = alarmlist[4];
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          // 语音通话
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ReceiveCallPage(
                //视频房间频道号写死，为了方便体验
                userName: name,
                head_img:
                    (null == head_img || head_img.isEmpty) ? "" : head_img,
                channel: channel,
                tk: this.widget.tk,
                callFlag: false,
                typeVal: 0,
                uid: id,
              ),
            ),
          );
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("1")) {
          channel = alarmlist[1];
          id = int.parse(alarmlist[2]);
          name = alarmlist[3];
          head_img = alarmlist[4];
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          // 视频
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ReceiveCallPage(
                //视频房间频道号写死，为了方便体验
                userName: name,
                head_img:
                    (null == head_img || head_img.isEmpty) ? "" : head_img,
                channel: channel,
                tk: this.widget.tk,
                callFlag: false,
                typeVal: 1,
                uid: id,
              ),
            ),
          );
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("2")) {
          // 挂断
          eventVideoBus.fire(new VideoEvent(true));
          jpush.clearAllNotifications();
        } else if (jtypeStr.contains("3")) {
          // 新消息
          testPlatform
              .invokeMethod("methodChannelphone", new Map<String, String>())
              .then((value) {
            // 原生返回的值
            if (mounted) {
              setState(() {});
            }
          });
          tabController.jumpToPage(1);
          setState(() {
            currentIndex = 1;
          });
        }
      }
    }
  }

  /// 提交设备信息
  submitDeviceInfo() async {
    try {
      var res = await G.req.shop.submitDeviceInfoReq(
          tk: this.widget.tk,
          register_id: registration_id,
          type:
              (defaultTargetPlatform == TargetPlatform.iOS) ? 'ios' : 'android',
          device_id: device_id,
          user_id: userId);
      if (res.data == null) {
//        return;
      } else {
        setState(() {
          int code = res.data['code'];
        });
      }
    } catch (e) {}
  }

  StreamSubscription<LoginoutEvent> loginoutSusc;
  StreamSubscription<TabSwitchBus> tabSwitchSusc;
  StreamSubscription<ChatRefreshEvent> chatSusc;
  //监听Bus events
  void _listen() {
    loginoutSusc??=eventLoginoutBus.on<LoginoutEvent>().listen((event) {
      prefs.setString('tk', '');
      prefs.setInt('account_id', 0);
      prefs.setInt('gender', 0);
      prefs.setString('phone', '');
      this.widget.tk = '';
      setState(() {});
    });
    tabSwitchSusc ??= tabSwitchBus.on<TabSwitchBus>().listen((event) {
      tabController.jumpToPage(2);
      setState(() {
        currentIndex = 2;
      });
      setState(() {});
    });
    // 未读
    chatSusc ??=eventChatRefreshBus.on<ChatRefreshEvent>().listen((event) async {
      setState(() {
        var timeOr = prefs.getInt('eventChatRefreshBus');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 800) {
          prefs.setInt('eventChatRefreshBus', timeVal);
          refreshUnreadIm();
        }
      });
    });
    // myinfolistBus.on<MyinfolistEvent>().listen((event) {
    //   getUserInfo();
    // });
  }

  void refreshUnreadIm() async {
    try {
      count = 0;
      List<EMConversation> list =
          await EMClient.getInstance.chatManager.loadAllConversations();
      for (var conv in list) {
        count += conv.unreadCount;
      }
      setState(() {});
    } on Error {
    } finally {}
  }

  Future _openAlertDialog(String content) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('asdasd'),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('asdasd'),
              onPressed: () {
                Navigator.pop(context, Action.Ok);
              },
            ),
          ],
        );
      },
    );

    switch (action) {
      case Action.Ok:
        setState(() {
//          _choice = 'Ok';
        });
        break;
      case Action.Cancel:
        setState(() {
//          _choice = 'Cancel';
        });
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // submitDeviceInfo2("3");
  }

  @override
  void deactivate() {
    super.deactivate();
    // submitDeviceInfo2("3");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        // G.toast('应用程序可见，前台');
        submitDeviceInfo2("2");
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        // G.toast('应用程序不可见，后台');
        submitDeviceInfo2("3");
        break;
      case AppLifecycleState.detached:
        // 申请将暂时暂停
        break;
    }
  }

  /// 更新用户状态
  submitDeviceInfo2(String typeV) async {
    try {
      var res = await G.req.shop.updateUserBackorFont(
        tk: widget.tk,
        id: userId,
        type: typeV,
      );
      if (res.data != null) {
        setState(() {
          // int code = res.data['code'];
        });
      }
    } catch (e) {}
  }

  /// 获取看过我列表
  void getVisitUserData() async {
    // 看过我
    try {
      var res = await G.req.shop.getVisitUserReq(
        tk: widget.tk,
        follow_id: userId,
      );
      setState(() {
        if (res.data != null) {
          visitUser.clear();
          visitUser.addAll(UserlistParent.fromJson(res.data).data);
        }
      });
    } catch (e) {
      setState(() {});
    }
  }

  /// 获取看过我列表
  void getMyLikelistData() async {
    // 我喜欢的
    try {
      var res =
          await G.req.shop.getMyLikelistReq(tk: widget.tk, user_id: userId);
      setState(() {
        if (res.data != null) {
          fansUser.clear();
          fansUser.addAll(UserlistParent.fromJson(res.data).data);
        }
      });
    } catch (e) {
      setState(() {});
    }
  }

  void _incrementCounter() {

    bool isConnected = EMClient.getInstance.connected;
    print('isConnnecte ${isConnected}');
    return;
   /* *//*三秒后出发本地推送*//*
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 3000);
    var localNotification = LocalNotification(
      id: 234,
      title: '我是推送测试标题',
      buildId: 1,
      content: '看到了说明已经成功了',
      fireTime: fireDate,
      subtitle: '一个测试',
    );
    JPush jj = new JPush();
    jj.sendLocalNotification(localNotification);*/
  }
}
