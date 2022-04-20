
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/paylist/data.dart';
import 'package:tnsocialpro/data/withdrawlist/data.dart';
import 'package:tnsocialpro/widget/custom_view.dart';

class CardPayoutlist extends StatelessWidget {
  final List<Paylist> articleData;
  String tk;
  CardPayoutlist({Key key, this.articleData, this.tk}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: rgba(246, 243, 249, 1),
        // margin: EdgeInsets.only(top: 20),
        child: _buildWidget(context));
  }

  Widget _buildWidget(BuildContext context) {
    List<Widget> mGoodsCard = [];
    Widget content;
    for (int i = 0; i < articleData.length; i++) {
      mGoodsCard.add(InkWell(
          onTap: () {
            onItemClick(context, i);
          },
          child: PayoutCard(
            createTime: articleData[i].paymenttime,
            withdrawmon: articleData[i].amount
          )));
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  void onItemClick(BuildContext context, int i) {
    int id = articleData[i].id;
    // Navigator.push(
    //   context,
    //   new MaterialPageRoute(
    //       builder: (context) => ArticleDetail(
    //             id: id,
    //             tk: tk,
    //             d_catename: d_main_title,
    //             content: content,
    //           )),
    // );
  }
}
