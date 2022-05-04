
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/row_noline.dart';

class BigImgPage extends StatefulWidget {
  String tk;
  int user_id;
  int indexs;
  BigImgPage(this.tk, this.user_id, this.indexs);
  _BigImgPageState createState() => _BigImgPageState();
}

class _BigImgPageState extends State<BigImgPage> {
  List<Picturelist> pictureList = [];
  PageController controller = new PageController();
  var pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    getUserPicture();
    controller.addListener(() {
      setState(() {
        pageOffset = controller.offset / 200;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: rgba(0, 0, 0, 1),
          body: Container(
            // color: rgba(0, 0, 0, 1),
            height: double.infinity,
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                // 顶部
                Container(
                  alignment: Alignment.topCenter,
                  color: rgba(0, 0, 0, 1),
                  height: 32,
                ),
                NRow(
                  color: rgba(0, 0, 0, 1),
                  height: 40,
                  centerChild: Container(
                    alignment: Alignment.center,
                    child: Text(widget.indexs.toString() + '/' + pictureList.length.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: rgba(218, 215, 229, 1),
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                (null == pictureList || pictureList.isEmpty)
                    ? Container(
                  height: 485,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 80),
                  color: Colors.white,
                  width: double.infinity,
                  child: Image.asset(
                      'assets/images/icon_defaultimg.png',
                      width: double.infinity,
                      height: 485,
                      fit: BoxFit.fill),
                ) : Container(
                  height: 485,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 80),
                  child: PageView(
                    onPageChanged: (index) {//index为当前是第几个
                      setState(() {
                        widget.indexs = index + 1;
                      });
                    },
                    controller: controller,
                    children: getWidgetList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> getWidgetList() {
    return pictureList.map((Picturelist item) {
      return Container(
        height: 485,
        width: double.infinity,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8),
        //     color: rgba(245, 245, 245, 1)),
        alignment: Alignment.center,
        child: InteractiveViewer(
          child:GestureDetector (
            onTap: ()=>Navigator.pop(context),
            child: Image.network(pictureList[widget.indexs - 1].url, height: 485,
                width: double.infinity, fit: BoxFit.contain),
          ),
          )

        // new Image(
        //   image: new NetworkImage(pictureList[widget.indexs - 1].url),
        // ),
      );
    }).toList();
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
