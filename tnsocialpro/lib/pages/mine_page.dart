
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/event/loginout_event.dart';
import 'package:tnsocialpro/event/modifyheadimg_event.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/pages/myinfo_page.dart';
import 'package:tnsocialpro/pages/receiveorderpage.dart';
import 'package:tnsocialpro/pages/rechargepage.dart';
import 'package:tnsocialpro/pages/setting_page.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'entervalidatepage.dart';
import 'genderinfo_page.dart';
import 'mylikelook_page.dart';

class MinePage extends StatefulWidget {
  MyInfoData myInfoData;
  String tk;
  int visitCount, fansCount;
  MinePage(this.tk, this.myInfoData, this.visitCount, this.fansCount);

  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  bool isLogout = false;
  SharedPreferences prefs;
  // MyInfoData myInfoData;
  final List<MyUserData> visitUser = [];
  final List<MyUserData> fansUser = [];

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      backgroundColor: rgba(246, 243, 249, 1),
      body: SingleChildScrollView(
        child: Container(
          color: rgba(246, 243, 249, 1),
          alignment: Alignment.center,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 顶部
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  // border: new Border.all(width: 2.0, color: Colors.transparent),
                  borderRadius: new BorderRadius.all(new Radius.circular(0)),
                  image: new DecorationImage(
                      image: new NetworkImage((null == widget.myInfoData || null == widget.myInfoData.bgpic || widget.myInfoData.bgpic.isEmpty) ? 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/2.jpg' : widget.myInfoData.bgpic),
                      fit: BoxFit.fill
                    //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                    // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (null == widget.myInfoData) {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new LoginIndex()));
                        } else {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new MyinfoPage(
                                      widget.tk,
                                      widget.myInfoData.username,
                                      widget.myInfoData.userpic,
                                      widget.myInfoData.phone,
                                      widget.myInfoData.birthday,
                                      widget.myInfoData.gender, widget.myInfoData.myselfintro, widget.myInfoData.bodylength, widget.myInfoData.path, widget.myInfoData.signinfo)));
                        }
                      },
                      child: Container(
                        // height: 44,
                        width: double.infinity,
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 50, right: 26),
                        child: Text(
                          '编辑资料',
                          style: TextStyle(
                              color: rgba(255, 255, 255, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    // SizedBox(height: 15),
                    Container(
                      width: 110,
                      height: 110,
                      margin: EdgeInsets.only(top: 6),
                      child: new CircleAvatar(
                          backgroundImage: new NetworkImage(
                              (null == widget.myInfoData ||
                                  null == widget.myInfoData.userpic || widget.myInfoData.userpic.isEmpty)
                                  ? ''
                                  : widget.myInfoData.userpic),
                          radius: 11.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        // if (null == myInfoData ||
                        //     myInfoData.phone == null ||
                        //     myInfoData.phone.isEmpty) {
                        //   Navigator.push(
                        //       context,
                        //       new MaterialPageRoute(
                        //           builder: (context) =>
                        //           new LoginIndex()));
                        // } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                new GenderinfoPage(
                                    prefs.getString('tk'))));
                        // }
                      },
                      child: Container(
                        height: 25,
                        margin: EdgeInsets.only(top: 10, bottom: 11),
                        child: Text(
                            (null == widget.myInfoData ||
                                widget.myInfoData.username == null ||
                                widget.myInfoData.username.isEmpty)
                                ? ''
                                : widget.myInfoData.username,
                            style: TextStyle(
                                fontSize: 18,
                                color: rgba(255, 255, 255, 1),
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 20,
                              width: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Text(
                                      (null == widget.myInfoData ||
                                          widget.myInfoData.age == null)
                                          ? ''
                                          : widget.myInfoData.age,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: Image.asset(
                                      'assets/images/icon_male.png',
                                      height: 14,
                                      width: 14,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              )
                          ),
                          Container(
                            height: 20,
                            width: 30,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text('|',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          Container(
                            height: 20,
                            width: 50,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text(
                                (null == widget.myInfoData || widget.myInfoData.bodylength == null || widget.myInfoData.bodylength.isEmpty)
                                    ? '未知'
                                    : widget.myInfoData.bodylength + 'cm',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          Container(
                            height: 20,
                            width: 30,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text('|',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          Container(
                            height: 20,
                            width: 70,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text(
                                (null == widget.myInfoData ||
                                    widget.myInfoData.path == null || widget.myInfoData.path.isEmpty)
                                    ? '未知'
                                    : widget.myInfoData.path,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ],
                      ),
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
                ),
              ),
              Container(
                width: double.infinity,
                // margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 20),
                      decoration: BoxDecoration(
                          color: rgba(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  margin: EdgeInsets.only(right: 6, left: 12),
                                  child: Image.asset(
                                    'assets/images/icon_tiantianquan.png',
                                    height: 36,
                                    width: 36,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text('甜甜券',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: rgba(69, 65, 103, 1),
                                        fontWeight: FontWeight.w400)),
                                Container(
                                  margin: EdgeInsets.only(left: 6),
                                  child: Text((null == widget.myInfoData ||
                                      widget.myInfoData.tianticket == null)
                                      ? '0'
                                      : widget.myInfoData.tianticket.toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w500)),
                                )
                              ]),
                          GestureDetector(
                            onTap: () {
                              // 充值
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                      new RechargePage(prefs.getString('tk'), widget.myInfoData.tianticket)));
                            },
                            child: Container(
                              height: 28,
                              width: 66,
                              margin: EdgeInsets.only(right: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: rgba(234, 117, 187, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              child: Text('充值',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(255, 255, 255, 1),
                                      fontWeight: FontWeight.w500)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 18, right: 18, bottom: 20),
                      decoration: BoxDecoration(
                          color: rgba(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        children: [
                          Container(
                            height: 75,
                            padding: EdgeInsets.only(left: 15, right: 8),
                            child: NRow(
                              leftChild: Container(
                                height: 22,
                                width: 22,
                                margin: EdgeInsets.only(right: 14),
                                child: Image.asset(
                                  'assets/images/icon_mylike.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              centerChild: Text('我喜欢的',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w400)),
                              rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 14),
                                    child: Text(widget.fansCount.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Image.asset(
                                    'assets/images/icon_right.png',
                                    height: 16,
                                    width: 8.9,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                // 我喜欢的
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                        new MylikelookPage(widget.tk, widget.myInfoData.id, 1, widget.myInfoData.gender, widget.myInfoData.userpic)));
                              },
                            ),
                          ),
                          Container(
                            color: rgba(239, 240, 242, 1),
                            margin: EdgeInsets.only(left: 15, right: 15),
                            height: 0.5,
                          ),
                          Container(
                            height: 75,
                            padding: EdgeInsets.only(left: 15, right: 8),
                            child: NRow(
                              leftChild: Container(
                                height: 22,
                                width: 30,
                                margin: EdgeInsets.only(right: 6),
                                child: Image.asset(
                                  'assets/images/icon_lookme.png',
                                  height: 22,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              centerChild: Text('谁看过我',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w400)),
                              rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 14),
                                    child: Text(widget.visitCount.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w400)),),
                                  Image.asset(
                                    'assets/images/icon_right.png',
                                    height: 16,
                                    width: 8.9,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                // 谁看过我
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                        new MylikelookPage(widget.tk, widget.myInfoData.id, 0, widget.myInfoData.gender, widget.myInfoData.userpic)));
                              },
                            ),),
                          Container(
                            color: rgba(239, 240, 242, 1),
                            margin: EdgeInsets.only(left: 15, right: 15),
                            height: 0.5,
                          ),
                          Container(
                            height: 75,
                            padding: EdgeInsets.only(left: 15, right: 8),
                            child: NRow(
                              leftChild: Container(
                                height: 22,
                                width: 22,
                                margin: EdgeInsets.only(right: 14),
                                child: Image.asset(
                                  'assets/images/icon_mineset.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              centerChild: Text('设置',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w400)),
                              rightChild: Image.asset(
                                'assets/images/icon_right.png',
                                height: 16,
                                width: 8.9,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                        new SettingPage(
                                            widget.myInfoData.phone, widget.tk)));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    // AutoOrientation.portraitUpMode();
    // setState(() {});
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
    getUserInfo(false);
  }

  /// 获取个人信息
  getUserInfo(bool isRefresh) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.getString('tk')
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            widget.myInfoData = MyInfoParent.fromJson(res.data).data;
            if (null != widget.myInfoData) {
              if (isRefresh) {
                getVisitUserData();
                getMyLikelistData();
              } else {
                if (null == visitUser || visitUser.isEmpty) {
                  getVisitUserData();
                }
                if (null == fansUser || fansUser.isEmpty) {
                  getMyLikelistData();
                }
              }
            }
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

  /// 获取看过我列表
  void getVisitUserData() async{
    // 看过我
    try {
      var res = await G.req.shop.getVisitUserReq(
        tk: widget.tk,
        follow_id: widget.myInfoData.id,
      );
      setState(() {
        if (res.data != null) {
          visitUser.clear();
          visitUser.addAll(UserlistParent.fromJson(res.data).data);
          widget.visitCount = (null == visitUser || visitUser.isEmpty) ? 0 : visitUser.length;
        }
      });
    } catch(e) {
      setState(() {
      });
    }
  }

  /// 获取看过我列表
  void getMyLikelistData() async{
    // 我喜欢的
    try {
      var res = await G.req.shop.getMyLikelistReq(
          tk: widget.tk,
          user_id: widget.myInfoData.id
      );
      setState(() {
        if (res.data != null) {
          fansUser.clear();
          fansUser.addAll(UserlistParent.fromJson(res.data).data);
          widget.fansCount = (null == fansUser || fansUser.isEmpty) ? 0 : fansUser.length;
        }
      });
    } catch(e) {
      setState(() {
      });
    }
  }

  //监听Bus events
  void _listen() {
    modifyHeadBus.on<ModifyHeadEvent>().listen((event) {
      setState(() {
        widget.myInfoData.userpic = event.text;
//        getOldInfo();
      });
    });
    eventLoginoutBus.on<LoginoutEvent>().listen((event) {
      setState(() {
//        this.widget.myInfoData = null;
        prefs.setString('tk', '');
      });
    });
    myinfolistBus.on<MyinfolistEvent>().listen((event) {
      setState(() {
        getUserInfo(true);
      });
    });
  }
}
