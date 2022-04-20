import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/event/recharge_event.dart';
import 'package:tnsocialpro/pages/withdrawaccount_page.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/PayDialogPage.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'femalechargedetail.dart';
enum Action { Ok, Cancel }
String contentName;
/**
 * 提现
 */
class WithdrawPage extends StatefulWidget {
  String tk;
  int tianticket;
  String tianMon;
  WithdrawPage(this.tk, this.tianticket, this.tianMon);
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {

  SharedPreferences _prefs;
  int userId;
  TextEditingController _withdrawController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      userId = _prefs.getInt('account_id');
    });
    super.initState();
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
          '提现',
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
                      new FemaleChargeDetailPage(widget.tk)));
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: rgba(246, 243, 249, 1),
        child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                        child: NRow(
                          leftChild: Container(
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
                            centerChild: Text('甜甜券总额',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w400)),
                            rightChild: Container(
                              margin: EdgeInsets.only(right: 25),
                              child: Text(widget.tianticket.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: rgba(69, 65, 103, 1),
                                      fontWeight: FontWeight.w500)),
                            ),),
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
                          Container(
                            height: 22,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 23),
                            child: Text('可提现金额',
                                maxLines: 1,
                                style: TextStyle(
                                    color: rgba(69, 65, 103, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Container(
                            // width: 300,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 22,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 16),
                                  child: Text('¥',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: rgba(69, 65, 103, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 0),
                                  child: Text(widget.tianMon.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: rgba(234, 117, 187, 1),
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            // color: rgba(255, 255, 255, 1),
                            margin: EdgeInsets.only(left: 15, right: 15, top: 40),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: rgba(246, 243, 249, 1),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  child: Text('提现金额',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400)),
                                ),
                                Container(
                                  height: 60,
                                  width: 120,
                                  margin: EdgeInsets.only(left: 20),
                                  // padding: EdgeInsets.only(left: 130),
                                  alignment: Alignment.centerRight,
                                  child: TextField(
                                    maxLength: 20,
                                    controller: _withdrawController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        hintText: '请输入提现金额',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: rgba(218, 215, 229, 1),
                                            fontWeight: FontWeight.w400)),
                                    onChanged: (e) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // child: AButton.normal(
                            //   width: 306,
                            //   height: 60,
                            //   plain: true,
                            //   bgColor: rgba(255, 255, 255, 1),
                            //   padding: EdgeInsets.only(left: 20, right: 20),
                            //   borderColor: rgba(218, 215, 229, 1),
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 30, left: 24, right: 24),
                            child: AButton.normal(
                                width: double.infinity,
                                height: 55,
                                plain: true,
                                bgColor: rgba(209, 99, 242, 1),
                                borderColor: rgba(209, 99, 242, 1),
                                borderRadius: BorderRadius.circular(27.5),
                                child: Text(
                                  '提现',
                                  style: TextStyle(
                                      color: rgba(255, 255, 255, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                color: rgba(255, 255, 255, 1),
                                onPressed: () {
                                  // 立即提交 /// 提交金额
                                  if (_withdrawController.text.toString().isEmpty) {
                                    Fluttertoast.showToast(msg: '请输入提现金额');
                                    return;
                                  }
                                  double inputmon = double.parse(_withdrawController.text.toString().trim());
                                  double totalmon = double.parse(widget.tianMon.toString());
                                  if (inputmon > totalmon) {
                                    Fluttertoast.showToast(msg: '提现金额不能大于可提现金额');
                                    return;
                                  }
                                  // 支付弹框
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PayDialogWidget('', _withdrawController.text.toString());
                                      });
                                }),
                          ),
                          Container(
                            // height: 22,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 40, left: 35),
                            child: Text('提现规则： ',
                                maxLines: 1,
                                style: TextStyle(
                                    color: rgba(150, 148, 166, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Container(
                            // height: 22,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10, bottom: 20, left: 35, right: 35),
                            child: Text('认光代来算华并例就极党法型争油标物单第华团农金复车并特包如据精之业到记话始术员二包。二活年商过一报方委民建至观成文四高转果治选号以原百立引好热国关把存强或百算事把义自接于方中听化理属效传还意非质验下过满且何着思金真特',
                                style: TextStyle(
                                    color: rgba(150, 148, 166, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                )
              ],
        ))
      ),
    );
  }

  //监听Bus events
  void _listen() {
    rechargeBus.on<RechargeEvent>().listen((event) {
      setState(() async {
        var timeOr = _prefs.getInt('time');
        var timeVal = DateTime.now().millisecondsSinceEpoch;
        var timeListent = (null == timeOr) ? timeVal : (timeVal - timeOr);
        if (null == timeOr || timeListent > 1000) {
          _prefs.setInt('time', timeVal);
          if (1 == event.type) {
            Navigator.pop(context);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                    new WithdrawAccountPage(widget.tk, _withdrawController.text.toString(), widget.tianMon, widget.tianticket)));
          } else if (2 == event.type) {
            // 微信
            // _toWeixin();
            _createWithdrawOrder('微信充值提现', widget.tianMon, '微信充值提现', '');
          }
        }
      });
    });
  }

  // 创建提现订单信息
  _createWithdrawOrder(String commodity, String amount, String desc, String openid) async {
    try {
      var res = await G.req.shop.createWithdraworderReq(
          tk: widget.tk,
          commodity: commodity,
          amount: amount,
          userId: userId,
          name: desc,
          zfbName: openid
      );
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        // int orderNo = data['data'];
        // _doAliWithdraw(orderNo);

        _uploadWithdrawData(amount);
        myinfolistBus.fire(new MyinfolistEvent(true));
        Navigator.pop(context);
        // Fluttertoast.showToast(msg: '提现申请成功');
        _openAlertDialog('提现申请成功');
      } else {
        // Fluttertoast.showToast(msg: '提现申请失败');
        _openAlertDialog('提现申请失败');
      }
    } catch (e) {
    }
  }

  Future _openAlertDialog(String content) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('知道了'),
              onPressed: () {
                Navigator.pop(context, Action.Cancel);
              },
            ),
          ],
        );
      },
    );

    switch (action) {
      case Action.Ok:
        setState(() {
//          _choice = 'Ok';
        });
        break;
      case Action.Cancel:
        setState(() {
//          _choice = 'Cancel';
        });
        break;
      default:
    }
  }

  // 更新提现余额
  _uploadWithdrawData(String monval) async {
    int remon = (double.parse(widget.tianMon)*10).toInt() - (double.parse(monval)*10).toInt();
    String remind = (remon / 10).toString();
    int tiantianRemine = widget.tianticket - (double.parse(monval)*100).toInt();
    try {
      var res = await G.req.shop.uploadWithdrawData(
          tk: widget.tk,
          tianticket: tiantianRemine,
          tianmon: remind
      );
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
}
