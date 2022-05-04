
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/callrecord/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/entity/callrecord_item.dart';
import 'package:tnsocialpro/entity/conversation_item.dart';
import 'package:tnsocialpro/event/event_bus_manager.dart';
import 'package:tnsocialpro/event/messagetab_event.dart';
import 'package:tnsocialpro/pages/chat/chat_page.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/common_widgets.dart';
import 'package:tnsocialpro/widget/load_state_layout.dart';

import 'AudioCallPage.dart';
import 'VideoCallPage.dart';

/**
 * 消息
 */
String tkV, mheadimgV;
int genderV, userIdV;
class MessagePage extends StatefulWidget {
  String tk, mheadimg;
  int gender, userId;
  MessagePage(this.tk, this.gender, this.userId, this.mheadimg) {
    tkV = this.tk;
    genderV = this.gender;
    userIdV = this.userId;
    mheadimgV = this.mheadimg;
  }

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  List<FindingTabView> bodys = [];
  TabController mController;
  SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("消息页面初始化");
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
            backgroundColor: rgba(241, 241, 241, 1),
            body: Container(
              color: Colours.light_grey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 15.5, top: 40),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: TabBar(
                          isScrollable: true,
                          controller: mController,
                          labelColor: Colours.backbg,
                          indicatorColor: rgba(209, 99, 242, 1),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 4.0,
                          unselectedLabelColor:Colours.backbg,
                          unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: rgba(150, 148, 166, 1)),
                          labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: rgba(69, 65, 103, 1)),
                          tabs: myTabs,
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: mController,
                      children: bodys,
                    ),
                  )
                ],
              ),
            ),
        ));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      submitDeviceInfo("1");
    });
    loadCateGoryData();
  }

  /// 更新用户状态
  submitDeviceInfo(String typeV) async {
    try {
      var res = await G.req.shop.updateUserBackorFont(
        tk: widget.tk,
        id: _prefs.getInt('account_id'),
        type: typeV,
      );
      if (res.data != null) {
        setState(() {
          // int code = res.data['code'];
        });
      }
    } catch (e) {}
  }

  /**
   * 加载大类列表和标签
   */
  void loadCateGoryData() async {
    List<CategoryModel> dataList = [];
    CategoryModel data1 = new CategoryModel();
    data1.id = 1;
    data1.name = "消息";
    dataList.add(data1);
    CategoryModel data4 = new CategoryModel();
    data4.id = 2;
    data4.name = "通话";
    dataList.add(data4);
    if (dataList != null) {
      List<Tab> myTabsTmp = <Tab>[];
      List<FindingTabView> bodysTmp = [];
      for (int i = 0; i < dataList.length; i++) {
        CategoryModel model = dataList[i];
        myTabsTmp.add(Tab(text: model.name));
        bodysTmp.add(FindingTabView(i, model.id));
      }
      myTabs.addAll(myTabsTmp);
      bodys.addAll(bodysTmp);
      mController = TabController(
        length: myTabs.length,
        vsync: this,
      )..addListener(() {
        // switch (mController.index) {
        //   case 0:
        //     eventMessagetabBus.fire(new MessageTabEvent(1));
        //     break;
        //   case 1:
        //     eventMessagetabBus.fire(new MessageTabEvent(2));
        //     break;
        // }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(null!=mController) {
      mController.dispose();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryModel{

  String name;
  int id;
  CategoryModel({this.name,this.id});
  factory CategoryModel.fromJson(Map<String, dynamic> parsedJson){
    return CategoryModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}

/**
 * 类别子页面
 */
class FindingTabView extends StatefulWidget with ChangeNotifier {
  final int currentPage;
  final int id;
  FindingTabView(this.currentPage,this.id);

  num totalUnreadCount = 0;

  updateCount(num count) {
    totalUnreadCount = count;
    notifyListeners();
  }

  @override
  _FindingTabViewState createState() => _FindingTabViewState();
}

class _FindingTabViewState extends State<FindingTabView> with AutomaticKeepAliveClientMixin implements EMChatManagerListener {

  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();
  List<EMConversation> _conversationsList = [];
  List<CallRecordData> _callRecords = [];
  List<int> _calluserIds = [];
  List<int> _callauthIds = [];
  RefreshController _refreshController = RefreshController(initialRefresh: true);
  var notifier;
  LoadState _layoutState = LoadState.State_Loading;
  List<MyInfoData> myInfoDatas = [];
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
    });
    // 通话记录
    // getCallRecordlistReq();
    // 添加环信回调监听
    EMClient.getInstance.chatManager.addListener(this);
    print( EMClient.getInstance.currentUsername);


    try {
      Future ff =  EMClient.getInstance.chatManager.loadAllConversations();

      print(ff);
    } on EMError catch (e) {
      print('操作失败，原因是: $e');
    }

    _reLoadAllConversations(widget.id);

    notifier = eventBus.on<EventBusManager>().listen((event) {
      print("notifier事件来了");
      if (event.eventKey == EventBusManager.updateConversaitonsList) {
        _reLoadAllConversations(widget.id);
      }
    });
  }

  void dispose() {
    _refreshController.dispose();
    // 移除环信回调监听
    EMClient.getInstance.chatManager.removeListener(this);
    notifier.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    super.build(context);
    return Container(
      color: rgba(246, 243, 249, 1),
      child: EasyRefresh(
          header: MaterialHeader(
            key: _headerKey,
          ),
          footer: MaterialFooter(
            key: _footerKey,
          ),
          child:CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: (1 == widget.id) ? SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return conversationWidgetForIndex(index);
                  },
                  childCount: _conversationsList.length,
                ) : SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return callRecordWidgetForIndex(index);
                  },
                  childCount: _callRecords.length,
                ) ,
              ),
            ],
          ),
          onRefresh: () async {
            _reLoadAllConversations(widget.id);
          },
          onLoad: () async {
            _reLoadAllConversations(widget.id);
          }
      ),
    );
    // return SmartRefresher(
    //   enablePullDown: false,
    //   onRefresh: () => _reLoadAllConversations(widget.id),
    //   controller: _refreshController,
    //   child: LoadStateLayout(
    //       state: _layoutState,
    //       errorRetry: () {
    //         setState(() {
    //           _layoutState = LoadState.State_Loading;
    //         });
    //         _reLoadAllConversations(widget.id);
    //       }, //错误按钮点击过后进行重新加载
    //       successWidget: CustomScrollView(
    //         slivers: <Widget>[
    //           SliverList(
    //             delegate: (1 == widget.id) ? SliverChildBuilderDelegate(
    //                   (BuildContext context, int index) {
    //                 return conversationWidgetForIndex(index);
    //               },
    //               childCount: _conversationsList.length,
    //             ) : SliverChildBuilderDelegate(
    //                   (BuildContext context, int index) {
    //                 return callRecordWidgetForIndex(index);
    //               },
    //               childCount: _callRecords.length,
    //             ) ,
    //           ),
    //         ],
    //       )
    //   ),
    // );
  }

  @override
  bool get wantKeepAlive => true;

  /// 更新会话列表
  void _reLoadAllConversations(int id) async {
    print("更新会话列表"+id.toString());
    if (1 == id) {
      // 消息
      try {
        List<EMConversation> list = await EMClient.getInstance.chatManager.loadAllConversations();
        _conversationsList.clear();
        for (EMConversation emConversation in list) {
          try {
            var res = await G.req.shop
                .getUserInfoByphone(tk: tkV, phone: emConversation.id);
            if (res.data == null) return;
            int code = res.data['code'];
            if (20000 == code) {
              MyInfoData myInfoDa = MyInfoParent.fromJson(res.data).data;
              emConversation.name = myInfoDa.username;
              Map map = new Map();
              map['userpic'] = myInfoDa.userpic;
              emConversation.ext = map;
              _conversationsList.add(emConversation);
            }
          } catch (e) {
            print(e);
          }
        }
        setState(() {
          _refreshController.refreshCompleted();
          if (_conversationsList.isEmpty) {
            _layoutState = LoadState.State_Empty;
          } else {
            _layoutState = LoadState.State_Success;
          }
          int count = 0;
          for (var conv in _conversationsList) {
            count += conv.unreadCount;
          }
          widget.updateCount(count);
        });
        // _conversationsList.clear();
        // _conversationsList.addAll(list);
      } on Error {
        _layoutState = LoadState.State_Error;
        _refreshController.refreshFailed();
      } finally {
        setState(() {});
      }
    } else {
      // 通话
      getCallRecordlistReq();
    }
  }

  /// 获取会话列表widget
  Widget conversationWidgetForIndex(int index) {
    return slidableItem(
      child: ConversationItem(
        conv: _conversationsList[index],
        onTap: () => {_conversationItemOnPress(index)},
      ),
      // 侧滑事件，有必要可以加上置顶之类的
      actions: [slidableDeleteAction(onTap: () => _deleteConversation(index))],
    );
  }

  // 获取用户信息
  getUserInfoByphoneReq(String phone, EMConversation con) async {
    try {
      var res = await G.req.shop
          .getUserInfoByphone(tk: tkV, phone: phone);

      if (res.data == null) return;
      int code = res.data['code'];
      if (20000 == code) {
        MyInfoData myInfoDa = MyInfoParent.fromJson(res.data).data;
        if (null != myInfoDa) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ChatPage(
                  tkV,
                  genderV,
                  myInfoDa.id,
                  myInfoDa.username,
                  myInfoDa.userpic,
                  (null == myInfoDa.priimset) ? '' : myInfoDa.priimset.split('B')[0],
                  mheadimgV,
                  con
              ),
            ),
          ).then((value) {
            // 返回时刷新页面
            _reLoadAllConversations(widget.id);
          });
        }
      }
      setState(() {});
    } catch (e) {}
  }

  /// 获取通话记录列表
  getCallRecordlistReq() async {
    try {
      var res;
      if (1 == genderV) {
        res = await G.req.shop
            .getUserCalllistReq(tk: tkV, user_id: userIdV);
      } else {
        res = await G.req.shop
            .getAnthorCalllistReq(tk: tkV, anthorid: userIdV);
      }

      if (res.data == null) return;
      int code = res.data['code'];
      _refreshController.refreshCompleted();
      if (20000 == code) {
        _callRecords.clear();
        _calluserIds.clear();
        _callauthIds.clear();
        List<CallRecordData> _callRecords2 = CallRecordParent.fromJson(res.data).data;
        if (_callRecords2.isNotEmpty) {
          for(CallRecordData callRecordData in _callRecords2) {
            if (1 == genderV) {
              // 用户
              if (_callRecords.isEmpty) {
                _callauthIds.add(callRecordData.anthorid);
                _callRecords.add(callRecordData);
              } else {
                if (!_callRecords.contains(callRecordData)) {
                  if(!_callauthIds.contains(callRecordData.anthorid)) {
                    _callauthIds.add(callRecordData.anthorid);
                    _callRecords.add(callRecordData);
                  }
                }
              }
            } else {
              // 主播
              if (_callRecords.isEmpty) {
                _calluserIds.add(callRecordData.user_id);
                _callRecords.add(callRecordData);
              } else {
                if (!_callRecords.contains(callRecordData)) {
                  if(!_calluserIds.contains(callRecordData.user_id)) {
                    _calluserIds.add(callRecordData.user_id);
                    _callRecords.add(callRecordData);
                  }
                }
              }
            }
          }
        }
        if (_callRecords.isEmpty) {
          _layoutState = LoadState.State_Empty;
        } else {
          _layoutState = LoadState.State_Success;
        }
      } else {
        _layoutState = LoadState.State_Empty;
      }
      setState(() {});
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  /// 获取通话记录列表widget
  Widget callRecordWidgetForIndex(int index) {
    return slidableItem(
      child: CallRecordItem(
        conv: _callRecords[index],
        onTap: () => {_callRecordPress(index)},
        gender: genderV,
        status: 1,
      ),
      // 侧滑事件，有必要可以加上置顶之类的
      actions: [slidableDeleteAction(onTap: () => _deleteCallRecord(index))],
    );
  }

  /// 通话记录侧滑删除按钮点击
  _deleteCallRecord(int index) async {
    try {
      var res = await G.req.shop.deleteCallrecordReq(
          tk: tkV,
          id: _callRecords[index].id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          getCallRecordlistReq();
        }
      }
    } catch (e) {}
  }

  /// 侧滑删除按钮点击
  _deleteConversation(int index) async {
    try {
      await EMClient.getInstance.chatManager.deleteConversation(_conversationsList[index].id);
      _conversationsList.removeAt(index);
      _reLoadAllConversations(widget.id);
    } on Error {} finally {
      setState(() {});
    }
  }

  /// 会话被点击
  _conversationItemOnPress(int index) async {
    EMConversation con = _conversationsList[index];
    List<String> userIds = [];
    userIds.add(con.id);
    // Map userInfo = EMClient.getInstance.userInfoManager.fetchUserInfoByIdWithExpireTime(userIds) as Map;
    // EMUserInfo userIn = userInfo[con.id];
    getUserInfoByphoneReq(con.id, con);
    Navigator.of(context).pushNamed(
      '/chat',
      arguments: [con.name, con],
    ).then((value) {
      // 返回时刷新页面
      _reLoadAllConversations(widget.id);
    });
  }

  // 通话记录被点击
  _callRecordPress(int index) {
    if (1 == genderV) {
      if (0 == _callRecords[index].calltype) {
        // 语音
        onAudio(context, (1 == genderV) ? _callRecords[index].anthorid : _callRecords[index].user_id, (1 == genderV) ? _callRecords[index].anthorname : _callRecords[index].username, (1 == genderV) ? _callRecords[index].anthorpic : _callRecords[index].userpic);
      } else {
        // 视频
        onVideo(context, (1 == genderV) ? _callRecords[index].anthorid : _callRecords[index].user_id, (1 == genderV) ? _callRecords[index].anthorname : _callRecords[index].username, (1 == genderV) ? _callRecords[index].anthorpic : _callRecords[index].userpic);
      }
    }
  }

  onAudio(BuildContext context, int uid, String name, String head_img) async {
    Future.delayed(Duration.zero, () async {
      await Permission.microphone.request();
      // if (isAudioPermiss) {
        //如果授权同意
        callReq(context, 0, uid, name, head_img);
      // } else {
      //   openAppSettings();
      // }
    });
  }

  onVideo(BuildContext context, int uid, String name, String head_img) async {
    Future.delayed(Duration.zero, () async {
      await Permission.camera.request();
      await Permission.microphone.request();
      // if (isCameraPermiss && isAudioPermiss) {
        //如果授权同意
        callReq(context, 1, uid, name, head_img);
      // } else {
      //   openAppSettings();
      // }
    });
  }

  //监听Bus events
  void _listen() {
    eventMessagetabBus.on<MessageTabEvent>().listen((event) {
      setState(() {
        var timeOr = _prefs.getInt('timemessage');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 800) {
          _prefs.setInt('timemessage', timeVal);
          _reLoadAllConversations(event.index);
        }
      });
    });
  }

  // 语音呼入
  void callReq(BuildContext context, int type, int uid, String name,
      String head_img) async {
    try {
      var res = await G.req.shop.callReq(tk: tkV, type: type, uid: uid, utype: (1 == genderV) ? 0 : 1);
      if (res.data != null) {
        String channel = res.data['data']['channel'];
        if (0 == type) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new AudioCallPage(
                //视频房间频道号写死，为了方便体验
                userName: name,
                channel: channel,
                tk: tkV,
                head_img: head_img,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new VideoCallPage(
                //频道写死，为了方便体验
                userName: name,
                channel: channel,
                tk: tkV,
                head_img: head_img,
              ),
            ),
          );
        }
      }
    } catch (e) {}
  }

  @override
  onCmdMessagesReceived(List<EMMessage> messages) {}

  @override
  onMessagesDelivered(List<EMMessage> messages) {}

  @override
  onMessagesRead(List<EMMessage> messages) {
    bool needReload = false;
    for (var msg in messages) {
      if (msg.to == EMClient.getInstance.currentUsername) {
        needReload = true;
        break;
      }
    }
    if (needReload) {
      _reLoadAllConversations(widget.id);
    }
  }

  @override
  onMessagesRecalled(List<EMMessage> messages) {}

  @override
  onMessagesReceived(List<EMMessage> messages) {
    _incrementCounter(messages[0].body.toString());
    print("message-接收"+messages[0].body.toString());
    _reLoadAllConversations(widget.id);
  }

  void _incrementCounter(String msg) {
    var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    var localNotification = LocalNotification(
      id: 234,
      title: '甜腻',
      buildId: 1,
      content: msg,
      fireTime: fireDate,
      subtitle: '一个测试',
    );
    JPush jj = new JPush();
    jj.sendLocalNotification(localNotification);
  }

  @override
  onConversationsUpdate() {}

  @override
  onConversationRead(String from, String to) {}
}