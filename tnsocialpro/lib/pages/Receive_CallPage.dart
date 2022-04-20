import 'dart:async';
import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/event/chat_event.dart';
import 'package:tnsocialpro/event/video_event.dart';
import 'package:tnsocialpro/pages/AudioCallPage.dart';
import 'package:tnsocialpro/pages/VideoCallPage.dart';
import 'package:tnsocialpro/utils/global.dart';

class ReceiveCallPage extends StatefulWidget {
  //频道号 上个页面传递
  String userName, channel, tk, head_img;
  bool callFlag;
  int typeVal, uid;

  ReceiveCallPage(
      {Key key,
      this.userName,
      this.channel,
      this.tk,
      this.callFlag,
      this.head_img,
      this.typeVal,
      this.uid
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ReceiveCallPageState();
  }
}

class ReceiveCallPageState extends State<ReceiveCallPage> {
  SharedPreferences _prefs;
  //对方的uid
  int self_uid;
  // 是否接听
//  bool isReceive = false;
  AudioPlayer audioPlayer;
  String mp3Uri2;
  Timer timerV;
  static const durationV = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString('channel', this.widget.channel);
    });
    _load();
  }

  //本页面即将销毁
  @override
  void dispose() {
    super.dispose();
  }

  // 中间部分
  Widget _middleToolBar() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            height: 117,
            width: 117,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: rgba(21, 24, 30, 1)),
            margin: EdgeInsets.only(left: 15, right: 15, top: 67, bottom: 12),
            alignment: Alignment.center,
            child: Card(
              color: rgba(21, 24, 30, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(5)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                (null == this.widget.head_img || this.widget.head_img.isEmpty)
                    ? ''
                    : this.widget.head_img,
                height: 117,
                width: 117,
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Container(
          //     height: 117.5,
          //     width: 117.5,
          //     margin:
          //         EdgeInsets.only(left: 15, right: 15, top: 155.5, bottom: 12),
          //     alignment: Alignment.center,
          //     child: CircleAvatar(
          //         backgroundImage: new NetworkImage(
          //             (null == this.widget.head_img ||
          //                     this.widget.head_img.isEmpty)
          //                 ? ''
          //                 : Constants.picUrl + this.widget.head_img),
          //         radius: 50)),
          Text(
            (null == this.widget.userName || this.widget.userName.isEmpty)
                ? ''
                : widget.userName,
            style: TextStyle(
                color: rgba(255, 255, 255, 1),
                fontSize: 23,
                fontWeight: FontWeight.w500),
          ),
          // Text(
          //   widget.callFlag ? '正在等待对方接听…' : '',
          //   style: TextStyle(color: Colors.white, fontSize: 15),
          // ),
        ],
      ),
    );
  }

  //底部的菜单栏
  Widget _bottomToolBar() {
    //在中央
    return Container(
      alignment: Alignment.bottomCenter,
      //竖直方向相隔48
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //挂断按钮
          GestureDetector(
            onTap: () {
              answerReq(2, 0, this.widget.channel, widget.typeVal);
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(right: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'assets/images/icon_handup.png',
                    width: 72,
                    height: 72,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '拒绝',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          //接听按钮
          GestureDetector(
            onTap: () {
              answerReq(1, 0, this.widget.channel, widget.typeVal);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(left: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'assets/images/icon_receive.png',
                    width: 72,
                    height: 72,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '接听',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
//          appBar: new AppBar(
//            title: Text(widget.userName),
//          ),
          //背景黑色
          backgroundColor: Colors.black,
          body: new Center(
            child: Stack(
              children: <Widget>[
                /*_viewAudio(),*/ _middleToolBar(),
                _bottomToolBar()
              ],
            ),
          ),
        ));
  }

  // 接听/挂断
  void answerReq(int type, int time, String channel, int chat_type) async {
    try {
      var res = await G.req.shop.answerReq(
          tk: this.widget.tk,
          type: type,
          time: time,
          channel: channel,
          chat_type: chat_type,
          uid: widget.uid
      );
      if (res.data != null) {
//        String channel = res.data['data']['channel'];
        if (1 == type) {
          // 接听
          if (0 == widget.typeVal) {
            Future.delayed(Duration.zero, () async {
                await Permission.storage.request();
                await Permission.microphone.request();
              // if (isAudioPermiss) {
                //如果授权同意 跳转到语音页面
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AudioCallPage(
                    //频道写死，为了方便体验
                    userName: this.widget.userName,
                    channel: channel,
                    tk: this.widget.tk,
                    head_img: widget.head_img,
                    uid: widget.uid,
                  );
                }));
              // } else {
              //   openAppSettings();
              // }
            });
          } else {
            Future.delayed(Duration.zero, () async {
                await Permission.storage.request();
                await Permission.camera.request();
                await Permission.microphone.request();
              // if (isCameraPermiss && isAudioPermiss) {
                //如果授权同意
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return VideoCallPage(
                    //频道写死，为了方便体验
                    userName: this.widget.userName,
                    channel: channel,
                    tk: this.widget.tk,
                    head_img: widget.head_img,
                    uid: widget.uid,
                  );
                }));
              // } else {
              //   openAppSettings();
              // }
            });
          }
        } else if (2 == type) {
          // 挂断
          eventChatBus.fire(new ChatEvent(true));
        }
      }
      setState(() {});
    } catch (e) {}
  }

  Future<Null> _load() async {
    final ByteData data2 = await rootBundle.load('assets/sounds/receive.MP3');
    Directory tempDir2 = await getTemporaryDirectory();
    File tempFile2 = File('${tempDir2.path}/receive.MP3');
    await tempFile2.writeAsBytes(data2.buffer.asUint8List(), flush: true);
    mp3Uri2 = tempFile2.path.toString();
    audioPlayer = AudioPlayer();
    if (timerV == null) {
      timerV = Timer.periodic(durationV, (Timer t) {
        play(mp3Uri2);
      });
    }
  }

  play(String uslStr) async {
//    await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    await audioPlayer.play(uslStr, isLocal: true);
  }

  stop() async {
//    await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    await audioPlayer.stop();
    timerV.cancel();
    timerV = null;
    audioPlayer = null;
    setState(() {});
  }

  @override
  void deactivate() async {
    await audioPlayer.stop();
    timerV.cancel();
    timerV = null;
    audioPlayer = null;
    setState(() {});
    super.deactivate();
  }

  //监听Bus events
  void _listen() {
    eventVideoBus.on<VideoEvent>().listen((event) {
      stop();
      setState(() {
        Navigator.pop(context);
      });
    });
  }
}
