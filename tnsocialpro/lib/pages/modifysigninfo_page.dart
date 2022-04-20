import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tnsocialpro/data/signtemple/data.dart';
import 'package:tnsocialpro/event/modifysigninfo_event.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/customwhite_appbar.dart';


class ModifySigninfoPage extends StatefulWidget {
  String titleName, tk, name;
  ModifySigninfoPage(
      {Key key,
      @required this.titleName,
      @required this.tk,
      @required this.name})
      : super(key: key);
  _ModifySigninfoPageState createState() => _ModifySigninfoPageState();
}

class _ModifySigninfoPageState extends State<ModifySigninfoPage> {

  // bool signf1 = false, signf2 = false, signf3 = false, signf4 = false, signf5 = false, signf6 = false;
  // int addnum = 0;
  List<String> signdata = [];
  List<String> signdata2 = [];
  // List<CategoryModel> looksData = [];
  List<SignTemple> signTemples = [];
  List<SignTemple> signTemples0 = [];
  List<SignTemple> signTemples1 = [];
  List<SignTemple> signTemples2 = [];
  List<SignTemple> signTemplesadd = [];
  @override
  void initState() {
    super.initState();
    getSigntemplelist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: rgba(175, 80, 247, 1),
      appBar: customWhiteAppbar(
          context: context, borderBottom: false, title: widget.titleName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: new Opacity(
              opacity: 0.6,
              child: Text('完善特征标签，最多可选择5个标签', style: TextStyle(color: rgba(255, 255, 255, 1), fontWeight: FontWeight.w400, fontSize: 12))),
          ),
          Container(
            width: double.infinity,
            // height: 150,
            // color: rgba(255, 255, 255, 1),
            margin: EdgeInsets.all(18),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        margin: EdgeInsets.only(right: 6),
                        child: Image.asset(
                          'assets/images/icon_smilelike.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text('外貌特点',
                          style: TextStyle(
                              fontSize: 16,
                              color: rgba(255, 255, 255, 1),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                (null == signTemples0 || signTemples0.isEmpty)
                    ? Container() : Container(
                      height: 100,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: GridView.count(
                        physics: new BouncingScrollPhysics(),
                        //水平子Widget之间间距
                        crossAxisSpacing: 10,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 10,
                        //GridView内边距
                        padding: EdgeInsets.all(10),
                        //一行的Widget数量
                        crossAxisCount: 4,
                        //子Widget宽高比例
                        childAspectRatio: 0.75,
                        //子Widget列表
                        children: getWidgetList0(),
                      ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf1 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf1 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '小仙女',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf1 = !signf1;
                //             if (signf1) {
                //               signdata.add('小仙女');
                //               addnum = addnum + 1;
                //             } else {
                //               if (addnum > 0) {
                //                 signdata.remove('小仙女');
                //                 addnum = addnum - 1;
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf2 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf2 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '小仙女2',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf2 = !signf2;
                //             if (signf2) {
                //               signdata.add('小仙女2');
                //               addnum = addnum + 1;
                //             } else {
                //               if (addnum > 0) {
                //                 signdata.remove('小仙女2');
                //                 addnum = addnum - 1;
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf3 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf3 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '小仙女3',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf3 = !signf3;
                //             if (signf3) {
                //               signdata.add('小仙女3');
                //               addnum = addnum + 1;
                //             } else {
                //               if (addnum > 0) {
                //                 signdata.remove('小仙女3');
                //                 addnum = addnum - 1;
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf4 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf4 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '小仙女4',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf4 = !signf4;
                //             if (signf4) {
                //               signdata.add('小仙女4');
                //               addnum = addnum + 1;
                //             } else {
                //               if (addnum > 0) {
                //                 signdata.remove('小仙女4');
                //                 addnum = addnum - 1;
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //   ],
                // ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        margin: EdgeInsets.only(right: 6),
                        child: Image.asset(
                          'assets/images/icon-magic.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text('性格标签',
                          style: TextStyle(
                              fontSize: 16,
                              color: rgba(255, 255, 255, 1),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                (null == signTemples1 || signTemples1.isEmpty)
                    ? Container() : Container(
                        height: 100,
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        child: GridView.count(
                          physics: new BouncingScrollPhysics(),
                          //水平子Widget之间间距
                          crossAxisSpacing: 10,
                          //垂直子Widget之间间距
                          mainAxisSpacing: 10,
                          //GridView内边距
                          padding: EdgeInsets.all(10),
                          //一行的Widget数量
                          crossAxisCount: 4,
                          //子Widget宽高比例
                          childAspectRatio: 0.75,
                          //子Widget列表
                          children: getWidgetList1(),
                  ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf5 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf5 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '爱撒娇',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf5 = !signf5;
                //             if (signf5) {
                //               signdata.add('爱撒娇');
                //               addnum = addnum + 1;
                //             } else {
                //               if (addnum > 0) {
                //                 signdata.remove('爱撒娇');
                //                 addnum = addnum - 1;
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //   ],
                // ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        margin: EdgeInsets.only(right: 6),
                        child: Image.asset(
                          'assets/images/icon_friendly.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text('交友癖好',
                          style: TextStyle(
                              fontSize: 16,
                              color: rgba(255, 255, 255, 1),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                (null == signTemples2 || signTemples2.isEmpty)
                    ? Container() : Container(
                      height: 100,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: GridView.count(
                        physics: new BouncingScrollPhysics(),
                        //水平子Widget之间间距
                        crossAxisSpacing: 10,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 10,
                        //GridView内边距
                        padding: EdgeInsets.all(10),
                        //一行的Widget数量
                        crossAxisCount: 4,
                        //子Widget宽高比例
                        childAspectRatio: 0.75,
                        //子Widget列表
                        children: getWidgetList2(),
                      ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       width: 70,
                //       height: 40,
                //       alignment: Alignment.center,
                //       margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
                //       child: AButton.normal(
                //           width: 80,
                //           height: 40,
                //           plain: true,
                //           bgColor: signf6 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderColor: signf6 ? rgba(209, 99, 242, 1) : rgba(254, 197, 190, 1),
                //           borderRadius: BorderRadius.circular(27.5),
                //           child: Text(
                //             '御姐风',
                //             style: TextStyle(
                //                 color: rgba(255, 255, 255, 1),
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           color: rgba(255, 255, 255, 1),
                //           onPressed: () {
                //             if (addnum == 5) {
                //               Fluttertoast.showToast(msg: '最多可选择5个标签');
                //               return;
                //             }
                //             signf6 = !signf6;
                //             if (signf6) {
                //               addnum = addnum + 1;
                //               signdata.add('御姐风');
                //             } else {
                //               if (addnum > 0) {
                //                 addnum = addnum - 1;
                //                 signdata.remove('御姐风');
                //               } else {
                //                 addnum = 0;
                //               }
                //             }
                //             setState(() {
                //             });
                //           }),
                //     ),
                //   ],
                // ),
              ],
            )
          ),
          GestureDetector(
            onTap: () {
              // 保存
              updateUserInfo();
            },
            child: Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 56, top: 20, left: 42, right: 42),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(('assets/images/icon_savebg.png'),
                  //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                  // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                ),
              ),),
              child: Text(
                '保存',
                style: TextStyle(
                    color: rgba(255, 255, 255, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      )
    );
  }

  List<Widget> getWidgetList0() {
    return signTemples0.map((SignTemple item) {
      return Container(
        width: 80,
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
        child: AButton.normal(
            width: 80,
            height: 40,
            plain: true,
            bgColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderRadius: BorderRadius.circular(27.5),
            child: Text(
              item.signinfo,
              style: TextStyle(
                  color: rgba(255, 255, 255, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            color: rgba(255, 255, 255, 1),
            onPressed: () {
              if (signTemplesadd.isEmpty) {
                item.isChoose = true;
                signTemplesadd.add(item);
                signdata.add(item.signinfo);
              } else {
                if (null != item.isChoose && item.isChoose) {
                  item.isChoose = false;
                  signTemplesadd.remove(item);
                  signdata.remove(item.signinfo);
                } else {
                  item.isChoose = true;
                  signTemplesadd.add(item);
                  signdata.add(item.signinfo);
                }
              }
              if (signTemplesadd.length == 5) {
                Fluttertoast.showToast(msg: '最多可选择5个标签');
                return;
              }
              // signf6 = !signf6;
              // if (signf6) {
              //   addnum = addnum + 1;
              //   signdata.add('御姐风');
              // } else {
              //   if (addnum > 0) {
              //     addnum = addnum - 1;
              //     signdata.remove('御姐风');
              //   } else {
              //     addnum = 0;
              //   }
              // }
              setState(() {
              });
            }),
      );
    }).toList();
  }

  List<Widget> getWidgetList1() {
    return signTemples1.map((SignTemple item) {
      return Container(
        width: 80,
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
        child: AButton.normal(
            width: 80,
            height: 40,
            plain: true,
            bgColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderRadius: BorderRadius.circular(27.5),
            child: Text(
              item.signinfo,
              style: TextStyle(
                  color: rgba(255, 255, 255, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            color: rgba(255, 255, 255, 1),
            onPressed: () {
              if (signTemplesadd.isEmpty) {
                item.isChoose = true;
                signTemplesadd.add(item);
                signdata.add(item.signinfo);
              } else {
                if (null != item.isChoose && item.isChoose) {
                  item.isChoose = false;
                  signTemplesadd.remove(item);
                  signdata.remove(item.signinfo);
                } else {
                  item.isChoose = true;
                  signTemplesadd.add(item);
                  signdata.add(item.signinfo);
                }
              }
              if (signTemplesadd.length == 5) {
                Fluttertoast.showToast(msg: '最多可选择5个标签');
                return;
              }
              // signf6 = !signf6;
              // if (signf6) {
              //   addnum = addnum + 1;
              //   signdata.add('御姐风');
              // } else {
              //   if (addnum > 0) {
              //     addnum = addnum - 1;
              //     signdata.remove('御姐风');
              //   } else {
              //     addnum = 0;
              //   }
              // }
              setState(() {
              });
            }),
      );
    }).toList();
  }

  List<Widget> getWidgetList2() {
    return signTemples2.map((SignTemple item) {
      return Container(
        width: 80,
        height: 40,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 2.5, right: 2.5),
        child: AButton.normal(
            width: 80,
            height: 40,
            plain: true,
            bgColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderColor: (null == item.isChoose || !item.isChoose) ? rgba(254, 197, 190, 1) : rgba(209, 99, 242, 1),
            borderRadius: BorderRadius.circular(27.5),
            child: Text(
              item.signinfo,
              style: TextStyle(
                  color: rgba(255, 255, 255, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            color: rgba(255, 255, 255, 1),
            onPressed: () {
              if (signTemplesadd.isEmpty) {
                item.isChoose = true;
                signTemplesadd.add(item);
                signdata.add(item.signinfo);
              } else {
                if (null != item.isChoose && item.isChoose) {
                  item.isChoose = false;
                  signTemplesadd.remove(item);
                  signdata.remove(item.signinfo);
                } else {
                  item.isChoose = true;
                  signTemplesadd.add(item);
                  signdata.add(item.signinfo);
                }
              }
              if (signTemplesadd.length == 5) {
                Fluttertoast.showToast(msg: '最多可选择5个标签');
                return;
              }

              // if (signTemplesadd.isNotEmpty && !signTemplesadd.contains(item)) {
              //   item.isChoose = true;
              //   signTemplesadd.add(item);
              // }

              // signf6 = !signf6;
              // if (signf6) {
              //   addnum = addnum + 1;
              //   signdata.add('御姐风');
              // } else {
              //   if (addnum > 0) {
              //     addnum = addnum - 1;
              //     signdata.remove('御姐风');
              //   } else {
              //     addnum = 0;
              //   }
              // }
              setState(() {
              });
            }),
      );
    }).toList();
  }

  /// 获取签名模版
  getSigntemplelist() async {
    try {
      var res = await G.req.shop.getSigntemplelist(
          tk: widget.tk
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            signdata2 = widget.name.split(', ');
            signTemples.clear();
            signTemples0.clear();
            signTemples1.clear();
            signTemples2.clear();
            signTemples.addAll(SignTempleParent.fromJson(res.data).data);
            for(SignTemple signTemple in signTemples) {
              if (signdata2.contains(signTemple.signinfo)) {
                signTemple.isChoose = true;
                signdata.add(signTemple.signinfo);
                signTemplesadd.add(signTemple);
              }
              if (0 == signTemple.typeid) {
                signTemples0.add(signTemple);
              } else if (1 == signTemple.typeid){
                signTemples1.add(signTemple);
              } else {
                signTemples2.add(signTemple);
              }
            }
          });
        }
      }
    } catch (e) {}
  }

  /// 修改用户标签
  updateUserInfo() async {
    // if (null == value || value.isEmpty) {
    //   G.toast('用户名不能为空');
    //   return;
    // }
    try {
      String inputsign = signdata.toString().substring(1, signdata.toString().length - 1);
      var res = await G.req.shop.editSinginfoReq(
        tk: this.widget.tk,
        signinfo: inputsign,
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        modifySigninfoBus.fire(new ModifySigninfoEvent(signdata.toString().substring(1, signdata.toString().length - 1)));
        // setState(() {});
        G.toast('修改成功');
        Navigator.pop(context);
      } else {
        G.toast('修改失败');
      }
    } catch (e) {
      G.toast('修改失败');
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }
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