import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:color_dart/color_dart.dart';
import 'package:tnsocialpro/widget/row_noline.dart';

import 'highopinionpage.dart';

class AboutPage extends StatefulWidget {
  String tk;
  AboutPage({Key key, @required this.tk}) : super(key: key);
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  SharedPreferences _prefs;
  String path, _version, upremark, apkpath, _updateVersion;
  bool isForceUpdate = false, isUpdate = false;
  List<String> contentStr = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //版本名
      _prefs = await SharedPreferences.getInstance();
      // 更新升级
//      _getInstallMarket();
      _getVersion();
      setState(() {});
    });
  }

  void _getVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version = packageInfo.version;
      if (Platform.isIOS) {
        getVersionInfo(2, _version);
      } else {
        getVersionInfo(3, _version);
      }
    });
  }

  /// 获取版本更新信息
  getVersionInfo(int plattype, String localversion) async {
    try {
      var res = await G.req.user.upgradeVersioninfoReq(type: 1);

      var data = res.data;

      if (data == null) return;

      int code = data['code'];
      upremark = data['data']['up_remark'];
      path = data['data']['path'];
      int isForceUp = data['data']['is_force_up'];
      _updateVersion = data['data']['cur_version'];
      isForceUpdate = (1 == isForceUp);
      if (200 == code) {
        if (null == upremark || upremark.isEmpty) {
          contentStr.add('1.系统性能优化');
          contentStr.add('2.新增功能');
        } else {
          contentStr.add(upremark);
        }
        if (localversion == _updateVersion) {
          // 不用更新
          isUpdate = false;
        } else {
          // 需要更新
          isUpdate = true;
          // android
          if (null == path || path.isEmpty) {
            apkpath =
                'http://www.xinrunda.net.cn/download/xrd_lmnkfpad_stable.apk';
          } else {
            apkpath = path;
          }
        }
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: rgba(255, 255, 255, 1),
          appBar: customAppbar(
              context: context, borderBottom: false, title: '关于我们'),
          body: Container(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'assets/images/icon_logo.png',
                      fit: BoxFit.fill,
                      width: 90,
                      height: 90,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      NRow(
                          height: 65,
                          margin: EdgeInsets.only(left: 40, right: 33, top: 25),
                          padding: EdgeInsets.only(top: 20),
                          leftChild: Text(
                            '版本号',
                            style: TextStyle(
                                color: rgba(69, 65, 103, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          rightChild: Text(
                            'V'  + ((null == _version) ? '1.0.0' : _version),
                            style: TextStyle(
                                color: rgba(69, 65, 103, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          onPressed: () {
                          }),
                      Container(
                        color: rgba(239, 240, 242, 1),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        height: 0.5,
                      ),
                      NRow(
                          height: 65,
                          margin: EdgeInsets.only(left: 40, right: 33),
                          padding: EdgeInsets.only(top: 20),
                          leftChild: Text(
                            '给我们好评',
                            style: TextStyle(
                                color: rgba(69, 65, 103, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          rightChild: Image.asset(
                            'assets/images/icon_right.png',
                            width: 8.9,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            // 给我们好评
                            // Navigator.push(
                            //     context,
                            //     new MaterialPageRoute(
                            //         builder: (context) => new HighopinionPage(widget.tk)));
                          }),
                      Container(
                        color: rgba(239, 240, 242, 1),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        height: 0.5,
                      ),
                      NRow(
                          height: 65,
                          margin: EdgeInsets.only(left: 40, right: 33),
                          padding: EdgeInsets.only(top: 20),
                          leftChild: Text(
                            '检查更新',
                            style: TextStyle(
                                color: rgba(69, 65, 103, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          rightChild: Image.asset(
                            'assets/images/icon_right.png',
                            width: 8.9,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            // 更新升级
                          }),
                      Container(
                        color: rgba(239, 240, 242, 1),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        height: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
