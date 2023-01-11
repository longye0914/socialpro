import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/pages/girldetailpage.dart';
import 'package:tnsocialpro/widget/custom_view.dart';

// 男性用户首页 女性卡片样式
class CardMainUser extends StatelessWidget {
  final List<MyUserData> articleData;
  String tk, headimg;
  int gender;
  CardMainUser({Key key, this.articleData, this.tk, this.gender, this.headimg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: rgba(246, 243, 249, 1),
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
          child: MainUserCard(
            myInfoData: articleData[i],
            tk: tk,
          )));
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  void onItemClick(BuildContext context, int i) {
    int id = articleData[i].id;
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => GirlDetailPage(tk, id, gender, headimg)),
    );
  }
}
