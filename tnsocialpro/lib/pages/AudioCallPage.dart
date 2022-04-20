import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/event/chat_event.dart';
import 'package:tnsocialpro/event/video_event.dart';
import 'package:wakelock/wakelock.dart';
import 'package:tnsocialpro/utils/global.dart';

class AudioCallPage extends StatefulWidget {
  //频道号 上个页面传递
  String userName, channel, tk, head_img;
  int uid;

  AudioCallPage({Key key, this.userName, this.channel, this.tk, this.head_img, this.uid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new AudioCallPageState();
  }
}

class AudioCallPageState extends State<AudioCallPage> {
  //声网sdk的appId 50483a401ad345f084d9c86013fcba74
  String agore_appId = "50483a401ad345f084d9c86013fcba74";
  SharedPreferences _prefs;

  //是否切换摄像头
  bool switchCaram = false;

  //是否启用扬声器
  // bool speakPhone = false;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;

  //对方的uid
  int self_uid;
  String mp3Uri;
  AudioPlayer audioPlayer;
  // 是否接听
  bool isReceive = false;

  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0, seconds, minutes, hours;
  bool isActive = false;

  Timer timer, timerV;
  String timeVal;
  RtcEngine _engine;

  void handleTick() {
    if (isActive) {
      secondsPassed = secondsPassed + 1; //需要更新UI
      setState(() {
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString('channel', this.widget.channel);
    });
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    _load();
    //初始化SDK
    initAgoreSdk();
  }

  //本页面即将销毁
  @override
  void dispose() async {
    if (null != audioPlayer) {
      await audioPlayer.stop();
      audioPlayer = null;
    }
    if (null != timer) {
      timer.cancel();
      timer = null;
    }
    if (null != timerV) {
      timerV.cancel();
      timerV = null;
    }
    // _onExit(context);
    super.dispose();
  }

  void initAgoreSdk() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(agore_appId));
    this._addListeners();

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    //初始化引擎
    // AgoraRtcEngine.create(agore_appId);
    // //设置视频为可用 启用音频模块
    // AgoraRtcEngine.enableAudio();
    //每次需要原生视频都要调用_createRendererView
    // _createRendererView(0);
    setState(() {
      _engine.joinChannel(null, widget.channel, null, 0);
    });
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          isJoined = true;
        });
      },
      leaveChannel: (stats) async {
        G.toast('通话结束');
        isJoined = false;
        if (!isJoined) {
          // _onExit(context);
        }
        // setState(() {
        // });
        // await _engine
        //     .joinChannel(config.token, config.channelId, null, config.uid)
        //     .catchError((err) {
        //   print('error ${err.toString()}');
        // });
      },
      userJoined: (uid, elapsed) {
        G.toast('已接通');
        isReceive = true;
        isActive = true;
        stop();
        setState(() {
          //更新UI布局
          // _createRendererView(uid);
          self_uid = uid;
        });
      },
      userOffline: (uid, reason) {
        print("用户离开的id为:$uid");
        G.toast('通话结束');
        setState(() {
          //移除用户 更新UI布局
          // _removeRenderView(uid);
          _onExit(context);
        });
      },
    ));
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {});
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {});
  }

  //退出频道 退出本页面
  void _onExit(BuildContext context) {
    if (null != _engine) {
      _engine.leaveChannel();
    }
    if (null != context) {
      Navigator.pop(context);
    }
  }

  // 中间部分
  Widget _middleToolBar() {
    //  ～/ 取整操作
    seconds = secondsPassed % 60;
    minutes = secondsPassed ~/ 60;
    hours = secondsPassed ~/ (60 * 60);
    timeVal = hours.toString().padLeft(2, '0') +
        ':' +
        minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
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
          Text(
            (null == this.widget.userName || this.widget.userName.isEmpty)
                ? ''
                : widget.userName,
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              isReceive ? timeVal : '正在等待对方接听…',
              style: TextStyle(
                  color: rgba(255, 255, 255, 0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          )
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //是否静音按钮
          GestureDetector(
            onTap: () {
              _switchMicrophone();
              // _isMute();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                openMicrophone
                    ? Container(
                        width: 72,
                        height: 72,
                        margin: EdgeInsets.only(left: 47),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: rgba(21, 24, 30, 1)),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/icon_voicemute.png',
                          // width: 42,
                          // height: 42,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        width: 72,
                        height: 72,
                        margin: EdgeInsets.only(left: 47),
                        child: Image.asset(
                          'assets/images/icon_muteselect.png',
                          width: 72,
                          height: 72,
                          fit: BoxFit.fill,
                        ),
                      ),
                Container(
                  width: 72,
                  // height: 72,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 47, top: 12),
                  child: Text(
                    '静音',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          //挂断按钮
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    answerReq(2, isReceive ? secondsPassed : 0,
                        this.widget.channel, 0);
                    _onExit(context);
                  },
                  child: Image.asset(
                    'assets/images/icon_handup.png',
                    width: 72,
                    height: 72,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    '取消',
                    style: TextStyle(
                        color: rgba(255, 255, 255, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                )
              ]),
          //是否外放
          GestureDetector(
            onTap: () {
              _switchSpeakerphone();
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  enableSpeakerphone
                      ? Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: rgba(21, 24, 30, 1)),
                          margin: EdgeInsets.only(right: 47),
                          // alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/icon_voicespeak.png',
                            // width: 72,
                            // height: 72,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(
                          width: 72,
                          height: 72,
                          margin: EdgeInsets.only(right: 47),
                          child: Image.asset(
                            'assets/images/icon_speakerselect.png',
                            width: 72,
                            height: 72,
                            fit: BoxFit.fill,
                          ),
                        ),
                  Container(
                    width: 72,
                    // height: 72,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 47, top: 12),
                    child: Text(
                      '免提',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return WillPopScope(
        child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
//          appBar: new AppBar(
//            title: Text(widget.userName),
//          ),
          //背景黑色
          backgroundColor: rgba(21, 24, 30, 0.85),
          body: new Center(
            child: Stack(
              children: <Widget>[
                /*_viewAudio(),*/ _middleToolBar(),
                _bottomToolBar()
              ],
            ),
          ),
        )),
      onWillPop: requestPop,
    );
  }

  Future<bool> requestPop() {
    return new Future.value(false);
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
      // setState(() {});
    } catch (e) {}
  }

  Future<Null> _load() async {
    final ByteData data = await rootBundle.load('assets/sounds/call.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/call.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.path.toString();
    audioPlayer = AudioPlayer();
    if (timerV == null) {
      timerV = Timer.periodic(duration, (Timer t) {
        play(mp3Uri);
      });
    }
  }

  play(String urlStr) async {
    await audioPlayer.play(urlStr, isLocal: true);
  }

  stop() async {
    await audioPlayer.stop();
    timerV.cancel();
    timerV = null;
    audioPlayer = null;
    setState(() {});
  }

  // @override
  // void deactivate() async {
  //   if (null != audioPlayer) {
  //     await audioPlayer.stop();
  //     audioPlayer = null;
  //   }
  //   if (null != timerV) {
  //     timerV.cancel();
  //     timerV = null;
  //   }
  //   _onExit(context);
  //   super.deactivate();
  // }

  //监听Bus events
  void _listen() {
    eventVideoBus.on<VideoEvent>().listen((event) async {
      setState(() {
        var timeOr = _prefs.getInt('time2');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 1000) {
          _prefs.setInt('time2', timeVal);
          answerReq(2, isReceive ? secondsPassed : 0, this.widget.channel, 0);
          _onExit(context);
        }
      });
    });
    eventChatBus.on<ChatEvent>().listen((event) {
      stop();
      setState(() {
        var timeOr = _prefs.getInt('timere');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 1000) {
          _prefs.setInt('timere', timeVal);
          answerReq(2, isReceive ? secondsPassed : 0, this.widget.channel, 0);
          _onExit(context);
        }
      });
    });
  }
}
