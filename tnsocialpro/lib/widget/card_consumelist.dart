
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/incomeitemlist/data.dart';
import 'package:tnsocialpro/widget/custom_view.dart';

class CardConsumelist extends StatelessWidget {
  final List<Incomeitemlist> articleData;
  String tk;
  CardConsumelist({Key key, this.articleData, this.tk}) : super(key: key);
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
          child: ConsumeCard(
            createTime: articleData[i].create_time,
            withdrawmon: articleData[i].incomemon,
            itemtype: articleData[i].itemtype,
            username: articleData[i].anthorname,
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
