
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/event/modifyfeedback_event.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'bigImg_page.dart';
import 'myheadImg_page.dart';

class PictureListPage extends StatefulWidget {
  String tk;
  int user_id;
  PictureListPage(this.tk, this.user_id);
  _PictureListPageState createState() => _PictureListPageState();
}

class _PictureListPageState extends State<PictureListPage> {

  List<Picturelist> pictureList = [];

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: customAppbar(
            context: context, borderBottom: false, title: '她的照片'),
      body: (null == pictureList || pictureList.isEmpty)
          ? Container() : Container(
              width: double.infinity,
              color: rgba(255, 255, 255, 1),
              margin: EdgeInsets.all(10),
              child: GridView.count(
                physics: new BouncingScrollPhysics(),
                //水平子Widget之间间距
                crossAxisSpacing: 10,
                //垂直子Widget之间间距
                mainAxisSpacing: 10,
                //GridView内边距
                padding: EdgeInsets.all(10),
                //一行的Widget数量
                crossAxisCount: 3,
                //子Widget宽高比例
                childAspectRatio: 0.75,
                //子Widget列表
                children: getWidgetList(),
              ),
      ),
    );
  }

  List<Widget> getWidgetList() {
    return pictureList.map((Picturelist item) {
      return Container(
            height: 137,
            width: 103,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: rgba(245, 245, 245, 1)),
            child: Stack(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () {
                          // 查看大图
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new BigImgPage(
                                      widget.tk, widget.user_id, pictureList.indexOf(item) + 1)));
                        },
                        child: Container(
                          height: 137,
                          width: 103,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: rgba(245, 245, 245, 1)),
                          alignment: Alignment.center,
                          child: Image.network(item.url, height: 137,
                            width: 103, fit: BoxFit.cover),
                        ))),
              ],
          ));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // 图片列表
    getUserPicture();
  }

  //监听Bus events
  void _listen() {
    modifyFeedbackBus.on<ModifyFeedEvent>().listen((event) {
      setState(() {
        getUserPicture();
      });
    });
  }

  /// 获取用户图片
  getUserPicture() async {
    try {
      var res = await G.req.shop.getUserPictureReq(
        tk: widget.tk,
        user_id: widget.user_id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            pictureList.clear();
            pictureList.addAll(PicturelistParent.fromJson(res.data).data);
          });
        }
      }
    } catch (e) {}
  }
}