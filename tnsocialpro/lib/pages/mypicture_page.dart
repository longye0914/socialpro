
import 'package:color_dart/color_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/picturelist/data.dart';
import 'package:tnsocialpro/event/modifyfeedback_event.dart';
import 'package:tnsocialpro/utils/constants.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/utils/image_utils.dart';
import 'package:tnsocialpro/widget/bottom_sheet.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';

import 'myheadImg_page.dart';

class MyPicturePage extends StatefulWidget {
  String tk;
  int user_id;
  MyPicturePage(this.tk, this.user_id);
  _MyPicturePageState createState() => _MyPicturePageState();
}

class _MyPicturePageState extends State<MyPicturePage> {

  List<Picturelist> pictureList = [];
  var _imgPath;
  bool isUppic = false;

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: customAppbar(
            context: context, borderBottom: false, title: '我的照片'),
      body: (null == pictureList || pictureList.isEmpty)
          ? Container(
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
                            BottomActionSheet.show(context, [
                              '拍照',
                              '选择图片',
                            ], callBack: (i) {
                              // callBack(i);
                              return;
                            });
                          },
                      child: Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/icon_addpic.png',
                            height: 24, width: 24, fit: BoxFit.fill),
                      ))),
            ],
          )) : Container(
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
      // body: Container(
      //   margin: EdgeInsets.all(22),
      //   child: UcarImagePicker(
      //     tk: widget.tk,
      //     maxCount: 5,
      //     title: '',
      //   ),
      // )
    );
  }

  List<Widget> getWidgetList() {
    return pictureList.map((Picturelist item) {
      return (0 == item.id) ? Container(
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
                        BottomActionSheet.show(context, [
                          '拍照',
                          '选择图片',
                        ], callBack: (i) {
                          callBack(i);
                          return;
                        });
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/icon_addpic.png',
                            height: 24, width: 24, fit: BoxFit.fill),
                      ))),
            ],
          )) :
          Container(
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
                                  new MyheadImgPage(
                                      widget.tk, widget.user_id, pictureList.indexOf(item))));
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
  
  @override
  void dispose() {
    if (isUppic) {
      isUppic = false;
      modifyFeedbackBus.fire(new ModifyFeedEvent(''));
    }
    super.dispose();
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
            Picturelist pictureItem = new Picturelist();
            pictureItem.id = 0;
            pictureList.add(pictureItem);
            pictureList.addAll(PicturelistParent.fromJson(res.data).data);
          });
        }
      }
    } catch (e) {}
  }

  void callBack(i) async {
    if (i == 0) {
      print('拍照');
      _getImage(0);
    } else if (i == 1) {
      print('选择照片');
      _getImage(1);
    }
  }

  Future _getImage(int type) async {
    var image;
    if (0 == type) {
      image = await ImageUtils.getImagecamera();
    } else if (1 == type) {
      image = await ImageUtils.getImagegallery();
    }
    setState(() {
      _imgPath = image;
      if (null != _imgPath) {
        G.loadingomm.show(context);
        _fileUplodImg(_imgPath);
      }
    });
  }

  /// 上传图片
  updateHeadimgInfo(String picUrl) async {
    // if (null == picUrl || picUrl.isEmpty) {
    //   G.toast('请选择用户头像');
    //   return;
    // }
    try {
      var res = await G.req.shop.updateUserpicReq(
          tk: this.widget.tk,
          url: picUrl,
          user_id: widget.user_id
      );

      var data = res.data;

      if (data == null) return null;
      G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        isUppic = true;
        getUserPicture();
        G.toast('上传成功');
      } else {
        G.toast('上传失败');
      }
    } catch (e) {
      G.toast('上传失败');
    }
  }

  /// 用户头像上传
  void _fileUplodImg(String filePath) async {
    // String path = filePath.path;
    var name = filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);

    ///创建Dio
    BaseOptions _baseOptions = BaseOptions(headers: {
      'Authorization': this.widget.tk,
    });
    Dio _uoloadImgDio = Dio(_baseOptions);
    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(filePath, filename: name)});

    ///发送post
    Response response = await _uoloadImgDio.post(
      Constants.requestUrl + "qiniuphone/upLoadImage",
      data: formdata,

      ///这里是发送请求回调函数
      ///[progress] 当前的进度
      ///[total] 总进度
      onSendProgress: (int progress, int total) {
        print("当前进度是 $progress 总进度是 $total");
      },
    );

    ///服务器响应结果
    if (response.statusCode == 200) {
      Map map = response.data;
      // 0 表示正常，1 表示该场景下违规，2 表示疑似违规
      // int verify = map['data']['verify'];
      // if (0 == verify || 2 == verify) {
      var avatar = map['data'];
      // app 上传
      updateHeadimgInfo(avatar);
    } else {
      G.loading.hide(context);
    }
  }
}