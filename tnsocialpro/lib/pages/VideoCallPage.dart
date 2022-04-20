import 'dart:async';
import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/entity/VideoUserSession.dart';
import 'package:tnsocialpro/event/chat_event.dart';
import 'package:tnsocialpro/event/video_event.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:wakelock/wakelock.dart';

class VideoCallPage extends StatefulWidget {
  //频道号 上个页面传递
  String userName, channel, tk, head_img;
  int uid;

  VideoCallPage({Key key, this.userName, this.channel, this.tk, this.head_img, this.uid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new VideoCallState();
  }
}

class VideoCallState extends State<VideoCallPage> {
  //声网sdk的appId
  String agore_appId = "50483a401ad345f084d9c86013fcba74";

  //用户seesion对象
  static final _userSessions = List<VideoUserSession>();
  //是否静音
  bool muted = false;
  // 是否切换
  bool isSwitch = false;
  // 是否接听
  bool isReceive = false, switchRender = true;
  List<Widget> views;
  String mp3Uri;
  AudioPlayer audioPlayer;
  //是否启用扬声器
  bool speakPhone = false,
      switchCamera = false,
      enableSpeakerphone = true,
      openMicrophone = true;
  bool isJoined = false;
  List<int> remoteUid = [];

  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0, seconds, minutes, hours;
  bool isActive = false;

