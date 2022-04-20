import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/fanslist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/pages/girldetailpage.dart';
import 'package:tnsocialpro/widget/custom_view.dart';

class CardFansUser extends StatelessWidget {
  final List<Fanslist> articleData;
  String tk, headimg;
  int gender;
  MyInfoData myInfo;
  CardFansUser({Key key, this.articleData, this.tk, this.gender, this.headimg, this.myInfo}) : super(key: key);
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
          child: UserFansCard(
            myInfoData: articleData[i],
            tk: tk,
            genderV: gender,
            mheadimgV: headimg,
            myInfo: myInfo
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
    //       builder: (context) => GirlDetailPage(tk, id, gender, headimg)),
    // );
  }
}
