import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'chat/chat_page.dart';
import 'girldetailpage.dart';

class GrampphonePage extends StatefulWidget {
  String tk, mheadimgV;
  int genderV;
  GrampphonePage(this.tk, this.mheadimgV, this.genderV);
  @override
  State<StatefulWidget> createState() => _GrampphonePageState();
}

class _GrampphonePageState extends State<GrampphonePage> {
  bool isPlay = false;
  List<Voicelist> voiceList = [];
  Voicelist currVoice;
  AudioPlayer audioPlayer;
  final List<Image> _assetList = [Image.asset('assets/images/left_voice_1.png'), Image.asset('assets/images/left_voice_2.png'), Image.asset('assets/images/left_voice_3.png')];

  // 显示的 image
  int showIndex = 0;
  bool _disposed;
  int secondsPassed;
  int secondsPassed2 = -1;
  Timer timer;
  static const duration = const Duration(seconds: 1);
  bool isActive = false;

  @override
  void initState() {
    super.initState();
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
    getRadomVoice();
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
    // isPlay = true;
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
    // isPlay = false;
    // audioPlayer = null;
    setState(() {});
  }

  @override
  void deactivate() async {
    await audioPlayer.stop();
    audioPlayer = null;
    // setState(() {});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20),
          decoration: new BoxDecoration(
            // color: Colors.grey,
            // border: new Border.all(width: 2.0, color: Colors.transparent),
            // borderRadius: new BorderRadius.all(new Radius.circular(0)),
            image: new DecorationImage(
              fit: BoxFit.cover,
              image:  new AssetImage('assets/images/icon_gramobg.png'),
              //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
              // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
            ),
          ),
          child: SingleChildScrollView(
            // physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NRow(
                  color: Colors.transparent,
                  leftChild: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 8.9,
                      height: 16,
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/icon_whiteback.png',
                        width: 8.9,
                        height: 16,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  centerChild: Container(
                    margin: EdgeInsets.only(left: 110),
                    child: Text(
                      '邂逅留声机',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  height: 490,
                  width: 316,
                  child: Stack(alignment: Alignment.center, children: getCardList()),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 17,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text('滑动卡片切换下一位', style: TextStyle(color: rgba(255, 255, 255, 1), fontWeight: FontWeight.w400, fontSize: 12),),
                ),
                GestureDetector(
                  onTap: () {
                    if (null == currVoice || null == currVoice.isFollow || 0 == currVoice.isFollow) {
                      // 喜欢
                      followUserReq();
                    } else {
                      // 取消喜欢
                      cancelfollowUserReq();
                    }
                  },
                  child: Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    child: Image.asset(
                      (null == currVoice || null == currVoice.isFollow || 0 == currVoice.isFollow) ? 'assets/images/icon_whitelike.png' : 'assets/images/icon_redlike.png',
                      height: 44,
                      width: 44,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 撩一下
                    chatConv(context);
                  },
                  child: Container(
                    width: 223,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage('assets/images/icon_gamosure.png'),
                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 56),
                    child: Text(
                      '撩一下',
                      style: TextStyle(
                          color: rgba(69, 65, 103, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
  void removeThis(index) {
    setState(() {
      voiceList.removeAt(index);
      isPlay = false;
      stop();
    });
    if (voiceList.length == 0) {
      Future.delayed(Duration(seconds: 0), () {
        setState(() {
          getRadomVoice();
        });
      });
    }
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
  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  getCardItem(int index, Voicelist data) {
    currVoice = data;
    secondsPassed = data.voicetime;
    return GestureDetector(
      onTap: () {
        // 用户详情
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => GirlDetailPage(widget.tk, data.user_id, widget.genderV, widget.mheadimgV)),
        );
      },
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 160,
                height: 160,
                margin: EdgeInsets.only(top: 36, left: 50, right: 50),
                child: new CircleAvatar(
                    backgroundImage: NetworkImage((null == data.shopUser.userpic || data.shopUser.userpic.isEmpty) ? '' : data.shopUser.userpic),
                    radius: 50),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  data.shopUser.username,
                  style: TextStyle(
                      fontSize: 22,
                      color: rgba(69, 65, 103, 1),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                height: 30,
                margin: EdgeInsets.only(top: 15),
                child: Row(
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
                          (null == data || null == data.shopUser || null == data.shopUser.age || data.shopUser.age.isEmpty)
                              ? '未知'
                              : data.shopUser.age + '岁',
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
                          (null == data ||
                              data.shopUser.bodylength == null)
                              ? '未知'
                              : data.shopUser.bodylength,
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
                          (null == data ||
                              data.shopUser.path == null)
                              ? '未知'
                              : data.shopUser.path,
                          style: TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  isPlay = !isPlay;
                  if (isPlay) {
                    play(data.url);
                  } else {
                    stop();
                  }
                },
                child: Container(
                  width: 223,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new AssetImage('assets/images/icon_phonevoicebg.png'),
                      //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                      // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 22, width: 22,
                        margin: EdgeInsets.only(left: 20, right: 10, top: 5),
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
                ),
              ),
              (null == data.userPics || data.userPics.isEmpty) ? Container(
                height: 56,
                width: 56,
              ) : (1 == data.userPics.length) ? Container(
                height: 36,
                width: 36,
                margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.network(data.userPics[0].url, height: 36,
                  width: 36, fit: BoxFit.fill,),
              ) : (2 == data.userPics.length) ?  Container(
                margin: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),),
                      child: Image.network(data.userPics[0].url, height: 36,
                        width: 36, fit: BoxFit.fill,),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.network(data.userPics[1].url, height: 36,
                        width: 36, fit: BoxFit.fill,),
                    ),
                  ],
                ),
              ) : Container(
                margin: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),),
                      child: Image.network(data.userPics[0].url, height: 36,
                        width: 36, fit: BoxFit.fill,),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.network(data.userPics[1].url, height: 36,
                        width: 36, fit: BoxFit.fill,),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.network(data.userPics[2].url, height: 36,
                        width: 36, fit: BoxFit.fill,),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _item(
      Widget loading, {
        double width = 60,
        double height = 60,
      }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                height: height,
                width: width,
                child: loading,
              ),
            ),
          );
        }));
      },
      child: Center(
        child: Container(
          height: height,
          width: width,
          child: loading,
        ),
      ),
    );
  }

  List<Widget> getCardList() {
    List<Widget> cardList = [];
    var length = voiceList.length;
    if (length > 5) {
      length = 5;
    }
    for (int i = length - 1; i >= 0; i--) {
      cardList.add(Positioned.fill(
        child: UnconstrainedBox(
            child: Container(
              child: Draggable(
                  onDragEnd: (drag) {
                    // print("#### ${drag.velocity.pixelsPerSecond} ${drag.offset}");
                    ///往下斜着拖
                    if (drag.offset.dx.abs() >
                        MediaQuery.of(context).size.width / 2 ||
                        drag.offset.dx < -MediaQuery.of(context).size.width / 4 ||
                        drag.offset.dy.abs() >
                            MediaQuery.of(context).size.height / 2) {
                      removeThis(i);
                    }
                  },
                  childWhenDragging: Container(),
                  feedback: getCardItem(i, voiceList[i]),
                  child: getCardItem(i, voiceList[i])),
              margin: EdgeInsets.only(
                  top: (i < 5) ? 10 * i.toDouble() : 40,
                  left: (i < 5) ? 8 * i.toDouble() : 32),
            )),
      ));
    }
    return cardList;
  }

  /// 喜欢
  followUserReq() async {
    try {
      var res = await G.req.shop.followUserReq(
          tk: widget.tk,
          follow_id: currVoice.shopUser.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          getRadomVoice();
        }
      }
    } catch (e) {}
  }

  /// 取消喜欢
  cancelfollowUserReq() async {
    try {
      var res = await G.req.shop.cancelfollowUserReq(
          tk: widget.tk,
          follow_id: currVoice.shopUser.id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          getRadomVoice();
        }
      }
    } catch (e) {}
  }

  /// 获取留声机数据
  getRadomVoice() async {
    try {
      var res = await G.req.shop.getUserRandomVoice(
          tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          voiceList.clear();
          voiceList.addAll(VoicelistParent.fromJson(res.data).data);
          setState(() {
          });
        }
      }
    } catch (e) {}
  }

  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(currVoice.shopUser.phone);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new ChatPage(
            widget.tk,
            widget.genderV,
            currVoice.id,
            currVoice.shopUser.username,
            currVoice.shopUser.userpic,
            (null == currVoice.shopUser || null == currVoice.shopUser.priimset) ? '' : currVoice.shopUser.priimset.split('Q')[0],
            widget.mheadimgV,
            conv
        ),
      ),
    ).then((value) {
    });
    // Navigator.of(context).pushNamed(
    //   '/chat',
    //   arguments: [currVoice.shopUser.username, conv],
    // ).then((value) {
    // });
  }
}