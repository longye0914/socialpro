import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/event/recharge_event.dart';
import 'package:tnsocialpro/widget/row_noline.dart';

class PayDialogWidget extends StatefulWidget {
  String tianVal, tianMon;
  PayDialogWidget(String tianVal, String tianMon){
    this.tianVal = tianVal;
    this.tianMon = tianMon;
  }
  _PayDialogWidgetState createState() => _PayDialogWidgetState();
}

class _PayDialogWidgetState extends State<PayDialogWidget> {
  bool isAliChoosed = true;
  bool isWeixinChoosed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: new ShapeDecoration(
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(10)))),
          width: 260,
          height: 350,
          // padding: EdgeInsets.all(10),
          child: new Column(
            children: <Widget>[
              Container(
                height: 20,
                width: 300,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 28),
                child: Text('支付方式',
                    maxLines: 1,
                    style: TextStyle(
                        color: rgba(150, 148, 166, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/images/icon_tiantianquan.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.fill,
                ),
              ),
              (null == widget.tianVal || widget.tianVal.isEmpty) ? Container() : Container(
                height: 22,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 0),
                child: Text(widget.tianVal,
                    maxLines: 1,
                    style: TextStyle(
                        color: rgba(69, 65, 103, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                width: 300,
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
                      child: Text(widget.tianMon,
                          maxLines: 1,
                          style: TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 40,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              // 支付宝
              Container(
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16),
                  child: NRow(
                    leftChild: Container(
                      margin: EdgeInsets.only(left: 14),
                      child: Image.asset(
                        'assets/images/icon_alipay.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.fill,
                      ),
                    ),
                    centerChild: Container(
                      height: 28,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('支付宝',
                          maxLines: 1,
                          style: TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    // rightChild: Container(
                    //   margin: EdgeInsets.only(right: 15),
                    //   child: Image.asset(
                    //     isAliChoosed
                    //         ? 'assets/images/icon_choosed.png'
                    //         : 'assets/images/icon_normal.png',
                    //     height: 24,
                    //     width: 24,
                    //   ),
                    // ),
                    onPressed: () {
                      isAliChoosed = true;
                      isWeixinChoosed = false;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                      // 支付宝
                      rechargeBus.fire(new RechargeEvent(1, widget.tianMon, widget.tianVal));
                    },
                  )
              ),
              // 微信
              Container(
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  child: NRow(
                    leftChild: Container(
                      margin: EdgeInsets.only(left: 14),
                      child: Image.asset(
                        'assets/images/icon_weixin.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.fill,
                      ),
                    ),
                    centerChild: Container(
                      height: 28,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('微信',
                          maxLines: 1,
                          style: TextStyle(
                              color: rgba(69, 65, 103, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    // rightChild: Container(
                    //   margin: EdgeInsets.only(right: 15),
                    //   child: Image.asset(
                    //     isWeixinChoosed
                    //         ? 'assets/images/icon_choosed.png'
                    //         : 'assets/images/icon_normal.png',
                    //     height: 24,
                    //     width: 24,
                    //   ),
                    // ),
                    onPressed: () {
                      isAliChoosed = false;
                      isWeixinChoosed = true;
                      setState(() {
                      });
                      Navigator.of(context).pop();
                      // 微信
                      rechargeBus.fire(new RechargeEvent(2, widget.tianMon, widget.tianVal));
                    },
                  )
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