  Timer timer, timerV;
  String timeVal;
  SharedPreferences _prefs;
  RtcEngine _engine;

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1; //需要更新UI
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _load();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString('channel', this.widget.channel);
    });
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    //初始化SDK
    initAgoreSdk();
    //事件监听回调
    // setAgoreEventListener();
  }

  //是否开启扬声器
  // void _isSpeakPhone() {
  //   setState(() {
  //     speakPhone = !speakPhone;
  //   });
  //   _engine.setEnableSpeakerphone(speakPhone);
  // }
  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {});
  }

  //本页面即将销毁
  @override
  void dispose() async {
    if (null != timer) {
      timer.cancel();
      timer = null;
    }
    if (null != timerV) {
      timerV.cancel();
      timerV = null;
    }
    if (null != audioPlayer) {
      await audioPlayer.stop();
      audioPlayer = null;
    }
    // setState(() {});
    isActive = false;
    // answerReq(2, isReceive ? secondsPassed : 0, this.widget.channel, 1);
    // _onExit(context);
    super.dispose();
  }

  void initAgoreSdk() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(agore_appId));
    this._addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    _joinChannel();
    //初始化引擎
    // AgoraRtcEngine.create(agore_appId);
    //设置视频为可用 启用视频模块
    // AgoraRtcEngine.enableVideo();
    //每次需要原生视频都要调用_createRendererView
    // _createDrawView(0, (viewId) {
    //   //设置本地视图。 该方法设置本地视图。App 通过调用此接口绑定本地视频流的显示视图 (View)，并设置视频显示模式。
    //   // 在 App 开发中，通常在初始化后调用该方法进行本地视频设置，然后再加入频道。退出频道后，绑定仍然有效，如果需要解除绑定，可以指定空 (null) View 调用
    //   //该方法设置本地视频显示模式。App 可以多次调用此方法更改显示模式。
    //   //RENDER_MODE_HIDDEN(1)：优先保证视窗被填满。视频尺寸等比缩放，直至整个视窗被视频填满。如果视频长宽与显示窗口不同，多出的视频将被截掉
    //   // AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);

    //   //开启视频预览
    //   // AgoraRtcEngine.startPreview();
    //   //加入频道 第一个参数是 token 第二个是频道id 第三个参数 频道信息 一般为空 第四个 用户id
    //   _engine.joinChannel(null, widget.channel, null, 0);
    // });
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        isReceive = true;
        isActive = true;
        G.toast('已接通');
        stop();
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        // _removeRenderView(uid);
        _onExit(context);
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          isJoined = false;
          remoteUid.clear();
          // if (!isJoined) {
          //   _onExit(context);
          // }
        });
      },
    ));
  }

  //根据uid来获取session session为了视频布局需要
  VideoUserSession _getVideoUidSession(int uid) {
    //满足条件的第一个元素
    return _userSessions.firstWhere((userSession) {
      return userSession.uid == uid;
    });
  }

  //单个视频视图渲染
  Widget _videoView(view) {
    return Expanded(
      child: new Container(
        child: view,
      ),
    );
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(null, widget.channel, null, 0);
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {});
  }

  //退出频道 退出本页面
  void _onExit(BuildContext context) {
    _engine.leaveChannel();
    Navigator.pop(context);
  }

  // 中间部分
  Widget _middleToolBar(int hours, int minutes, int seconds) {
    //  ～/ 取整操作
    seconds = secondsPassed % 60;
    minutes = secondsPassed ~/ 60;
    hours = secondsPassed ~/ (60 * 60);
    timeVal = hours.toString().padLeft(2, '0') +
        ':' +
        minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
    return isReceive
        ? Container(
//      height: 30,
//      width: 117.5,
            margin: EdgeInsets.only(top: 400),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget>[
                Text(
                  timeVal,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  height: 117,
                  width: 117,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     color: rgba(21, 24, 30, 1)),
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 67, bottom: 12),
                  alignment: Alignment.center,
                  child: Card(
                    color: rgba(21, 24, 30, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      (null == this.widget.head_img ||
                              this.widget.head_img.isEmpty)
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
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                Text(
                  '正在等待对方接听…',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          );
  }

  //底部的菜单栏
  Widget _bottomToolBar() {
    //再中央
    return Container(
        alignment: Alignment.bottomCenter,
        //竖直方向相隔48
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //静音按钮
            //是否静音按钮
            //是否静音按钮
            GestureDetector(
              onTap: () {
                _switchMicrophone();
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
                          ),
                        ),
                  Container(
                    width: 72,
                    // height: 72,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 42, top: 12),
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
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      isActive = false;
                      answerReq(2, isReceive ? secondsPassed : 0,
                          this.widget.channel, 1);
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
            //前后摄像切换
            // Container(
            //   margin: EdgeInsets.only(left: 50),
            //   child: GestureDetector(
            //     onTap: () {
            //       _onChangeCamera();
            //     },
            //     child: Image.asset(
            //       isSwitch
            //           ? 'assets/images/icon_caram.png'
            //           : 'assets/images/icon_caram.png',
            //       width: 72,
            //       height: 72,
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                // _isSpeakPhone();
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
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 47),
                            child: Image.asset(
                              'assets/images/icon_voicespeak.png',
                              // width: 42,
                              // height: 42,
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
                            ),
                          ),
                    Container(
                      width: 72,
                      // height: 72,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 30, top: 12),
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return WillPopScope(
      child: Scaffold(
      backgroundColor: Colours.backbg,
      // appBar: VideoAppbar(title: '与 ' + widget.userName + ' 的视频通话'),
      body: Stack(
        children: <Widget>[
          _renderVideo(),
          Positioned(
              left: 0,
              right: 0,
              top: 40,
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  '与 ' + widget.userName + ' 的视频通话',
                  style: TextStyle(
                      color: rgba(255, 255, 255, 0.9),
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              )),
          // isReceive ? _topMineVideo() : Container(),
          _middleToolBar(hours, minutes, seconds),
          _bottomToolBar()
        ],
      ),
    ),
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

  _renderVideo() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.of(remoteUid.map(
                    (e) => Container(
                      width: 500,
                      height: 800,
                      // // alignment: Alignment.topRight,
                      // margin: EdgeInsets.only(right: 5, top: 60),
                      child: RtcRemoteView.SurfaceView(
                        uid: e,
                      ),
                    ),
              )),
            ),
          ),
        ),
        (isReceive) ? Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 145,
            height: 220,
            // alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 5, top: 60),
            child: RtcLocalView.SurfaceView(),
          ),
        ) : Container(),
      ],
    );
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

  play(String usrStr) async {
//    await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    await audioPlayer.play(usrStr, isLocal: true);
  }

  stop() async {
//    await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    await audioPlayer.stop();
    timerV.cancel();
    timerV = null;
    audioPlayer = null;
    setState(() {});
  }

  // @override
  // void deactivate() async {
  //   if (null != timerV) {
  //     timerV.cancel();
  //     timerV = null;
  //   }
  //   if (null != audioPlayer) {
  //     await audioPlayer.stop();
  //     audioPlayer = null;
  //   }
  //   // setState(() {});
  //   isActive = false;
  //   // answerReq(2, isReceive ? secondsPassed : 0, this.widget.channel, 1);
  //   _onExit(context);
  //   super.deactivate();
  // }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
  }

  //监听Bus events
  void _listen() {
    eventVideoBus.on<VideoEvent>().listen((event) {
      var timeOr = _prefs.getInt('time2');
      var timeVal = DateTime.now().millisecondsSinceEpoch;
      var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
      if (null == timeOr || timeListent > 1000) {
        _prefs.setInt('time2', timeVal);
        isActive = false;
        answerReq(2, isReceive ? secondsPassed : 0, this.widget.channel, 1);
        _onExit(context);
      }
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
