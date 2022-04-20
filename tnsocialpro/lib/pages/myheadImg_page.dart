
import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/event/modifyfeedback_event.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
enum Action { Ok, Cancel }
class MyheadImgPage extends StatefulWidget {
  String tk;
  int user_id;
  int indexs;
  MyheadImgPage(this.tk, this.user_id, this.indexs);
  _MyheadImgPageState createState() => _MyheadImgPageState();
}

class _MyheadImgPageState extends State<MyheadImgPage> {
  List<Picturelist> pictureList = [];
  PageController controller = new PageController();
  var pageOffset = 0.0;
  // int indexs = 1;

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
                Container(
                  color: rgba(0, 0, 0, 1),
                  height: 40,
                  margin: EdgeInsets.only(top: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 9,
                          height: 16,
                          margin: EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/icon_greyback.png',
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(widget.indexs.toString() + '/' + pictureList.length.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                color: rgba(218, 215, 229, 1),
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        child: Text(
                          '',
                          style: TextStyle(
                              color: rgba(255, 255, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 22,
                          height: 22,
                          margin: EdgeInsets.only(right: 15),
                          child: Image.asset(
                            'assets/images/icon_delete.png',
                            width: 22,
                            height: 22,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          _openAlertDialog(pictureList[widget.indexs - 1].id);
                        },
                      ),
                    ],
                  ),
                ),
                // NRow(
                //   color: rgba(0, 0, 0, 1),
                //   height: 40,
                //   leftChild: GestureDetector(
                //     child: Container(
                //       width: 9,
                //       height: 16,
                //       margin: EdgeInsets.only(left: 14),
                //       alignment: Alignment.centerLeft,
                //       child: Image.asset(
                //         'assets/images/icon_greyback.png',
                //       ),
                //     ),
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                //   centerChild: Container(
                //     alignment: Alignment.center,
                //     child: Text(widget.indexs.toString() + '/' + pictureList.length.toString(),
                //         style: TextStyle(
                //             fontSize: 18,
                //             color: rgba(218, 215, 229, 1),
                //             fontWeight: FontWeight.w600)),
                //   ),
                //   rightChild: GestureDetector(
                //     child: Container(
                //       width: 22,
                //       height: 22,
                //       margin: EdgeInsets.only(right: 15),
                //       child: Image.asset(
                //         'assets/images/icon_delete.png',
                //         width: 22,
                //         height: 22,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //     onTap: () {
                //       _openAlertDialog(pictureList[widget.indexs - 1].id);
                //     },
                //   ),
                // ),
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

  Future _openAlertDialog(int id) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('确认删除这张照片吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context, Action.Cancel);
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context, Action.Ok);
                // 删除
                deleteUserPicture(id);
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
          child: Image.network(pictureList[widget.indexs - 1].url, height: 485,
              width: double.infinity, fit: BoxFit.cover),
        )
      );
    }).toList();
  }

  /// 删除用户图片
  deleteUserPicture(int id) async {
    try {
      var res = await G.req.shop.deletePictureReq(
          tk: widget.tk,
          id: id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          modifyFeedbackBus.fire(new ModifyFeedEvent(''));
          if (widget.indexs <= 1) {
            widget.indexs = 1;
            Navigator.of(context).pop();
            // widget.indexs = widget.indexs + 1;
          } else {
            widget.indexs = widget.indexs - 1;
            getUserPicture();
          }
        }
      }
    } catch (e) {
    }
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
