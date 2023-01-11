import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/pages/chat/chat_page.dart';
import 'package:tnsocialpro/pages/index_page.dart';
import 'package:tnsocialpro/utils/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  EMPushConfig config = EMPushConfig()..enableAPNs('')..enableMiPush("2882303761520119592", "5162011913592")..enableHWPush();
  var options = EMOptions(appKey: 'handenterprise#tianni');
  options.debugModel = true;
  options.pushConfig = config;
  options.autoLogin = true;
  EMClient.getInstance.init(options).then((value) => null);
  runApp(MyApp());
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);
const MaterialColor black = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: const Color(0xFF000000),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  SharedPreferences _prefs;
  String tkV;
  int id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      tkV = _prefs.getString('tk');
      id = _prefs.getInt('account_id');
    });
  }

  /// 更新用户状态
  submitDeviceInfo(String typeV) async {
    try {
      var res = await G.req.shop.updateUserBackorFont(
        tk: tkV,
        id: id,
        type: typeV,
      );
      if (res.data != null) {
        setState(() {
          // int code = res.data['code'];
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () {
        return MaterialApp(
          title: "甜腻",
          theme: ThemeData(
            primarySwatch: white,
          ),
          debugShowCheckedModeBanner: false,
          // onGenerateRoute: onGenerateRoute,
          home: IndexPage(),
        );
      },
    );
  }
}