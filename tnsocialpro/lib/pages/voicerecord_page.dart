import 'dart:io';

import 'package:color_dart/rgba_color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/voicetemple/data.dart';
import 'package:tnsocialpro/event/modifyfeedback_event.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/utils/constants.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';

typedef _Fn = void Function();



const theSource = AudioSource.microphone;

class VoiceRecordPage extends StatefulWidget {
  String tk;
  int user_id;
  List<VoiceTemple> voiceTempllists;
  VoiceRecordPage(this.tk, this.user_id, this.voiceTempllists);
  _VoiceRecordPageState createState() => _VoiceRecordPageState();
}

class _VoiceRecordPageState extends State<VoiceRecordPage> {

  // var _imgPath;
  int voiceState = 0;
  // bool isPlay = false;
  // List<String> randomWords = [];
  // List<VoiceTemple> voiceTempllists = [];
  int position = 0;
  String currentText;

  // 录音
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  int secondsPassed = 0, seconds, minutes;
  String timeVal;
  bool isActive = false;
  static const duration = const Duration(seconds: 1);
  Timer timer;
  int currentShowTime = 0;

  void handleTick() {
    setState(() {
      secondsPassed = secondsPassed + 1; //需要更新UI
    });
  }

  @override
  Widget build(BuildContext context) {
    //  ～/ 取整操作
    seconds = secondsPassed % 60;
    minutes = secondsPassed ~/ 60;
    // hours = secondsPassed ~/ (60 * 60);
    timeVal = minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
    _listen();
    return Scaffold(
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: customAppbar(
            context: context, borderBottom: false, title: '录制声音'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 400,
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                decoration: new BoxDecoration(
                  // color: Colors.grey,
                  // border: new Border.all(width: 2.0, color: Colors.transparent),
                  // borderRadius: new BorderRadius.all(new Radius.circular(0)),
                  image: new DecorationImage(
                    image: new AssetImage('assets/images/icon_voicerecordbg.png'),),),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 30, top: 15),
                            child: Text('参考文段',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: rgba(255, 255, 255, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                          GestureDetector(
                            child: Container(
                              height: 60,
                              margin: EdgeInsets.only(right: 30, top: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    margin: EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      'assets/images/icon_randomchoose.png',
                                      height: 16,
                                      width: 16,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Text('换一换',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: rgba(255, 255, 255, 1),
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 换一换
                              position ++;
                              if (position == widget.voiceTempllists.length) {
                                position = 0;
                              }
                              currentText = widget.voiceTempllists[position].voicetemple;
                              setState(() {
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        child: Text((null == currentText || currentText.isEmpty) ? '' : currentText,
                            maxLines: 9,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 25,
                                color: rgba(255, 255, 255, 1),
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: 22,
                  width: double.infinity,
                  child: Text((1 == voiceState) ? '点击试听' : (0 == voiceState) ? '' : (3 == voiceState) ? '录制时间少于5s，请重新录制' : timeVal, style: TextStyle(color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500, fontSize: 15),),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (1 == voiceState) ? GestureDetector(
                        onTap: () {
                          // 重录
                          voiceState = 0;
                          if (_mPlayer.isPlaying) {
                            stopPlayer();
                          }
                          setState(() {
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              margin: EdgeInsets.only(left: 50),
                              alignment: Alignment.center,
                              child: Image.asset('assets/images/icon_voiceset.png', width: 36,
                                height: 36, fit: BoxFit.cover,),
                            ),
                            Container(
                              // width: 36,
                              height: 26,
                              margin: EdgeInsets.only(left: 50),
                              alignment: Alignment.center,
                              child: Text('重录',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w400)),)
                          ],
                        )
                    ) : Container(),
                    (1 == voiceState) ? GestureDetector(
                      onTap: () {
                        // 播放
                        if (_mPlayer.isPlaying) {
                          stopPlayer();
                        } else {
                          play();
                        }
                        // getPlaybackFn();
                      },
                      child: Container(
                        width: 66,
                        height: 66,
                        margin: EdgeInsets.only(bottom: 32, top: 20, left: 55, right: 55),
                        alignment: Alignment.center,
                        child: Image.asset(_mPlayer.isPlaying ? 'assets/images/icon_vplay.png' : 'assets/images/icon_vpause.png', width: 66,
                          height: 66, fit: BoxFit.cover,),
                      ),
                    ) : GestureDetector(
                      onLongPressStart: (e) async {
                        // 长按录制声音
                        voiceState = 2;
                        if (timer == null) {
                          timer = Timer.periodic(duration, (Timer t) {
                            handleTick();
                          });
                        }
                        record();
                      },
                      onLongPressUp: () async {
                        // 结束录制声音
                        if (secondsPassed < 5) {
                          voiceState = 3;
                        } else {
                          voiceState = 1;
                        }
                        if (null != timer) {
                          timer.cancel();
                          timer = null;
                        }
                        currentShowTime = secondsPassed;
                        secondsPassed = 0;
                        setState(() {});
                        stopRecorder();
                      },
                      child: Container(
                        width: 76,
                        height: 76,
                        margin: EdgeInsets.only(bottom: 32, top: 20, left: 55, right: 55),
                        alignment: Alignment.center,
                        // child: CircularProgressIndicator(
                        //   value: this._value,
                        //   backgroundColor: Colors.cyanAccent,
                        //   strokeWidth: 6.0,
                        //   valueColor: new AlwaysStoppedAnimation<Color>(rgba(209, 99, 242, 0.8)),
                        // ),
                        child: (2 == voiceState) ? CircularPercentIndicator(
                            radius: 76.0,
                            lineWidth: 10.0,
                            animation: true,
                            animationDuration: 20000,//动画时长
                            percent: 1,//设置比例
                            center: Image.asset('assets/images/icon_vplay.png', width: 66,
                              height: 66, fit: BoxFit.cover,),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent,
                            linearGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                // Color.fromRGBO(209, 99, 242, 0.1),
                                Color.fromRGBO(209, 99, 242, 0.8),
                                Color.fromRGBO(209, 99, 242, 0.8)
                              ],
                            )) : Image.asset((0 == voiceState || 3 == voiceState) ? 'assets/images/icon_voicerecord.png' : 'assets/images/icon_vplay.png', width: 66,
                          height: 66, fit: BoxFit.cover,),
                      ),
                    ),
                    (1 == voiceState) ? GestureDetector(
                        onTap: () {
                          // 完成
                          if (_mPlayer.isPlaying) {
                            stopPlayer();
                          }
                          G.loadingomm.show(context);
                          _fileUplodImg(_mPath);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              margin: EdgeInsets.only(right: 50),
                              alignment: Alignment.center,
                              child: Image.asset('assets/images/icon_voicefinish.png', width: 36,
                                height: 36, fit: BoxFit.cover,),
                            ),
                            Container(
                              // width: 36,
                              height: 26,
                              margin: EdgeInsets.only(right: 50),
                              alignment: Alignment.center,
                              child: Text('完成',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w400)),)
                          ],
                        )
                    ) : Container(),
                  ],
                ),
                (0 == voiceState || 3 == voiceState) ? Container(
                  alignment: Alignment.bottomCenter,
                  height: 17,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 67),
                  child: Text('按住录音，每次录音不得少于5s，不得大于20s', style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 12),),
                ) : Container(
                  alignment: Alignment.bottomCenter,
                  height: 17,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 67),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    // randomWords.add('你的教法就是你的活法”这些对于课堂教学深刻的感悟，对语文写作虔诚的膜拜，对美好生活的积极心态，与我都是晨钟暮鼓，是我作为年轻教师以后要在教学生涯追随的教法，更是我在未来要选择的活法。王君老师的课，为我铸就了一所房，在那个在叫“梦想”的乐园里，我便快乐的茁壮成长，然后开出一朵一朵花来');
    // randomWords.add('人生固然艰辛，磨难重重，就像贝琳达在追梦的路上有一双大脚丫成为了她的绊脚石，可生活还告诉我们你脚下的绊脚石也许会因为你的勤奋，因为你的执着变成你成功路上的垫脚石。');
    // randomWords.add('你从雪国走来，冰霜是你的风采；你向诗歌王国走去，诗意是你的气概；你用“杨柳依依雨雪霏霏”的独思，唱出游子内心的柔软；');
    // randomWords.add('“生命是一条河流，需要流动，需要吸纳”。在学习中成长，在成长中实践，每次学习就是自我提升和修炼的机会，生命亦是如此。');
    // randomWords.add('我愿做一个寻梦的行者，背起时间的行囊，用毅力和热情划着木桨，泛舟以航，驶向诗和远方！筑梦，寻梦。');
    // randomWords.add('感受生命的渺小与博大，感受苍穹的无垠，我们终会在生命的道场得到提升和修炼，走向完美的人生。');
    // randomWords.add('我们的甜蜜，谁都不能替，我们不是在玩爱情的游戏 爱的真是深，爱的真是真，爱你直到终点是永远不会分。');
    // currentText = randomWords[position];
    if (null == widget.voiceTempllists || widget.voiceTempllists.isEmpty) {
      getVoicetemplelist();
    } else {
      currentText = widget.voiceTempllists[position].voicetemple;
    }
    super.initState();
  }


