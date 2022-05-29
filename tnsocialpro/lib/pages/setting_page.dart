import 'dart:io';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tnsocialpro/event/loginout_event.dart';
import 'package:tnsocialpro/pages/about_page.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/widget/logout_dialog.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'feedback_page.dart';

class SettingPage extends StatefulWidget {
  String tk;
  String phone;
  SettingPage(this.phone, this.tk);

  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences _prefs;
  // 缓存值
  String _cacheSizeStr = '0M';
  @override
  Widget build(BuildContext context) {
//    _listen();
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: rgba(255, 255, 255, 1),
          appBar:
              customAppbar(context: context, borderBottom: false, title: '设置'),
          body: Container(
            color: rgba(255, 255, 255, 1),
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                    NRow(
                        height: 65,
                        margin: EdgeInsets.only(left: 40, right: 33),
                        padding: EdgeInsets.only(top: 20),
                        centerChild: Text('关于我们', style: TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500)),
                        rightChild: Image.asset('assets/images/icon_right.png', width: 9, height: 16, fit: BoxFit.cover,),
                        onPressed: () {
                          if (null == _prefs.getString('tk') ||
                              _prefs.getString('tk').isEmpty) {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new LoginIndex()));
                          } else {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AboutPage()));
                          }
                        }
                    ),
                    Container(
                      color: rgba(239, 240, 242, 1),
                      margin: EdgeInsets.only(left: 30, right: 30),
                      height: 0.5,
                    ),
                   NRow(
                       height: 65,
                       margin: EdgeInsets.only(left: 40, right: 33),
                       padding: EdgeInsets.only(top: 20),
                       centerChild: Text('反馈建议', style: TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500)),
                       rightChild: Image.asset('assets/images/icon_right.png', width: 9, height: 16, fit: BoxFit.cover,),
                       onPressed: () {
                         if(null == _prefs.getString('tk') || _prefs.getString('tk').isEmpty) {
                           Navigator.push(
                               context,
                               new MaterialPageRoute(builder: (context) => new LoginIndex())
                           );
                         } else {
                           Navigator.push(
                               context,
                               new MaterialPageRoute(builder: (context) => new FeedbackPage(tk: this.widget.tk,))
                           );
                         }
                       }
                   ),
                Container(
                  color: rgba(239, 240, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 0.5,
                ),
                NRow(
                    height: 65,
                    margin: EdgeInsets.only(left: 40, right: 33),
                    padding: EdgeInsets.only(top: 20),
                    centerChild: Text('清除缓存', style: TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500)),
                    rightChild: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Text(_cacheSizeStr, style: TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w400)),
                        ),
                        Image.asset('assets/images/icon_right.png', width: 9, height: 16, fit: BoxFit.cover,),
                      ],
                    ),
                    onPressed: () {
                      _clearCache();
                    }
                ),
                Container(
                  color: rgba(239, 240, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 0.5,
                ),
                (null != _prefs &&
                        (null == _prefs.getString('tk') ||
                            _prefs.getString('tk').isEmpty))
                    ? Container()
                    : Container(
                        width: 290,
                        height: 55,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(top: 300),
                        child: AButton.normal(
                            width: 290,
                            height: 55,
                            plain: true,
                            bgColor: rgba(255, 255, 255, 1),
                            borderColor: Colors.grey,
                            borderRadius: BorderRadius.circular(27.5),
                            child: Text(
                              '退出登录',
                              style: TextStyle(
                                  color: rgba(150, 148, 166, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                            color: rgba(255, 255, 255, 1),
                            onPressed: () {
                              // _prefs.setString('tk', '');
                              // _prefs.setInt('account_id', 0);
                              // _prefs.setString('phone', '');
                              // // _prefs.setString('clocktime', '');
                              // Navigator.push(
                              //     context,
                              //     new MaterialPageRoute(
                              //         builder: (context) => new LoginIndex()));
                              // eventLoginoutBus.fire(new LoginoutEvent(true));
                              logoutReq();
                            }),
                      ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    loadCache();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
    });
  }

  ///加载缓存
  Future<Null> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    print('临时目录大小: ' + value.toString());
    setState(() {
      _cacheSizeStr = _renderSize(value);  // _cacheSizeStr用来存储大小的值
    });
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  void _clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    Fluttertoast.showToast(msg: '清除缓存成功');
  }
  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }

  /// 退出登陆
  logoutReq() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return new LogoutDialog();
          });
      submitDeviceInfo("4", widget.tk, _prefs.getInt('account_id'));
      // var res1 = await G.req.shop.modifyLogoutState(
      //     tk: widget.tk,
      //     statusval: 0
      // );
      // if (res1.data != null) {
      // }
    } catch (e) {}
  }

  /// 更新用户状态
  submitDeviceInfo(String typeV, String tkS, int account_id) async {
    try {
      var res = await G.req.shop.updateUserBackorFont(
        tk: tkS,
        id: account_id,
        type: typeV,
      );
      if (res.data != null) {
        //  登出
        var res = await G.req.shop.logOut(
          tk: widget.tk,
        );
        if (res.data != null) {
          _prefs.setString('tk', '');
          _prefs.setInt('account_id', 0);
          _prefs.setString('phone', '');
          _prefs.setBool('isRegister', false);
          try {
            bool  sss = await EMClient.getInstance.logout(true);
            print("退出环信登录${sss}");
          } on EMError {}
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new LoginIndex()));
          int code = res.data['code'];
          if (20000 == code) {
            eventLoginoutBus.fire(new LoginoutEvent(true));
          }
        }
      }
    } catch (e) {}
  }
}
