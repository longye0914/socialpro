import 'package:flutter/cupertino.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/bannerlist/data.dart';
import 'package:tnsocialpro/data/fanslist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/data/visitlist/data.dart';
import 'package:tnsocialpro/event/maintab_event.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/event/userefresh_event.dart';
import 'package:tnsocialpro/widget/card_fansuser.dart';
import 'package:tnsocialpro/widget/card_onlineuser.dart';
import 'package:tnsocialpro/widget/card_visituser.dart';
import 'package:tnsocialpro/widget/custom_swiper.dart';
import 'package:tnsocialpro/widget/load_state_layout.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/utils/global.dart';

/**
 * 女  首页
 */
final List<MyUserData> onlineUser = [];
final List<Visitlist> visitUser = [];
final List<Fanslist> fansUser = [];
String tkV, headImgV;
int idV, genderV;
class MainGirlPage extends StatefulWidget {
  String tk, headimg;
  int userId, gender;
  MainGirlPage(this.tk, this.userId, this.gender, this.headimg) {
    tkV = this.tk;
    idV = this.userId;
    genderV = this.gender;
    headImgV = this.headimg;
  }

  @override
  _MainGirlPageState createState() => _MainGirlPageState();
}

class _MainGirlPageState extends State<MainGirlPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  List<FindingTabView> bodys = [];
  TabController mController;

  LoadState _layoutState = LoadState.State_Loading;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
            // backgroundColor: rgba(184, 115, 236, 1),
            body: LoadStateLayout(
              state: _layoutState,
              errorRetry: () {
                setState(() {
                  _layoutState = LoadState.State_Loading;
                });
                loadCateGoryData();
              },
              successWidget: Container(
                // color: rgba(246, 243, 249, 1),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 115,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 35),
                      color: rgba(184, 115, 236, 1),
                      // decoration: new BoxDecoration(
                      //     // color: rgba(184, 115, 236, 1),
                      //   // border: new Border.all(width: 2.0, color: Colors.transparent),
                      //   // borderRadius: new BorderRadius.all(new Radius.circular(0)),
                      //   image: new DecorationImage(
                      //     fit: BoxFit.fill,
                      //     image: new AssetImage('assets/images/icon_maintopbg.png'),
                      //     //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                      //     // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      //   ),
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: Row(children: <Widget>[
                              Expanded(
                                child: TabBar(
                                  isScrollable: true,
                                  controller: mController,
                                  labelColor: rgba(255, 255, 255, 1),
                                  indicatorColor: rgba(255, 255, 255, 1),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorWeight: 4.0,
                                  unselectedLabelColor:rgba(255, 255, 255, 1),
                                  unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: rgba(255, 255, 255, 1)),
                                  labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: rgba(255, 255, 255, 1)),
                                  tabs: myTabs,
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: rgba(246, 243, 249, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                )),
                            alignment: Alignment.bottomCenter,
                            // color: rgba(239, 240, 242, 1),
                            height: 15,
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: mController,
                        children: bodys,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ));
  }

  @override
  void initState() {
    super.initState();
    // 添加监听器
    loadCateGoryData();
  }
  /**
   * 加载大类列表和标签
   */
  void loadCateGoryData() async {
    List<CategoryModel> dataList = [];
    CategoryModel data1 = new CategoryModel();
    data1.id = 1;
    data1.name = "在线";
    dataList.add(data1);
    CategoryModel data2 = new CategoryModel();
    data2.id = 2;
    data2.name = "最近来访";
    dataList.add(data2);
    CategoryModel data3 = new CategoryModel();
    data3.id = 3;
    data3.name = "喜欢我";
    dataList.add(data3);
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
        //     eventMaintabBus.fire(new MainTabEvent(1));
        //     break;
        //   case 1:
        //     eventMaintabBus.fire(new MainTabEvent(2));
        //     break;
        //   case 2:
        //     eventMaintabBus.fire(new MainTabEvent(3));
        //     break;
        // }
      });
      if (dataList.length > 0) {
        _layoutState = LoadState.State_Success;
      } else {
        _layoutState = LoadState.State_Empty;
      }
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
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
class FindingTabView extends StatefulWidget {
  final int currentPage;
  final int id;
  FindingTabView(this.currentPage,this.id);

  @override
  _FindingTabViewState createState() => _FindingTabViewState();
}

class _FindingTabViewState extends State<FindingTabView> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver{
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();
  LoadState _layoutState = LoadState.State_Loading;
  MyInfoData myInfoData;
  bool _isLoading = false;
  // List<String> bannerList = [];
  List<Bannerlist> bannerListDatas = [];
  SharedPreferences _prefs;

