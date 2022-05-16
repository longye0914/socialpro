
import 'dart:convert';
import 'package:color_dart/color_dart.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:tnsocialpro/event/modifyheadimg_event.dart';
import 'package:tnsocialpro/event/modifyname_event.dart';
import 'package:tnsocialpro/event/modifyphone_event.dart';
import 'package:tnsocialpro/event/modifyselfintr_event.dart';
import 'package:tnsocialpro/event/modifysigninfo_event.dart';
import 'package:tnsocialpro/event/myinfo_event.dart';
import 'package:tnsocialpro/utils/JhPickerTool.dart';
import 'package:tnsocialpro/utils/common_date.dart';
import 'package:tnsocialpro/utils/constants.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/utils/image_utils.dart';
import 'package:tnsocialpro/widget/bottom_sheet.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'modifyname_page.dart';
import 'modifyselfintro_page.dart';
import 'modifysigninfo_page.dart';

const double _kPickerHeight = 216.0;
const double _kItemHeigt = 40.0;
const Color _kBtnColor = Color(0xFF323232);
const Color _kTitleColor = Color(0xFF787878);
const double _kTextFontSize = 17.0;

typedef _DateClickCallBack = void Function(
    dynamic selectDateStr, dynamic selectData);

enum DateType {
  YMD, // y,m,d
  YM, // y,m
  YMD_HM, //y,m,d,hh,mm
  YMD_AP_HM, //y,m,d,ap,hh,mm

}

class MyinfoPage extends StatefulWidget {
  String tk, userName, headImg, phone, _birthdate, myselfintro, bodylength, path, signinfo;
  int sex;
  MyinfoPage(this.tk, this.userName, this.headImg, this.phone, this._birthdate,
      this.sex, this.myselfintro, this.bodylength, this.path, this.signinfo);
  _MyinfoPageState createState() => _MyinfoPageState();
}

class _MyinfoPageState extends State<MyinfoPage> {
  var _imgPath;
  int ageV = 0;

  List datas = [];
  int provinceIndex;
  int cityIndex;
  int areaIndex;

  FixedExtentScrollController provinceScrollController;
  FixedExtentScrollController cityScrollController;
  FixedExtentScrollController areaScrollController;

  CityResult result = CityResult();

  bool isShow = false, isShowDailog = false;

  List get provinces {
    if (datas.length > 0) {
      if (provinceIndex == null) {
        provinceIndex = 0;
        result.province = provinces[provinceIndex]['label'];
        result.provinceCode = provinces[provinceIndex]['value'].toString();
      }
      return datas;
    }
    return [];
  }

  List get citys {
    if (provinces.length > 0) {
      return provinces[provinceIndex]['children'] ?? [];
    }
    return [];
  }

  List get areas {
    if (citys.length > 0) {
      if (cityIndex == null) {
        cityIndex = 0;
        result.city = citys[cityIndex]['label'];
        result.cityCode = citys[cityIndex]['value'].toString();
      }
      List list = citys[cityIndex]['children'] ?? [];
      if (list.length > 0) {
        if (areaIndex == null) {
          areaIndex = 0;
          result.area = list[areaIndex]['label'];
          result.areaCode = list[areaIndex]['value'].toString();
        }
      }
      return list;
    }
    return [];
  }

  // 保存选择结果
  _saveInfoData() {
    var prs = provinces;
    var cts = citys;
    var ars = areas;
    if (provinceIndex != null && prs.length > 0) {
      result.province = prs[provinceIndex]['label'];
      result.provinceCode = prs[provinceIndex]['value'].toString();
    } else {
      result.province = '';
      result.provinceCode = '';
    }

    if (cityIndex != null && cts.length > 0) {
      result.city = cts[cityIndex]['label'];
      result.cityCode = cts[cityIndex]['value'].toString();
    } else {
      result.city = '';
      result.cityCode = '';
    }

    if (areaIndex != null && ars.length > 0) {
      result.area = ars[areaIndex]['label'];
      result.areaCode = ars[areaIndex]['value'].toString();
    } else {
      result.area = '';
      result.areaCode = '';
    }
  }
  @override
  void dispose() {
    if (mounted) {
      myinfolistBus.fire(MyinfolistEvent(true));
    }
    provinceScrollController.dispose();
    cityScrollController.dispose();
    areaScrollController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    //初始化控制器
    provinceScrollController = FixedExtentScrollController();
    cityScrollController = FixedExtentScrollController();
    areaScrollController = FixedExtentScrollController();

    //读取city.json数据
    // if (widget.params == null) {
      _loadCitys().then((value) {
        setState(() {
          isShow = true;
        });
      });
    // } else {
    //   datas = widget.params;
    //   setState(() {
    //     isShow = true;
    //   });
    // }
  }

