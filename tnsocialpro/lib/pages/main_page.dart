import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/bannerlist/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/card_mainuser.dart';
import 'package:tnsocialpro/widget/custom_swiper.dart';

import 'gramophone_page.dart';

class MainPage extends StatefulWidget {
  String tk, headimg;
  int gender;
  List<MyUserData> mainUser;
  List<Bannerlist> bannerListDatas;

  MainPage(
      this.tk, this.gender, this.headimg, this.mainUser, this.bannerListDatas);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final List<MyUserData> mainUser = [];
  // List<Bannerlist> bannerListDatas = [];
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();
  SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      body: Container(
        color: rgba(246, 243, 249, 1),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 顶部
            Container(
                height: 120,
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                decoration: new BoxDecoration(
                  // color: Colors.grey,
                  // border: new Border.all(width: 2.0, color: Colors.transparent),
                  borderRadius: new BorderRadius.all(new Radius.circular(0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/icon_maintop.png'),
                      fit: BoxFit.none
                      //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                      // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 111,
                            height: 18,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/icon_bottomlogo.png',
                              width: 111,
                              height: 18,
                              fit: BoxFit.fill,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // 邂逅留声机
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new GrampphonePage(
                                          widget.tk,
                                          widget.headimg,
                                          widget.gender)));
                            },
                            child: Container(
                                height: 34,
                                width: 116,
                                margin: EdgeInsets.only(right: 15),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: rgba(255, 255, 255, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 5, left: 13),
                                      width: 23,
                                      height: 20,
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset(
                                        'assets/images/icon_stayvoice.png',
                                        width: 23,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text('邂逅留声机',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: rgba(69, 65, 103, 1),
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          color: rgba(246, 243, 249, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          )),
                      // color: rgba(239, 240, 242, 1),
                      height: 20,
                    ),
                  ],
                )),
            Expanded(
              // width: double.infinity,
              // // margin: EdgeInsets.only(top: 15),
              // height: double.infinity - 120,
              child: EasyRefresh(
                  header: MaterialHeader(
                    key: _headerKey,
                  ),
                  footer: MaterialFooter(
                    key: _footerKey,
                  ),
                  child: ListView(
                    children: <Widget>[
                      (widget.bannerListDatas.isEmpty)
                          ? Container()
                          : Container(
                              // color: rgba(246, 243, 249, 1),
                              margin: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20),
                              height: 84,
                              width: double.infinity,
                              child: CustomSwiper(
                                widget.bannerListDatas,
                              ),
                            ),
                      (widget.mainUser.isEmpty)
                          ? Container()
                          : CardMainUser(
                              articleData: widget.mainUser,
                              tk: widget.tk,
                              gender: widget.gender,
                              headimg: widget.headimg)
                    ],
                  ),
                  onRefresh: () async {
                    _loadMore = false;
                    getAllUserData();
                  },
                  onLoad: () async {
                    _loadMore = true;
                    getAllUserData();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取bannerlist
  getBannerlist() async {
    try {
      var res = await G.req.shop.getBannerlistReq(tk: widget.tk);
      if (res.data != null) {
        setState(() {
          widget.bannerListDatas.clear();
          widget.bannerListDatas
              .addAll(BannerlistParent.fromJson(res.data).data);
          // if (null == bannerListDatas || bannerListDatas.isEmpty) {
          //   Bannerlist bannerItem = new Bannerlist();
          //   bannerItem.src = 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/3.jpg';
          //   bannerListDatas.add(bannerItem);
          // }
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      getBannerlist();
      if (null == widget.mainUser || widget.mainUser.isEmpty) {
        _currentPage=1;
        getAllUserData();
      }
    });
    super.initState();
  }

  //监听Bus events
  void _listen() {
    // userRefreshBus.on<UserRefreshEvent>().listen((event) {
    //   var timeOr = _prefs.getInt('mainta');
    //   var timeVal = DateTime.now().millisecondsSinceEpoch;
    //   var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
    //   if (null == timeOr || timeListent > 1000) {
    //     _prefs.setInt('mainta', timeVal);
    //     getBannerlist();
    //     getAllUserData();
    //   }
    // });
  }

  int _currentPage = 1;
  bool _loadMore = false;

  /// 获取用户列表
  void getAllUserData() async {
    if (!_loadMore) {
      _currentPage = 1;
    }
print("男士，首页");
    try {
      var res = await G.req.shop
          .getAllUserlistReq(tk: widget.tk, currentPage: _currentPage);
      setState(() {
        if (res.data != null) {
          if(UserlistParent.fromJson(res.data).data.isEmpty){
            // _layoutState = LoadState.State_Success;
            return;
          }
          if (_currentPage == 1) {
            widget.mainUser.clear();
          }
          _currentPage++;
          widget.mainUser.addAll(UserlistParent.fromJson(res.data).data);
        }
      });
    } catch (e) {
      // setState(() {
      // });
    }
  }
}
