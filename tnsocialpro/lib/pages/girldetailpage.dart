
import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/pages/picturelist_page.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'dart:io';
import 'AudioCallPage.dart';
import 'VideoCallPage.dart';
import 'chat/chat_page.dart';
import 'login_index.dart';

class GirlDetailPage extends StatefulWidget {
  String tk, mheadimgV;
  int id, gender;
  GirlDetailPage(this.tk, this.id, this.gender, this.mheadimgV);

  _GirlDetailPageState createState() => _GirlDetailPageState();
}

class _GirlDetailPageState extends State<GirlDetailPage> {
  List<Picturelist> pictureList = [];
  List<Voicelist> voiceList = [];
  Voicelist showVoice;
  MyInfoData myInfoData;
  int likestate = 0;
  AudioPlayer audioPlayer;
  bool isPlay = false;
  SharedPreferences _prefs;
  bool _disposed;
  int secondsPassed;
  int secondsPassed2 = -1;
  Timer timer;
  static const duration = const Duration(seconds: 1);
  bool isActive = false;
  final List<Image> _assetList = [Image.asset('assets/images/left_voice_1.png'), Image.asset('assets/images/left_voice_2.png'), Image.asset('assets/images/left_voice_3.png')];

  // 显示的 image
  int showIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
    });
    _disposed = false;
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    Future.delayed(Duration(milliseconds: 500), () {
      _updateImage(_assetList.length, Duration(milliseconds: 500));
    });
    audioPlayer = AudioPlayer(/*mode: PlayerMode.MEDIA_PLAYER*/);
    getUserDetail();
    getFollowUserState();
    getUserPicture();
    getUserVoice();
  }

  _updateImage(int count, Duration millisecond) {
    Future.delayed(millisecond, () {
      // if (_disposed) return;
      // if (0 == secondsPassed2) return;
      setState(() {
        showIndex = _assetList.length - count--;
      });
      if (count < 1) {
        count = _assetList.length;
      }
      _updateImage(count, millisecond);
      setState(() {
      });
    });
  }

  void handleTick() {
    if (isActive) {
      if (secondsPassed > 0) {
        if (-1 == secondsPassed2) {
          secondsPassed2 = secondsPassed;
        } else {
          if (secondsPassed2 > 0) {
            secondsPassed2 = secondsPassed2 - 1;
          }
        }
      }//需要更新UI
      setState(() {
      });
    }
  }

  play(String uslStr) async {
//    await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    if (0 == secondsPassed2) {
      secondsPassed2 = secondsPassed;
    }
    await audioPlayer.play(uslStr, isLocal: false);
    isActive = true;
    setState(() {});
  }

  stop() async {
//    await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    await audioPlayer.stop();
    isActive = false;
    // audioPlayer = null;
    setState(() {});
  }

  @override
  void deactivate() async {
    if (null != audioPlayer) {
      await audioPlayer.stop();
      audioPlayer = null;
    }
    // setState(() {});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rgba(255, 255, 255, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: rgba(255, 255, 255, 1),
              margin: EdgeInsets.only(bottom: 80),
              // alignment: Alignment.center,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 顶部
                  Container(
                    height: 330,
                    width: double.infinity,
                    // alignment: Alignment.topRight,
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                      // border: new Border.all(width: 2.0, color: Colors.transparent),
                      borderRadius: new BorderRadius.all(new Radius.circular(0)),
                      image: new DecorationImage(
                          image: new NetworkImage((null == myInfoData || null == myInfoData.userpic || myInfoData.userpic.isEmpty) ? '' : myInfoData.userpic),
                          fit: BoxFit.cover
                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 8.9,
                              height: 16,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 50, left: 20),
                              child: Image.asset(
                                'assets/images/icon_whiteback.png',
                                width: 8.9,
                                height: 16,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),),
                        Container(
                          height: 110,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (0 == likestate) {
                                    // 喜欢
                                    followUserReq();
                                  } else {
                                    // 取消喜欢
                                    cancelfollowUserReq();
                                  }
                                },
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 30),
                                  child: Image.asset(
                                    (0 == likestate) ? 'assets/images/icon_likenormal.png' : 'assets/images/icon_likechoose.png',
                                    width: 46,
                                    height: 46,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              NRow(
                                  color: Colors.transparent,
                                  margin: EdgeInsets.only(bottom: 10),
                                  leftChild: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                        margin: EdgeInsets.only(left: 15),
                                        child: Text(
                                            (null == myInfoData || null == myInfoData.age || myInfoData.age.isEmpty)
                                                ? '未知'
                                                : myInfoData.age + '岁',
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
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                            (null == myInfoData ||
                                                myInfoData.bodylength == null || myInfoData.bodylength.isEmpty)
                                                ? '未知'
                                                : myInfoData.bodylength + 'cm',
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
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                            (null == myInfoData ||
                                                myInfoData.path == null || myInfoData.path.isEmpty)
                                                ? '未知'
                                                : myInfoData.path,
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                  rightChild: (null == showVoice) ? Container() : GestureDetector(
                                    onTap: () {
                                      isPlay = !isPlay;
                                      if (isPlay) {
                                        play(showVoice.url);
                                      } else {
                                        stop();
                                      }
                                    },
                                    child: Container(
                                      width: 117,
                                      height: 35,
                                      alignment: Alignment.centerLeft,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage('assets/images/icon_phonevoicebg.png'),
                                          //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                                          // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(right: 5, bottom: 10),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 22, width: 22,
                                            margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                                            child: (secondsPassed2 > 0) ? IndexedStack(
                                              index: showIndex,
                                              children: _assetList,
                                            ) : Image.asset('assets/images/left_voice_3.png', height: 22, width: 22, fit: BoxFit.cover,),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 8),//voicetime
                                            child: Text((-1 == secondsPassed2 ? '0' : secondsPassed2.toString()) + 's/' + secondsPassed.toString() + 's',
                                                style: TextStyle(
                                                    fontSize: 15, color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      // child: Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //     Container(
                                      //       height: 14, width: 12,
                                      //       margin: EdgeInsets.only(left: 15, right: 5, top: 5),
                                      //       child: Image.asset('assets/images/icon_voicetip.png', height: 14, width: 12, fit: BoxFit.cover,),
                                      //     ),
                                      //     Container(
                                      //       margin: EdgeInsets.only(top: 5),
                                      //       child: Text('15s',
                                      //           style: TextStyle(
                                      //               fontSize: 14, color: rgba(255, 255, 255, 1), fontWeight: FontWeight.w400)),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: rgba(255, 255, 255, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                              )),
                          alignment: Alignment.bottomCenter,
                          // color: rgba(239, 240, 242, 1),
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: rgba(255, 255, 255, 1),
                    // margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 23),
                                    child: Text((null == myInfoData ||
                                        myInfoData.username == null || myInfoData.username.isEmpty)
                                        ? '0'
                                        : myInfoData.username.toString(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 16,
                                    width: 16,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Image.asset(
                                      (null == myInfoData || null == myInfoData.gender || 1 == myInfoData.gender || 0 == myInfoData.gender) ? 'assets/images/icon_male.png' : 'assets/images/icon_female.png',
                                      height: 16,
                                      width: 16,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ]),
                            (null == myInfoData || null == myInfoData.type || "3" == myInfoData.type || "4" == myInfoData.type) ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(left: 23),
                                    child: Text('离线',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                                      color: Colors.grey, // 底色
                                      shape: BoxShape.circle, // 默认值也是矩形
                                    ),
                                    margin: EdgeInsets.only(left: 5, right: 20),
                                    height: 6,
                                    width: 6,
                                    alignment: Alignment.center,
                                  ),
                                ]) : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(left: 23),
                                    child: Text('在线',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                                      color: rgba(38, 231, 236, 1), // 底色
                                      shape: BoxShape.circle, // 默认值也是矩形
                                    ),
                                    margin: EdgeInsets.only(left: 5, right: 20),
                                    height: 6,
                                    width: 6,
                                    alignment: Alignment.center,
                                  ),
                                ]),
                          ],
                        ),
                        (null == myInfoData || null == myInfoData.voiceset || myInfoData.voiceset.isEmpty) ? Container() : Container(
                          height: 36,
                          width: 200,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 38, top: 10),
                          decoration: BoxDecoration(
                              color: rgba(245, 245, 245, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(18),
                              )),
                          child: Row(
                            children: [
                              Container(
                                height: 13,
                                width: 11,
                                margin: EdgeInsets.only(left: 17),
                                child: Image.asset(
                                  'assets/images/icon_detailvoice.png',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text('语音',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                              (null != myInfoData && myInfoData.voiceset.isNotEmpty) ? Container(
                                margin: EdgeInsets.only(left: 23),
                                child: Text(myInfoData.voiceset.split('B')[0],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: rgba(234, 117, 187, 1),
                                        fontWeight: FontWeight.w500)),
                              ) : Container(),
                              (null != myInfoData && myInfoData.voiceset.isNotEmpty) ? Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text('甜甜券/分钟',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ) : Container(),
                            ],
                          ),
                        ),
                        (null == myInfoData || null == myInfoData.videoset || myInfoData.videoset.isEmpty) ? Container() : Container(
                          height: 36,
                          width: 200,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 38, top: 10),
                          decoration: BoxDecoration(
                              color: rgba(245, 245, 245, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(18),
                              )),
                          child: Row(
                            children: [
                              Container(
                                height: 13,
                                width: 11,
                                margin: EdgeInsets.only(left: 17),
                                child: Image.asset(
                                  'assets/images/icon_detailvideo.png',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text('视频',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                              (null != myInfoData && myInfoData.videoset.isNotEmpty) ? Container(
                                margin: EdgeInsets.only(left: 23),
                                child: Text(myInfoData.videoset.split('B')[0],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: rgba(234, 117, 187, 1),
                                        fontWeight: FontWeight.w500)),
                              ) : Container(),
                              (null != myInfoData && myInfoData.videoset.isNotEmpty) ? Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Text('甜甜券/分钟',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ) : Container(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // 她的照片
                            if (null == myInfoData) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginIndex()));
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new PictureListPage(
                                          widget.tk, widget.id)));
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 35),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 230,
                                  margin: EdgeInsets.only(left: 38),
                                  child: Text('她的照片',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w500)),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text((null == pictureList || pictureList.isEmpty) ? '0' : pictureList.length.toString(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      margin: EdgeInsets.only(right: 38, left: 10),
                                      child: Image.asset(
                                        'assets/images/icon_right.png',
                                        height: 16,
                                        width: 8.9,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // 她的照片
                            if (null == myInfoData) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginIndex()));
                            } else {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new PictureListPage(
                                          widget.tk, widget.id)));
                            }
                          },
                          child: (null == pictureList || pictureList.isEmpty) ? Container() : (1 == pictureList.length) ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Container(
                              height: 122,
                              width: 92,
                              margin: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.network(pictureList[0].url, height: 122,
                                width: 92, fit: BoxFit.cover,),
                            ),
                          ) : (2 == pictureList.length) ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 122,
                                  width: 92,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),),
                                  child: Image.network(pictureList[0].url, height: 122,
                                    width: 92, fit: BoxFit.cover,),
                                ),
                                Container(
                                  height: 122,
                                  width: 92,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.network(pictureList[1].url, height: 122,
                                    width: 92, fit: BoxFit.cover,),
                                ),
                              ],
                            ),
                          ) : Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 122,
                                  width: 92,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),),
                                  child: Image.network(pictureList[0].url, height: 122,
                                    width: 92, fit: BoxFit.cover,),
                                ),
                                Container(
                                  height: 122,
                                  width: 92,
                                  margin: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.network(pictureList[1].url, height: 122,
                                    width: 92, fit: BoxFit.cover,),
                                ),
                                Container(
                                  height: 122,
                                  width: 92,
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.network(pictureList[2].url, height: 122,
                                    width: 92, fit: BoxFit.cover,),
                                ),
                              ],
                            ),
                          ),),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 38),
                                child: Text('标签',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 38),
                                child: Text((null == myInfoData || null == myInfoData.signinfo || myInfoData.signinfo.isEmpty) ? '' : myInfoData.signinfo,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 38, top: 30),
                          child: Text('自我介绍',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 38, top: 19, bottom: 9),
                          child: Text((null == myInfoData || null == myInfoData.myselfintro || myInfoData.myselfintro.isEmpty) ? '' : myInfoData.myselfintro,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w400)),
                        ),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 30),
                // margin: EdgeInsets.only(top: 30, bottom: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 1V1语音聊天
                        if (null != myInfoData) {
                          onAudio(context, myInfoData.id, myInfoData.username, myInfoData.userpic);
                        }
                      },
                      child: Container(
                        height: 44,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        // decoration: new BoxDecoration(
                        //   image: new DecorationImage(
                        //     image: new AssetImage('assets/images/icon_girldetailimbg.png'),
                        //     fit: BoxFit.cover
                        //     //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        //     // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                        //   ),
                        // ),
                        decoration: BoxDecoration(
                            color: rgba(69, 65, 103, 1),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: Text('1V1语音',
                            style: TextStyle(
                                fontSize: 15,
                                color: rgba(255, 255, 255, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 1V1视频聊天
                        if (null != myInfoData) {
                          onVideo(context, myInfoData.id, myInfoData.username, myInfoData.userpic);
                        }
                      },
                      child: Container(
                        height: 44,
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        // decoration: new BoxDecoration(
                        //   image: new DecorationImage(
                        //     image: new AssetImage('assets/images/icon_girldetailimbg.png'),
                        //     fit: BoxFit.cover
                        //     //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        //     // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                        //   ),
                        // ),
                        decoration: BoxDecoration(
                            color: rgba(69, 65, 103, 1),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: Text('1V1视频',
                            style: TextStyle(
                                fontSize: 15,
                                color: rgba(255, 255, 255, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    AButton.normal(
                        height: 44,
                        width: 74,
                        plain: true,
                        bgColor: rgba(255, 255, 255, 1),
                        borderColor: rgba(69, 65, 103, 1),
                        borderRadius: BorderRadius.circular(27.5),
                        child: Text(
                          '聊天',
                          style: TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        color: rgba(255, 255, 255, 1),
                        onPressed: () {
                          //聊天
                          chatConv(context);
                        }),
                  ],
                ),
              ))
        ],
      )
    );
  }

  /// 获取用户详情
  getUserDetail() async {
    try {
      var res = await G.req.shop.getUserDetailReq(
        tk: widget.tk,
        id: widget.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
            visitUserReq();
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

  /// 获取喜欢状态
  getFollowUserState() async {
    try {
      var res = await G.req.shop.getFollowUserStateReq(
        tk: widget.tk,
        follow_id: widget.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        likestate = res.data['data'];
        setState(() {
        });
      }
    } catch (e) {}
  }

  /// 喜欢
  followUserReq() async {
    try {
      var res = await G.req.shop.followUserReq(
          tk: widget.tk,
          follow_id: widget.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          getFollowUserState();
        }
      }
    } catch (e) {}
  }

  /// 取消喜欢
  cancelfollowUserReq() async {
    try {
      var res = await G.req.shop.cancelfollowUserReq(
          tk: widget.tk,
          follow_id: widget.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          getFollowUserState();
        }
      }
    } catch (e) {}
  }

  /// 获取用户图片
  getUserPicture() async {
    try {
      var res = await G.req.shop.getUserPictureReq(
          tk: widget.tk,
          user_id: widget.id
      );
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

  /// 获取用户音频
  getUserVoice() async {
    try {
      var res = await G.req.shop.getUserVoiceReq(
          tk: widget.tk,
          user_id: widget.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          voiceList.clear();
          voiceList.addAll(VoicelistParent.fromJson(res.data).data);
          for (Voicelist voiceli in voiceList) {
            if(1 == voiceli.showflag) {
              showVoice = voiceli;
              secondsPassed = voiceli.voicetime;
            }
          }
          setState(() {
          });
        }
      }
    } catch (e) {}
  }

  /**
   * 聊天
   */
  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(myInfoData.phone);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new ChatPage(
            widget.tk,
            widget.gender,
            myInfoData.id,
            myInfoData.username,
            myInfoData.userpic,
            (null == myInfoData.priimset) ? '' : myInfoData.priimset.split('B')[0],
            widget.mheadimgV,
            conv
        ),
      ),
    ).then((value) {
    });
    // Navigator.of(context).pushNamed(
    //   '/chat',
    //   arguments: [myInfoData.username, conv],
    // ).then((value) {
    // });
  }

  /**
   * 语音聊天
   */
  onAudio(BuildContext context, int uid, String name, String head_img) async {
    Future.delayed(Duration.zero, () async {
      // if (Platform.isIOS) {
        await Permission.storage.request();
        await Permission.microphone.request();
        //如果授权同意
        callReq(context, 0, uid, name, head_img);
      // } else {
      //   bool isCameraPermiss = await Permission.camera.request().isGranted;
      //   bool isAudioPermiss = await Permission.microphone.request().isGranted;
      //   if (isCameraPermiss && isAudioPermiss) {
      //     //如果授权同意
      //     callReq(context, 0, uid, name, head_img);
      //   } else {
      //     openAppSettings();
      //   }
      // }
    });
  }

  /**
   * 视频聊天
   */
  onVideo(BuildContext context, int uid, String name, String head_img) async {
    Future.delayed(Duration.zero, () async {
      // if (Platform.isIOS) {
        await Permission.storage.request();
        await Permission.camera.request();
        await Permission.microphone.request();
        //如果授权同意
        callReq(context, 1, uid, name, head_img);
      // } else {
      //   bool isCameraPermiss = await Permission.camera.request().isGranted;
      //   bool isAudioPermiss = await Permission.microphone.request().isGranted;
      //   if (isCameraPermiss && isAudioPermiss) {
      //     //如果授权同意
      //     callReq(context, 1, uid, name, head_img);
      //   } else {
      //     openAppSettings();
      //   }
      // }
    });
  }

  // 视频呼入
  void callReq(BuildContext context, int type, int uid, String name,
      String head_img) async {
    try {
      var res = await G.req.shop.callReq(tk: widget.tk, type: type, uid: uid, utype: (1 == widget.gender) ? 0 : 1);
      if (res.data != null) {
        String msg = res.data['msg'];
        G.toast(msg);
        String channel = res.data['data']['channel'];
        if (0 == type) {
          // 语音
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new AudioCallPage(
                //频道写死，为了方便体验
                userName: name,
                channel: channel,
                tk: widget.tk,
                head_img: head_img,
                uid: uid,
              ),
            ),
          );
        } else {
          // 视频
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new VideoCallPage(
                //频道写死，为了方便体验
                userName: name,
                channel: channel,
                tk: widget.tk,
                head_img: head_img,
                uid: uid,
              ),
            ),
          );
        }
      }
    } catch (e) {}
  }

  /// 来访
  visitUserReq() async {
    try {
      int account_id = _prefs.getInt('account_id');
      var res = await G.req.shop.visitUserReq(
          tk: this.widget.tk,
          follow_id: widget.id,
          user_id: account_id
      );

      var data = res.data;

      if (data == null) return null;
      int code = data['code'];
      if (20000 == code) {
      }
    } catch (e) {
    }
  }
}