  /// 获取音频模版
  getVoicetemplelist() async {
    try {
      var res = await G.req.shop.getVoicetemplelist(
          tk: widget.tk
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            widget.voiceTempllists.clear();
            widget.voiceTempllists.addAll(VoiceTempleParent.fromJson(res.data).data);
            currentText = widget.voiceTempllists[position].voicetemple;
          });
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder.startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        _mPath = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    _mPlayer
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          setState(() {});
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }
    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return null;
    }
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  //监听Bus events
  void _listen() {
    modifyFeedbackBus.on<ModifyFeedEvent>().listen((event) {
      setState(() {
      });
    });
  }

  /// 上传音频
  updateHeadimgInfo(String voiceUrl) async {
    // if (null == picUrl || picUrl.isEmpty) {
    //   G.toast('请选择用户头像');
    //   return;
    // }
    try {
      var res = await G.req.shop.updateUservoiceReq(
          tk: this.widget.tk,
          url: voiceUrl,
          user_id: widget.user_id,
          voicetime: currentShowTime
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      G.loadingomm.hide(context);
      int code = data['code'];
      if (20000 == code) {
        myvoiceBus.fire(new MyVoiceEvent(''));
        Navigator.pop(context);
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
    var name = filePath.contains("/") ? filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length) : filePath.substring(0, filePath.length - 4);

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
    }
  }
}