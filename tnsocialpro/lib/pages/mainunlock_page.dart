import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:tnsocialpro/data/bannerlist/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/pages/entervalidatepage.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/card_mainuser.dart';
import 'package:tnsocialpro/widget/custom_swiper.dart';

import 'gramophone_page.dart';

class MainUnlockPage extends StatefulWidget {
  String tk, phone;
  int gender;
  MainUnlockPage(this.tk, this.gender, this.phone);
  @override
  State<StatefulWidget> createState() => _MainUnlockPageState();
}

class _MainUnlockPageState extends State<MainUnlockPage> {
  final List<MyUserData> mainUser = [];
  List<String> bannerList = [];
  List<Bannerlist> bannerListDatas = [];
  GlobalKey _headerKey = GlobalKey();
  GlobalKey _footerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
              height: 110,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              decoration: new BoxDecoration(
                // color: Colors.grey,
                // border: new Border.all(width: 2.0, color: Colors.transparent),
                borderRadius: new BorderRadius.all(new Radius.circular(0)),
                image: new DecorationImage(
                  image:  new AssetImage('assets/images/icon_maintop.png'),
                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Container(
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
              )
            ),
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
                        CardMainUser(articleData: mainUser, tk: widget.tk, gender: widget.gender,)
                      ],
                    ),
                  onRefresh: () async {
                    getAllUserData();
                  },
                  onLoad: () async {
                    getAllUserData();
                  }
              ),
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
          bannerListDatas.clear();
          bannerListDatas.addAll(BannerlistParent.fromJson(res.data).data);
          for (Bannerlist bannerlist in bannerListDatas) {
            bannerList.add(bannerlist.src);
          }
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getAllUserData();
    super.initState();
  }

  /// 获取未解锁门槛用户列表
  void getAllUserData() async{
    // 看过我
    try {
      var res = await G.req.shop.getAllUserlistReq(
        tk: widget.tk,
      );
      setState(() {
        if (res.data != null) {
          if(mounted) {
            mainUser.clear();
            mainUser.addAll(UserlistParent.fromJson(res.data).data);
          }
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new EnterValiddatePage(widget.tk, widget.phone)));
      });
    } catch(e) {
      setState(() {
      });
    }
  }
}