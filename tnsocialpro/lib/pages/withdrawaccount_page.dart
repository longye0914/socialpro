import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/utils/global.dart';

class WithdrawAccountPage extends StatefulWidget {
  String tk, tianmonStr, tianMon;
  int tianticket;
      WithdrawAccountPage(this.tk, this.tianmonStr, this.tianMon, this.tianticket);
  _WithdrawAccountPageState createState() => _WithdrawAccountPageState();
}

class _WithdrawAccountPageState extends State<WithdrawAccountPage> {

  SharedPreferences _prefs;
  int userId;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _accountController = TextEditingController();

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '提现账号',
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
            actions: <Widget>[],
        ),
        body: Container(
            width: double.infinity,
            // height: double.infinity,
            color: rgba(255, 255, 255, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 25,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text('提现金额', style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w500, fontSize: 18),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 25,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text('¥' + widget.tianmonStr, style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 18),),
                ),
                Container(
                  height: 64,
                  margin: EdgeInsets.only(left: 40, right: 33, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 64,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 24),
                        child: Text('姓名',
                            style: TextStyle(
                                fontSize: 16,
                                color: rgba(69, 65, 103, 1),
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        height: 64,
                        width: 200,
                        padding: EdgeInsets.only(top: 24, left: 120),
                        // padding: EdgeInsets.only(left: 130),
                        alignment: Alignment.centerRight,
                        child: TextField(
                          maxLength: 20,
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: '支付宝实名',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: rgba(218, 215, 229, 1),
                                  fontWeight: FontWeight.w400)),
                          onChanged: (e) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: rgba(241, 241, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 1,
                ),
                Container(
                  height: 64,
                  margin: EdgeInsets.only(left: 40, right: 33, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 64,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 24),
                        child: Text('支付宝',
                            style: TextStyle(
                                fontSize: 16,
                                color: rgba(69, 65, 103, 1),
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        height: 64,
                        width: 200,
                        padding: EdgeInsets.only(top: 24, left: 80),
                        // padding: EdgeInsets.only(left: 130),
                        alignment: Alignment.centerRight,
                        child: TextField(
                          maxLength: 20,
                          controller: _accountController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: '请输入支付宝账号',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: rgba(218, 215, 229, 1),
                                  fontWeight: FontWeight.w400)),
                          onChanged: (e) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: rgba(241, 241, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    if (_nameController.text.toString().isEmpty) {
                      Fluttertoast.showToast(msg: '请填写真实姓名');
                      return;
                    }
                    if ( _accountController.text.toString().isEmpty) {
                      Fluttertoast.showToast(msg: '请填写支付账户');
                      return;
                    }
                    // 确认提现
                    _createWithdrawOrder('支付宝提现', widget.tianmonStr);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage((_nameController.text.toString().isNotEmpty || _accountController.text.toString().isNotEmpty) ? 'assets/images/icon_surechoosed.png' : 'assets/images/icon_sureunchoose.png'),
                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 30, left: 42, right: 42),
                    child: Text(
                      '确认提现',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  // height: 22,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 40, left: 55),
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
                  margin: EdgeInsets.only(top: 10, left: 55, right: 55),
                  child: Text('认光代来算华并例就极党法型争油标物单第华团农金复车并特包如据精之业到记话始术员二包。二活年商过一报方委民建至观成文四高转果治选号以原百立引好热国关把存强或百算事把义自接于方中听化理属效传还意非质验下过满且何着思金真特',
                      style: TextStyle(
                          color: rgba(150, 148, 166, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            )
        ),
    );
  }

  // 创建提现订单信息
  _createWithdrawOrder(String commodity, String amount) async {
    try {
      var res = await G.req.shop.createWithdraworderReq(
          tk: widget.tk,
          commodity: commodity,
          amount: amount,
          userId: userId,
          name: _nameController.text.toString().trim(),
          zfbName: _accountController.text.toString().trim()
      );
      var data = res.data;
      // Navigator.pop(context);
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        // int orderNo = data['data'];
        // _doAliWithdraw(orderNo);
        myinfolistBus.fire(new MyinfolistEvent(true));
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '提现申请成功');
      } else {
        Fluttertoast.showToast(msg: '提现申请失败');
      }
    } catch (e) {
    }
  }

  // 执行支付宝提现
  _doAliWithdraw(int orderno) async {
    try {
      var res = await G.req.shop.goAliWithdraw(
        tk: widget.tk,
        orderno: orderno,
        amount: widget.tianmonStr,
        userid: userId,
        name: _nameController.text.toString(),
        zfbName: _accountController.text.toString()
      );
      var data = res.data;
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        myinfolistBus.fire(new MyinfolistEvent(true));
        Fluttertoast.showToast(msg: '提现成功');
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: '提现失败');
      }
    } catch (e) {
    }
  }

  // 执行微信提现
  _doWeixinWithdraw(int orderno) async {
    try {
      var res = await G.req.shop.wechatWithdraw(
          tk: widget.tk,
          partnerTradeNo: orderno.toString(),
          amount: widget.tianmonStr,
          userid: userId,
          openid: '',
          desc: '微信提现'
      );
      var data = res.data;
      if (data == null) return;
      int code = data['code'];
      if (20000 == code) {
        myinfolistBus.fire(new MyinfolistEvent(true));
        Fluttertoast.showToast(msg: '提现成功');
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: '提现失败');
      }
    } catch (e) {
    }
  }
}