  Future _loadCitys() async {
    var cityStr = await rootBundle.loadString('assets/city.json');
    datas = json.decode(cityStr) as List;
    //result默认取第一组值
    return Future.value(true);
  }

  Widget _firstView() {
    return Container(
      height: 44,
      color: Colors.black12,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                setState(() {
                  isShowDailog = false;
                });
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                // if (widget.onResult != null) {
                //   widget.onResult(result);
                // }
                setState(() {
                  widget.path = result.city;
                  isShowDailog = false;
                  updatePathInfo(widget.path);
                });
                // Navigator.pop(context);
              },
            ),
          ]),
      // decoration: BoxDecoration(
      //   border: Border(
      //       bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
      // ),
    );
  }

  Widget _contentView() {
    return Container(
      // color: Colors.black12,
      height: 130,
      child: isShow
          ? Row(
        children: <Widget>[
          Expanded(child: _provincePickerView()),
          Expanded(child: _cityPickerView()),
          Expanded(child: _areaPickerView()),
        ],
      )
          : Center(
        child: CupertinoActivityIndicator(
          animating: true,
        ),
      ),
    );
  }

  Widget _provincePickerView() {
    return Container(
      child: CupertinoPicker(
        scrollController: provinceScrollController,
        children: provinces.map((item) {
          return Center(
            child: Text(
              item['label'],
              style: TextStyle(color: Colors.black87, fontSize: 16),
              maxLines: 1,
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          provinceIndex = index;
          if (cityIndex != null) {
            cityIndex = 0;
            if (cityScrollController.positions.length > 0) {
              cityScrollController.jumpTo(0);
            }
          }
          if (areaIndex != null) {
            areaIndex = 0;
            if (areaScrollController.positions.length > 0) {
              areaScrollController.jumpTo(0);
            }
          }
          _saveInfoData();
          setState(() {});
        },
        itemExtent: 36,
      ),
    );
  }

  Widget _cityPickerView() {
    return Container(
      child: citys.length == 0
          ? Container()
          : CupertinoPicker(
        scrollController: cityScrollController,
        children: citys.map((item) {
          return Center(
            child: Text(
              item['label'],
              style: TextStyle(color: Colors.black87, fontSize: 16),
              maxLines: 1,
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          cityIndex = index;
          if (areaIndex != null) {
            areaIndex = 0;
            if (areaScrollController.positions.length > 0) {
              areaScrollController.jumpTo(0);
            }
          }
          _saveInfoData();
          setState(() {});
        },
        itemExtent: 36,
      ),
    );
  }

  Widget _areaPickerView() {
    return Container(
      width: double.infinity,
      child: areas.length == 0
          ? Container()
          : CupertinoPicker(
        scrollController: areaScrollController,
        children: areas.map((item) {
          return Center(
            child: Text(
              item['label'],
              style: TextStyle(color: Colors.black87, fontSize: 16),
              maxLines: 1,
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          areaIndex = index;
          _saveInfoData();
          setState(() {});
        },
        itemExtent: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: rgba(255, 255, 255, 1),
          resizeToAvoidBottomInset: false,
          appBar: customAppbar(
              context: context, borderBottom: false, title: '编辑资料'),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: rgba(255, 255, 255, 1),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              margin: EdgeInsets.only(top: 35, bottom: 20),
                              alignment: Alignment.centerRight,
                              child: CircleAvatar(
                                  backgroundImage: new NetworkImage(
                                      (null == widget.headImg ||
                                          widget.headImg.isEmpty)
                                          ? '无'
                                          : widget.headImg),
                                  radius: 50),
                            ),
                            Positioned(
                                right: 5,
                                bottom: 20,
                                child: GestureDetector(
                                  onTap: (){
                                    // Navigator.push(
                                    //     context,
                                    //     new MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         new MyheadImgPage(
                                    //             widget.tk,
                                    //             widget.headImg)));
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      // 上传头像
                                      BottomActionSheet.show(context, [
                                        '拍照',
                                        '选择图片',
                                      ], callBack: (i) {
                                        callBack(i);
                                        return;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.centerRight,
                                      child: CircleAvatar(
                                          backgroundImage: new AssetImage('assets/images/icon_camera.png'),
                                          radius: 50),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('昵称',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    child: Text(
                                      null == widget.userName ||
                                          widget.userName.isEmpty
                                          ? '去填写'
                                          : widget.userName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ModifyinfoPage(
                                          titleName: '修改昵称',
                                          tk: widget.tk,
                                          name: widget.userName, phone: widget.phone)));
                            }),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('性别',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: 30),
                                    child: Text(
                                      (null == widget.sex)
                                          ? '未知'
                                          : (1 == widget.sex)
                                          ? '男'
                                          : (2 == widget.sex)
                                          ? '女'
                                          : '女',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(218, 215, 229, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  // Container(
                                  //   width: 15,
                                  //   height: 15,
                                  //   margin: EdgeInsets.only(left: 4),
                                  //   alignment: Alignment.centerRight,
                                  //   child: Image.asset(
                                  //     'assets/images/icon_right.png',
                                  //     width: 15,
                                  //     height: 15,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                ]),
                            onPressed: () {
                              // BottomActionSheet.show(context, [
                              //   '男',
                              //   '女',
                              // ], callBack: (i) {
                              //   callBack(i);
                              //   return;
                              // });
                            }),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('生日',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    child: Text(
                                      null == widget._birthdate ||
                                          widget._birthdate.isEmpty
                                          ? '去填写'
                                          : widget._birthdate,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              showDatePicker(context,
                                  clickCallBack: (var str, var time) {
                                    setState(() {
                                      widget._birthdate = str;
                                      updateUserBirth(widget._birthdate);
                                    });
                                  });
                            }),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('身高',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    child: Text(
                                      null == this.widget.bodylength ||
                                          this.widget.bodylength.isEmpty
                                          ? '去填写'
                                          : this.widget.bodylength + "cm",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              var aa = ['160', '165', '170', '175', '180', '185', '190', '195'];
                              JhPickerTool.showStringPicker(context,
                                  data: aa,
                                  clickCallBack: (int index,var str){
                                    setState(() {
                                      widget.bodylength = str;
                                      updateBodyInfo(widget.bodylength);
                                    });
                                    // print(index);
                                    // print(str);
                                  }
                              );
                              // Navigator.push(
                              //     context,
                              //     new MaterialPageRoute(
                              //         builder: (context) => new ModifyBodyheiPage(
                              //             titleName: '修改身高',
                              //             tk: widget.tk,
                              //             name: widget.bodylength)));
                            }),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('城市',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    alignment: Alignment.center,
                                    child: Text(
                                      null == this.widget.path ||
                                          this.widget.path.isEmpty
                                          ? '去填写'
                                          : this.widget.path,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              // 城市
                              isShowDailog = !isShowDailog;
                              setState(() {
                              });
                              // Navigator.push(
                              //     context,
                              //     new MaterialPageRoute(
                              //         builder: (context) => new ModifyPathPage(
                              //             titleName: '修改城市',
                              //             tk: widget.tk,
                              //             name: widget.path, phone: widget.phone)));
                            }),
                        Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ),
                        (2 == widget.sex) ? NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 40, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('标签',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    width: 180,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      null == this.widget.signinfo ||
                                          this.widget.signinfo.isEmpty
                                          ? '去填写'
                                          : this.widget.signinfo,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ModifySigninfoPage(
                                          titleName: '我的特征标签',
                                          tk: this.widget.tk,
                                          name: this.widget.signinfo)));
                            }) : Container(),
                        (2 == widget.sex) ? Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ) : Container(),
                        (2 == widget.sex) ? NRow(
                            height: 64,
                            margin: EdgeInsets.only(left: 30, right: 33),
                            padding: EdgeInsets.only(top: 24),
                            centerChild: Text('自我介绍',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w500)),
                            rightChild: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 64,
                                    width: 180,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      null == this.widget.myselfintro ||
                                          this.widget.myselfintro.isEmpty
                                          ? '去填写'
                                          : this.widget.myselfintro,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: rgba(69, 65, 103, 1),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      'assets/images/icon_right.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            onPressed: () {
                              // 自我介绍
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ModifyselfIntrPage(
                                          titleName: '自我介绍',
                                          tk: this.widget.tk,
                                          name: this.widget.myselfintro, phone: this.widget.phone)));
                            }) : Container(),
                        (2 == widget.sex) ? Container(
                          color: rgba(241, 241, 242, 1),
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: 1,
                        ) : Container(),
                        Container(
                          color: Colors.white,
                          height: 80,
                        )
                      ],
                    ),
                  ),
                ),
                isShowDailog ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 174,
                      color: Colors.white,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          _firstView(),
                          _contentView()
                        ],
                      ),
                    )) : Container(),
                // Positioned(
                //   bottom: 100,
                //   child: isShowDailog ? Container(
                //     height: 194,
                //     // alignment: Alignment.bottomCenter,
                //     margin: EdgeInsets.only(top: 30),
                //     // color: Colors.transparent,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.end,
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       // mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         _firstView(),
                //         _contentView(),
                //       ],
                //     ),
                // ) : Container(),)
              ],
            )
          )
        ));
  }


  void callBack(i) {
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

  /// 修改城市信息
  updatePathInfo(String value) async {
    try {
      var res = await G.req.shop.editPathReq(
        tk: this.widget.tk,
        path: value,
      );
      var data = res.data;
      if (data == null) return null;
      int code = data['code'];
      if (20000 == code) {
      } else {
        // G.toast('修改失败');
      }
    } catch (e) {
      // G.toast('修改失败');
    }
  }

  /// 修改身高
  updateBodyInfo(String value) async {
    try {
      var res = await G.req.shop.editBodylengReq(
        tk: this.widget.tk,
        bodylength: value,
      );
      var data = res.data;
      if (data == null) return null;
      int code = data['code'];
      if (20000 == code) {
        setState(() {
        });
      } else {
        // G.toast('修改失败');
      }
    } catch (e) {
      // G.toast('修改失败');
    }
  }

  /// 上传图片
  updateHeadimgInfo(String picUrl) async {
    // if (null == picUrl || picUrl.isEmpty) {
    //   G.toast('请选择用户头像');
    //   return;
    // }
    try {
      var res = await G.req.shop.editHeadimgReq(
          tk: this.widget.tk,
          userpic: picUrl
      );
      var data = res.data;

      if (data == null) return null;
      G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        widget.headImg = picUrl;
        G.toast('上传成功');
        // EMUserInfo userInfo = new EMUserInfo(widget.phone);
        // userInfo.nickName = widget.userName;
        // userInfo.avatarUrl = picUrl;
        // EMClient.getInstance.userInfoManager.updateOwnUserInfo(userInfo);
        setState(() {
        });
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
    }
  }

  //监听Bus events
  void _listen() {
    modifyNameBus.on<ModifyNameEvent>().listen((event) {
      setState(() {
        widget.userName = event.text;
        // EMUserInfo userInfo = new EMUserInfo(widget.phone);
        // userInfo.nickName = event.text;
        // EMClient.getInstance.userInfoManager.updateOwnUserInfo(userInfo);
      });
    });
    modifySelfintrBus.on<ModifyIntroEvent>().listen((event) {
      setState(() {
        widget.myselfintro = event.text;
      });
    });
    // modifyBodyBus.on<ModifyBodyEvent>().listen((event) {
    //   setState(() {
    //     widget.bodylength = event.text;
    //   });
    // });
    // modifyPathBus.on<ModifyPathEvent>().listen((event) {
    //   setState(() {
    //     widget.path = event.text;
    //   });
    // });
    modifySigninfoBus.on<ModifySigninfoEvent>().listen((event) {
      setState(() {
        widget.signinfo = event.text;
      });
    });
    modifyHeadBus.on<ModifyHeadEvent>().listen((event) {
      setState(() {
        widget.headImg = event.text;
      });
    });
    // 手机号
    modifyPhoneBus.on<ModifyPhoneEvent>().listen((event) {
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        setState(() {
          widget.phone = event.text;
        });
      });
    });
  }

  //日期选择器
  static void showDatePicker(
    BuildContext context, {
    DateType dateType,
    String title,
    DateTime maxValue,
    DateTime minValue,
    DateTime value,
    DateTimePickerAdapter adapter,
    @required _DateClickCallBack clickCallBack,
  }) {
    int timeType;
    if (dateType == DateType.YM) {
      timeType = PickerDateTimeType.kYM;
    } else if (dateType == DateType.YMD_HM) {
      timeType = PickerDateTimeType.kYMDHM;
    } else if (dateType == DateType.YMD_AP_HM) {
      timeType = PickerDateTimeType.kYMD_AP_HM;
    } else {
      timeType = PickerDateTimeType.kYMD;
    }
    openModalPicker(context,
        adapter: adapter ??
            DateTimePickerAdapter(
              type: timeType,
              isNumberMonth: true,
              yearSuffix: "年",
              monthSuffix: "月",
              daySuffix: "日",
              strAMPM: const ["上午", "下午"],
              maxValue: maxValue,
              minValue: minValue,
              value: value ?? DateTime.now(),
            ),
        title: title, clickCallBack: (Picker picker, List<int> selecteds) {
      var time = (picker.adapter as DateTimePickerAdapter).value;
      var timeStr;
      if (dateType == DateType.YM) {
        timeStr = time.year.toString() + "年" + time.month.toString() + "月";
      } else if (dateType == DateType.YMD_HM) {
        timeStr = time.year.toString() +
            "-" +
            ((time.month.toString().length == 1)
                ? "0" + time.month.toString()
                : time.month.toString()) +
            "-" +
            ((time.day.toString().length == 1)
                ? "0" + time.day.toString()
                : time.day.toString()) +
            "" +
            time.hour.toString() +
            "时" +
            time.minute.toString() +
            "分";
      } else if (dateType == DateType.YMD_AP_HM) {
        var str = formatDate(time, [am]) == "AM" ? "上午" : "下午";
        timeStr = time.year.toString() +
            "-" +
            ((time.month.toString().length == 1)
                ? "0" + time.month.toString()
                : time.month.toString()) +
            "-" +
            ((time.day.toString().length == 1)
                ? "0" + time.day.toString()
                : time.day.toString()) +
            "" +
            str +
            time.hour.toString() +
            "时" +
            time.minute.toString() +
            "分";
      } else {
        timeStr = time.year.toString() +
            "-" +
            ((time.month.toString().length == 1)
                ? "0" + time.month.toString()
                : time.month.toString()) +
            "-" +
            ((time.day.toString().length == 1)
                ? "0" + time.day.toString()
                : time.day.toString()) +
            "";
      }
      clickCallBack(timeStr, picker.adapter.text);
    });
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter adapter,
    String title,
    List<int> selecteds,
    @required PickerConfirmCallback clickCallBack,
  }) {
    new Picker(
            adapter: adapter,
            title: new Text(
              title ?? "请选择",
              style: TextStyle(color: _kTitleColor, fontSize: _kTextFontSize),
            ),
            selecteds: selecteds,
            cancelText: '取消',
            confirmText: "确定",
            cancelTextStyle:
                TextStyle(color: _kBtnColor, fontSize: _kTextFontSize),
            confirmTextStyle:
                TextStyle(color: _kBtnColor, fontSize: _kTextFontSize),
            textAlign: TextAlign.right,
            itemExtent: _kItemHeigt,
            height: _kPickerHeight,
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: clickCallBack)
        .showModal(context);
  }

  /// 修改生日
  updateUserBirth(String value) async {
    ageV = CommonDate.getAgeFromBirthday(value);
    try {
      var res = await G.req.shop.editBirthReq(
        tk: this.widget.tk,
        birthday: value,
        age: ageV.toString()
      );

      var data = res.data;

      if (data == null) return null;
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // modifyNameBus.fire(new ModifyNameEvent(value));
        setState(() {});
        // G.toast('修改成功');
        // Navigator.pop(context);
      } else {}
    } catch (e) {}
  }

  @override
  void deactivate() {
    super.deactivate();
    // myinfolistBus.fire(new MyinfolistEvent(true));
  }
}
class CityResult {
  /// 省市区
  String province = '';
  String city = '';
  String area = '';

  /// 对应的编码
  String provinceCode = '';
  String cityCode = '';
  String areaCode = '';

  CityResult({
    this.province,
    this.city,
    this.area,
    this.provinceCode,
    this.cityCode,
    this.areaCode,
  });

  CityResult.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
    area = json['area'];
    provinceCode = json['provinceCode'];
    cityCode = json['cityCode'];
    areaCode = json['areaCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datas = new Map<String, dynamic>();
    datas['province'] = this.province;
    datas['city'] = this.city;
    datas['area'] = this.area;
    datas['provinceCode'] = this.provinceCode;
    datas['cityCode'] = this.cityCode;
    datas['areaCode'] = this.areaCode;

    return datas;
  }
}
