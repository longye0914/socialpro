import 'package:audioplayer/audioplayer.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/data/voicetemple/data.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/pages/voicerecord_page.dart';
import 'package:tnsocialpro/utils/JhPickerTool.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/bottom_sheet.dart';
import 'package:tnsocialpro/widget/row_noline.dart';

class MyvoicePage extends StatefulWidget {
  String tk;
  int user_id;
  MyvoicePage(this.tk, this.user_id);

  _MyvoicePageState createState() => _MyvoicePageState();
}

class _MyvoicePageState extends State<MyvoicePage> {
  List<Voicelist> voiceList = [];
  int idNow;
  var _imgPath;
  List<VoiceTemple> voiceTempllists = [];

  AudioPlayer audioPlayer;
  // int currPlay = 0;
  // bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: rgba(255, 255, 255, 1),
        decoration: new BoxDecoration(
        // color: Colors.grey,
        // border: new Border.all(width: 2.0, color: Colors.transparent),
        // borderRadius: new BorderRadius.all(new Radius.circular(0)),
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new AssetImage('assets/images/icon_myvoicebg.png'),),),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 35, left: 15, right: 15),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              myinfolistBus.fire(new MyinfolistEvent(true));
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
                          Container(
                            child: Text(
                              '我的声音',
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.topCenter,
                      height: 20,
                      width: double.infinity,
                      child: Text('录制的声音将展示在个人主页和资料卡中哦~', style: TextStyle(color: rgba(255, 255, 255, 1), fontWeight: FontWeight.w400, fontSize: 12),),
                    ),
                    // 声音列表
                    Container(
                      width: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          _buildWidget(context, voiceList)
                          // CardVoicelist(
                          //   articleData: voiceList,
                          //   tk: this.widget.tk,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 17,
                      width: double.infinity,
                      child: Text('每人可以录制5段声音哦~', style: TextStyle(color: rgba(255, 255, 255, 1), fontWeight: FontWeight.w400, fontSize: 12),),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 录制声音
                        if (voiceList.length >= 5) {
                          Fluttertoast.showToast(msg: '每人可以录制5段声音哦~');
                          return;
                        }
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new VoiceRecordPage(widget.tk, widget.user_id, voiceTempllists)));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.only(bottom: 56, top: 20, left: 42, right: 42),
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage((voiceList.length >= 5) ? 'assets/images/icon_orderunfinish.png' : 'assets/images/icon_orderfinished.png'),
                            //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                            // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                          ),
                        ),
                        child: Text(
                          '录制声音',
                          style: TextStyle(
                              color: (voiceList.length >= 5) ? rgba(150, 148, 166, 1) : rgba(69, 65, 103, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ));
  }

  Widget _buildWidget(BuildContext context, List<Voicelist> articleData) {
    List<Widget> mGoodsCard = [];
    Widget content;
    for (int i = 0; i < articleData.length; i++) {
      // VoiceCard(
      //     myInfoData: articleData[i],
      //     tk: widget.tk,
      //     index: i,
      //     idNow: idNow
      // )
      mGoodsCard.add(Container(
        height: 90,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
              decoration: new BoxDecoration(
                // color: Colors.grey,
                // border: new Border.all(width: 2.0, color: Colors.transparent),
                // borderRadius: new BorderRadius.all(new Radius.circular(0)),
                image: new DecorationImage(
                  image: new AssetImage((null == articleData[i].isPlay || 0 == articleData[i].isPlay) ? 'assets/images/icon_voicestopbg.png' : 'assets/images/icon_voiceplaybg.png'),),),
              // decoration: BoxDecoration(
              //     color: rgba(255, 255, 255, 1),
              //     borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 23, right: 13),
                          child: Image.asset((null == articleData[i].isPlay || 0 == articleData[i].isPlay) ? 'assets/images/icon_voicepause.png' : 'assets/images/icon_voiceplay.png'),
                        ),
                        onTap: () {
                          // 播放
                          // currPlay = articleData[i].isPlay;
                          if ((null == articleData[i].isPlay || 0 == articleData[i].isPlay)) {
                            for(Voicelist v in articleData) {
                              if (1 == v.isPlay) {
                                v.isPlay = 0;
                              }
                            }
                            setState(() {
                            });
                            articleData[i].isPlay = 1;
                            stop();
                            play(articleData[i].url);
                          } else {
                            articleData[i].isPlay = 0;
                            stop();
                          }
                          setState(() {
                          });
                        },
                      ),
                      Container(
                        width: 116,
                        height: 23,
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset((null == articleData[i].isPlay || 0 == articleData[i].isPlay) ? 'assets/images/icon_voicepausetip.png' : 'assets/images/icon_voiceplaytip.png'),
                      ),
                      Container(
                        child: Text(articleData[i].voicetime.toString() + 's',
                            style: TextStyle(
                                fontSize: 16,
                                color: (null == articleData[i].isPlay || 0 == articleData[i].isPlay) ? rgba(69, 65, 103, 1) : rgba(255, 255, 255, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      int idVa = articleData[i].id;
                      // 更多
                      if (1 == articleData[i].showflag) {
                        // 展示状态
                        BottomActionSheet.show(context, [
                          '删除',
                        ], callBack: (i) {
                          callBack(i, idVa);
                          return;
                        });
                      } else {
                        // 非展示状态
                        BottomActionSheet.show(context, [
                          '展示',
                          '删除',
                        ], callBack: (i) {
                          callBack2(i, idVa);
                          return;
                        });
                      }
                      // _showPopupMenu(context, i, articleData[i]);
                    },
                    child: Container(
                      width: 25,
                      height: 20,
                      margin: EdgeInsets.only(right: 13),
                      child: Image.asset((null == articleData[i].isPlay || 0 == articleData[i].isPlay) ? 'assets/images/icon_voicepausemore.png' : 'assets/images/icon_voiceplaymore.png'),
                    ),
                  ),
                ],
              ),
            ),
            (1 == articleData[i].showflag) ? Container(
              height: 22,
              width: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: rgba(150, 148, 166, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(18),
                  )),
              margin: EdgeInsets.only(left: 25, bottom: 70),
              child: Text('展示',
                  style: TextStyle(
                      fontSize: 10, color: rgba(255, 255, 255, 1))),
            ) : Container(),
          ],
        ),
      ));
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  void callBack(i, int id) async {
    if (i == 0) {
      // 删除
      deleteUserVoice(id);
    }
  }

  void callBack2(i, int id) async {
    if (i == 0) {
      // 展示
      setShowUserVoice(id, 1);
    } else if (i == 1) {
      // 删除
      deleteUserVoice(id);
    }
  }

  void _showPopupMenu(BuildContext context, int index, Voicelist voiceData) {
    showDialog(
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: (180 + double.parse(index.toString())*90),
                right: 15,
                width: 150,
                child: Material(
                  color: rgba(245, 245, 245, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(5),
                    //   color: rgba(76, 76, 76, 1),
                    // ),
                    height: 102,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // 展示/取消展示
                            Navigator.of(context).pop();
                            setShowUserVoice(voiceData.id, (1 == voiceData.showflag) ? 0 : 1);
                          },
                          child: Container(
                            height: 50,
                            width: 90,
                            alignment: Alignment.center,
                            child: Text((1 == voiceData.showflag) ? '取消展示' : '展示',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          color: rgba(69, 65, 103, 1),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            // 删除
                            Navigator.of(context).pop();
                            deleteUserVoice(voiceData.id);
                          },
                          child: Container(
                            height: 50,
                            width: 90,
                            alignment: Alignment.center,
                            child: Text('删除',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  /// 删除用户音频
  deleteUserVoice(int id) async {
    try {
      var res = await G.req.shop.deleteVoiceReq(
          tk: widget.tk,
          id: id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          myvoiceBus.fire(new MyVoiceEvent(''));
        }
      }
    } catch (e) {}
  }

  /// 设置展示
  setShowUserVoice(int id, int showflag) async {
    try {
      var res = await G.req.shop.handleVoiceReq(
          tk: widget.tk,
          id: id,
          showflag: showflag
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          if (idNow != id) {
            try {
              var res = await G.req.shop.handleVoiceReq(
                  tk: widget.tk,
                  id: idNow,
                  showflag: 0
              );
              if (res.data != null) {
                idNow = id;
                int code = res.data['code'];
                if (20000 == code) {
                  myvoiceBus.fire(new MyVoiceEvent(''));
                }
              }
            } catch (e) {}
          }
          myvoiceBus.fire(new MyVoiceEvent(''));
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer(/*mode: PlayerMode.MEDIA_PLAYER*/);
    getUserVoice();
    getVoicetemplelist();
  }

  play(String uslStr) async {
//    await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    await audioPlayer.play(uslStr, isLocal: false);
    setState(() {});
  }

  stop() async {
//    await audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    await audioPlayer.stop();
    // audioPlayer = null;
    setState(() {});
  }

  /// 获取用户音频
  getUserVoice() async {
    try {
      var res = await G.req.shop.getUserVoiceReq(
          tk: widget.tk,
          user_id: widget.user_id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            voiceList.clear();
            voiceList.addAll(VoicelistParent.fromJson(res.data).data);
            for (Voicelist voiceli in voiceList) {
              if(1 == voiceli.showflag) {
                idNow = voiceli.id;
              }
            }
          });
        }
      }
    } catch (e) {}
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
            voiceTempllists.clear();
            voiceTempllists.addAll(VoiceTempleParent.fromJson(res.data).data);
          });
        }
      }
    } catch (e) {}
  }

  @override
  void deactivate() async {
    await audioPlayer.stop();
    audioPlayer = null;
    setState(() {});
    super.deactivate();
  }

  //监听Bus events
  void _listen() {
    myvoiceBus.on<MyVoiceEvent>().listen((event) {
      setState(() {
        getUserVoice();
      });
    });
  }
}