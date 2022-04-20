import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/utils/global.dart';

import 'logininfo_page.dart';

class GenderinfoPage extends StatefulWidget {
  String tk;
  GenderinfoPage(this.tk);
  _GenderinfoPageState createState() => _GenderinfoPageState();
}

class _GenderinfoPageState extends State<GenderinfoPage> {

  int genderVal = 0;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: AppBar(
          centerTitle: true,
          // title: Text(
          //   '充值',
          //   style: TextStyle(
          //   color: rgba(69, 65, 103, 1),
          //   fontSize: 18,
          //   fontWeight: FontWeight.w600),
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: context == null
          ? new Container()
              : InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                'assets/images/icon_back.png',
                ),
              ),
          ]),
          onTap: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            child: Container(
            decoration: BoxDecoration(border: G.borderBottom(show: false)),
            ),
            preferredSize: Size.fromHeight(0),
            ),
            actions: <Widget>[],
        ),
        body: Container(
            width: double.infinity,
            // height: double.infinity,
            color: rgba(255, 255, 255, 1),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100, left: 36),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text('你是小哥哥or小姐姐？', style: TextStyle(color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w600, fontSize: 23),),
                ),
                GestureDetector(
                  onTap: () {
                    genderVal = 1;
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 59,
                    // width: 180,
                    margin: EdgeInsets.only(top: 49, left: 36, right: 159),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: (1 == genderVal && 0 != genderVal) ? rgba(181, 200, 255, 1) : rgba(246, 247, 250, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          (1 == genderVal && 0 != genderVal) ? 'assets/images/icon_malechoosed.png' : 'assets/images/icon_maleunchoose.png',
                          height: 30,
                          width: 30,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                              '小哥哥',
                              style: TextStyle(
                                  fontSize: 18, color: (1 == genderVal && 0 != genderVal) ? rgba(255, 255, 255, 1) : rgba(184, 207, 249, 1), fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    genderVal = 2;
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 59,
                    // width: 180,
                    margin: EdgeInsets.only(top: 20, left: 36, right: 159),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: (2 == genderVal && 0 != genderVal) ? rgba(255, 170, 182, 1) : rgba(246, 247, 250, 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          (2 == genderVal && 0 != genderVal) ? 'assets/images/icon_femalechoosed.png' : 'assets/images/icon_femaleunchoose.png',
                          height: 30,
                          width: 30,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                              '小姐姐',
                              style: TextStyle(
                                  fontSize: 18, color: (2 == genderVal && 0 != genderVal) ? rgba(255, 255, 255, 1) : rgba(255, 170, 171, 1), fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 45),
                  height: 20,
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text('性别一旦确认就无法修改哦~', style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 13),),
                ),
                GestureDetector(
                    onTap: () {
                      if (0 == genderVal) {
                        Fluttertoast.showToast(msg: '请选择性别');
                        return;
                      }
                      // 确认
                      updateUserInfo();
                    },
                    child: Container(
                      width: 290,
                      height: 55,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage((0 == genderVal) ? 'assets/images/icon_sureunchoose.png' : 'assets/images/icon_surechoosed.png'),
                          //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                          // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 64),
                      child: Text(
                        '确认',
                        style: TextStyle(
                            color: rgba(255, 255, 255, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                )
              ],
            )
        ),
    );
  }

  /// 确认
  updateUserInfo() async {
    // if (null == value || value.isEmpty) {
    //   G.toast('用户名不能为空');
    //   return;
    // }
    try {
      var res = await G.req.shop.editGenderReq(
        tk: this.widget.tk,
        gender: genderVal
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        prefs.setInt('gender', genderVal);
        prefs.setInt("infostate", 2);
        // 修改
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new LogininfoPage(widget.tk, genderVal)));
        // G.toast('修改成功');
        // Navigator.pop(context);
      } else {
        G.toast('邂逅失败');
      }
    } catch (e) {
      G.toast('邂逅失败');
    }
  }
}