  @override
  void initState() {
    _isLoading = true;
    getUserInfo();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      if(tkV == null) {
        Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new LoginIndex())
        );
      } else {
        loadData(this.widget.id);
      }
      getBannerlist();
    });
    super.initState();
  }

  /// 获取首页列表
  void loadData(int id) async{
    if (1 == id) {
      // 在线用户
      try {
        var res = await G.req.shop.getOnlineUserReq(
            tk: tkV,
        );
        setState(() {
          if (res.data != null) {
            if(mounted) {
              onlineUser.clear();
              onlineUser.addAll(UserlistParent.fromJson(res.data).data);
              _isLoading = false;
              if (null == onlineUser || onlineUser.isEmpty) {
                _layoutState = LoadState.State_Empty;
              } else {
                _layoutState = LoadState.State_Success;
              }
            } else {
              _layoutState = LoadState.State_Error;
            }
          } else {
            _layoutState = LoadState.State_Empty;
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    } else if (2 == id) {
      // 最近来访
      try {
        var res = await G.req.shop.getVisitUserReq(
          tk: tkV,
          follow_id: idV,
        );
        setState(() {
          if (res.data != null) {
            if(mounted) {
              visitUser.clear();
              visitUser.addAll(VisitlistParent.fromJson(res.data).data);
              _isLoading = false;
              if (null == visitUser || visitUser.isEmpty) {
                _layoutState = LoadState.State_Empty;
              } else {
                _layoutState = LoadState.State_Success;
              }
            } else {
              _layoutState = LoadState.State_Error;
            }
          } else {
            _layoutState = LoadState.State_Empty;
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    } else {
      // 喜欢我
      try {
        var res = await G.req.shop.getFanslistReq(
          tk: tkV,
          follow_id: idV
        );
        setState(() {
          if (res.data != null) {
            if(mounted) {
              fansUser.clear();
              fansUser.addAll(FanslistParent.fromJson(res.data).data);
              _isLoading = false;
              if (null == fansUser || fansUser.isEmpty) {
                _layoutState = LoadState.State_Empty;
              } else {
                _layoutState = LoadState.State_Success;
              }
            } else {
              _layoutState = LoadState.State_Error;
            }
          } else {
            _layoutState = LoadState.State_Empty;
          }
        });
      } catch(e) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      }
    }
  }

  Widget _getContent(){
    if(_isLoading){
      return Container(
        color: rgba(246, 243, 249, 1),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Container(
        color: rgba(246, 243, 249, 1),
        child: EasyRefresh(
            header: MaterialHeader(
              key: _headerKey,
            ),
            footer: MaterialFooter(
              key: _footerKey,
            ),
            child:ListView(
              children: <Widget>[
                // 轮播图
                (1 == widget.id) ? ((bannerListDatas.isEmpty) ? Container() : Container(
                  // color: rgba(246, 243, 249, 1),
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  height: 84,
                  width: double.infinity,
                  child: CustomSwiper(
                    bannerListDatas,
                  ),
                )) : Container(),
                (2 == widget.id) ? CardVisitUser(articleData: visitUser, tk: tkV, gender: genderV, headimg: headImgV, myInfo: myInfoData) : (1 == widget.id) ? CardOnlineUser(articleData: onlineUser, tk: tkV, gender: genderV, headimg: headImgV, myInfo: myInfoData) : CardFansUser(articleData: fansUser, tk: tkV, gender: genderV, headimg: headImgV, myInfo: myInfoData)
              ],
            ),
            onRefresh: () async {
              _isLoading = true;
              loadData(widget.id);
            },
            onLoad: () async {
              _isLoading = true;
              loadData(widget.id);
            }
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    super.build(context);
    return LoadStateLayout(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            loadData(widget.id);
          }, //错误按钮点击过后进行重新加载
          successWidget: _getContent()
      );

  }
  @override
  bool get wantKeepAlive => true;

  /// 获取bannerlist
  getBannerlist() async {
    try {
      var res = await G.req.shop.getBannerlistReq(tk: tkV);
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

  /// 获取个人信息
  getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: tkV,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
          });
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getUserInfo();
  }

  //监听Bus events
  void _listen() {
    userRefreshBus.on<UserRefreshEvent>().listen((event) {
      setState(() {
        var timeOr = _prefs.getInt('timeEnjoy');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 800) {
          _prefs.setInt('timeEnjoy', timeVal);
          loadData(this.widget.id);
        }
      });
    });
    // eventMaintabBus.on<MainTabEvent>().listen((event) {
    //   setState(() {
    //     var timeOr = _prefs.getInt('timeEnjoy2');
    //     var timeVal = DateTime.now().millisecondsSinceEpoch;
    //     var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
    //     if (null == timeOr || timeListent > 800) {
    //       _prefs.setInt('timeEnjoy2', timeVal);
    //       loadData(event.index);
    //     }
    //   });
    // });
    myinfolistBus.on<MyinfolistEvent>().listen((event) {
      setState(() {
        getUserInfo();
      });
    });
    myvoiceBus.on<MyVoiceEvent>().listen((event) {
      setState(() {
        getUserInfo();
      });
    });
    myinfolistBus.on<MyinfolistEvent>().listen((event) {
      setState(() {
        getUserInfo();
      });
    });
  }
}