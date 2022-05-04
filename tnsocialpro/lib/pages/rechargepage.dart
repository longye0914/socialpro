import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/recharge_event.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/PayDialogPage.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart';
import 'dart:convert';
import 'dart:io' as H;
import 'chargedetail.dart';

String contentName;
/**
 * 充值
 */
class RechargePage extends StatefulWidget {
  String tk;
  int tianticket;
  RechargePage(this.tk, this.tianticket);
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {

  String _result = "无";
  bool isInstallwx = false;
  bool isPaySuccess = false;
  SharedPreferences _prefs;
  int userId;
  MyInfoData myInfoData;
  int tianticketVal = 0;
  bool isUppic = false;
  int ordernoV;
  String tianV;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      userId = _prefs.getInt('account_id');
      _getUserInfo();
    });
    _initFluwx();
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        setState(() {
          isPaySuccess = res.isSuccessful;
          if (isPaySuccess) {
            isUppic = true;
            // 更新订单
            _updateOrder(ordernoV);
            Fluttertoast.showToast(msg: '充值成功');
          } else {
            // Fluttertoast.showToast(msg: '充值失败');
          }
          _result = "pay :${res.isSuccessful}";
        });
      }
    });
  }

  _initFluwx() async {
    await registerWxApi(
        appId: "wxfb103cca057f151d",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    isInstallwx = await isWeChatInstalled;
    // print("is installed $result");
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: rgba(246, 243, 249, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '充值',
          style: TextStyle(
              color: rgba(69, 65, 103, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
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
        actions: <Widget>[
          GestureDetector(
            child: Container(
              height: 30,
              width: 50,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 30),
              child: Text(
                '明细',
                style: TextStyle(
                    color: rgba(69, 65, 103, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            onTap: () {
              // 明细
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                      new ChargeDetailPage(widget.tk)));
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: rgba(246, 243, 249, 1),
        child: Column(
          children: [
            Container(
              color: rgba(255, 255, 255, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            margin: EdgeInsets.only(right: 6, left: 12),
                            child: Image.asset(
                              'assets/images/icon_tiantianquan.png',
                              height: 34,
                              width: 34,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text('甜甜券余额',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: rgba(69, 65, 103, 1),
                                  fontWeight: FontWeight.w400)),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(widget.tianticket.toString(),
                                style: TextStyle(
                                    fontSize: 22,
                                    color: rgba(234, 117, 187, 1),
                                    fontWeight: FontWeight.w500)),
                          )
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
                    height: 20,
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
                width: double.infinity,
                // margin: EdgeInsets.only(top: 15),
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: rgba(255, 255, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 6yuan
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('600',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥6',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('600', '6');
                                  });
                            },
                          ),
                          // 12元
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('1200',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥12',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('1200', '12');
                                  });
                            },
                          ),
                          // 50元
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('5000',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥50',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('5000', '50');
                                  });
                            },
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 98yuan
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('9800',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥98',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('9800', '98');
                                  });
                            },
                          ),
                          // 168元
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('16800',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥168',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('16800', '168');
                                  });
                            },
                          ),
                          // 326元
                          GestureDetector(
                            child: Container(
                              width: 90,
                              height: 116,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage('assets/images/iconrechargebg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 43,
                                    width: 116,
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'assets/images/icon_tiantianquan.png',
                                      height: 43,
                                      width: 43,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text('32600',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: rgba(69, 65, 103, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 116,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text('¥326',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: rgba(150, 148, 166, 1),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // 支付弹框
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PayDialogWidget('32600', '326');
                                  });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            )
          ],
        )
      ),
    );
  }

  //监听Bus events
  void _listen() {
    rechargeBus.on<RechargeEvent>().listen((event) {
      setState(() async {
        if (1 == event.type) {
          // 支付宝
          _getOrder('支付宝充值', event.mon, event.tianVal, event.type);
        } else if (2 == event.type) {
          // 微信
          _getOrder('微信充值', event.mon, event.tianVal, event.type);
        }
      });
    });
  }

  @override
  void dispose() {
    if (isUppic) {
      isUppic = false;
      myinfolistBus.fire(new MyinfolistEvent(true));
    }
    super.dispose();
  }

  /// 获取个人信息
  _getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
            tianticketVal = myInfoData.tianticket;
          });
        }
      }
    } catch (e) {}
  }

  // 获取订单信息
  _getOrder(String commodity, String amount, String tianVal, int typeV) async {
    try {
      var res = await G.req.shop.createOderReq(
          tk: widget.tk,
          commodity: commodity,
          amount: amount,
          userId: userId);
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        int orderNo = data['data'];
        ordernoV = orderNo;
        tianV = tianVal;
        if (1 == typeV) {
          // 支付宝
          _doAliPay(orderNo, tianVal);
        } else {
          // 微信
          _toWeixin(orderNo);
        }
      } else {
      }
    } catch (e) {
    }
  }

  // 更新订单信息
  _updateOrder(int orderno) async {
    try {
      var res = await G.req.shop.updateOrderReq(
          tk: widget.tk,
          orderno: orderno);
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
      } else {
      }
    } catch (e) {
    }
  }

  // 执行支付宝支付
  _doAliPay(int orderno, String tianVal) async {
    try {
      var res = await G.req.shop.goAlipay(
          tk: widget.tk,
          orderno: orderno);
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        String signInfo = data['data'];
        // 支付宝支付
        var result = await isAliPayInstalled(); // 这里判断是否安装支付宝
        // if (result) {
          aliPay(signInfo).then((payResult) {
            // map["paySign"]是请求接口返回的字符串直接放进去就好了
            print("支付宝:" + payResult.toString());
            if (payResult['resultStatus'] == '9000') {
              isUppic = true;
              // 更新订单
              _updateOrder(orderno);
              Fluttertoast.showToast(msg: '充值成功');
            } else {
              // Fluttertoast.showToast(msg: '充值失败');
            }
          });
        // } else {
        //   Fluttertoast.showToast(msg: '请安装支付宝');
        // }
        // var result = await SyFlutterAlipay.pay(
        //   // 请求App服务端获取的签名信息
        //     signInfo,
        //     // 前面配置的urlScheme，只对IOS有效
        //     // urlScheme: '',
        //     // 是否是沙箱环境，只对Android有效
        //     // isSandbox: true
        // );
        // // 获取信息以后，跳转到订单列表
        // print(result);
      } else {
      }
    } catch (e) {
    }
  }

  void _toWeixin(int orderno) async {
    try {
      var res = await G.req.shop.wxRecharge(
          tk: widget.tk,
          orderno: orderno);
      var data = res.data;
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        // var data = await Utf8Decoder().bind(response).join();
        // Map<String, dynamic> result = json.decode(data);
        Map<String, dynamic> result = data['data'];
        print(result['appid']);
        print(result["timestamp"]);
        fluwx
            .payWithWeChat(
          appId: result['appid'].toString(),
          partnerId: result['partnerid'].toString(),
          prepayId: result['prepayid'].toString(),
          packageValue: result['package'].toString(),
          nonceStr: result['noncestr'].toString(),
          timeStamp: result['timestamp'],
          sign: result['sign'].toString(),
        )
            .then((data) {
          print("---》$data");
        });
        // 这里判断是否安装微信
        if (isInstallwx) {
        } else {
          Fluttertoast.showToast(msg: '请安装微信');
        }
      }
    } catch (e) {
    }
  }
}
