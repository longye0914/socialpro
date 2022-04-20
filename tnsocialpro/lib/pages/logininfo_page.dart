
import 'package:color_dart/color_dart.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/pages/tab_navigate.dart';
import 'package:tnsocialpro/utils/JhPickerTool.dart';
import 'package:tnsocialpro/utils/common_date.dart';
import 'package:tnsocialpro/utils/constants.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/utils/image_utils.dart';
import 'package:tnsocialpro/widget/bottom_sheet.dart';
import 'package:tnsocialpro/widget/row_noline.dart';
import 'mainunlock_page.dart';

String contentName;
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

class LogininfoPage extends StatefulWidget {
  String tk;
  int gender;
  LogininfoPage(this.tk, this.gender);
  _LogininfoPageState createState() => _LogininfoPageState();
}

class _LogininfoPageState extends State<LogininfoPage> {

  TextEditingController _nameController = TextEditingController();
  String _birthdate, bodylength, headImg, defalutDayStr, phone;
  List<String> picList = ['https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/3.jpg', 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/1.jpg', 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/2.jpg', 'https://tangzhe123-com.oss-cn-shenzhen.aliyuncs.com/Appstatic/qsbk/demo/datapic/3.jpg'];
  int index = 0;
  var _imgPath;
  SharedPreferences prefs;
  int userId;
  MyInfoData myInfoData;
  int ageV = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: rgba(255, 255, 255, 1),
        appBar: AppBar(
          centerTitle: true,
          // title: Text(
          //   '充值',
          //   style: TextStyle(
          //   color: rgba(69, 65, 103, 1),
          //   fontSize: 18,
          //   fontWeight: FontWeight.w600),
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: context == null
          ? new Container()
              : InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                'assets/images/icon_back.png',
                ),
              ),
          ]),
          onTap: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            child: Container(
            decoration: BoxDecoration(border: G.borderBottom(show: false)),
            ),
            preferredSize: Size.fromHeight(0),
            ),
            actions: <Widget>[
              (1 == widget.gender) ? GestureDetector(
                child: Container(
                height: 30,
                width: 50,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 30),
                child: Text(
                '跳过',
                style: TextStyle(
                color: rgba(69, 65, 103, 1),
                fontWeight: FontWeight.w400,
                fontSize: 16),
                ),
            ),
            onTap: () {
              // 跳过
              Navigator.pop(context);
              },
            ) : Container(),
          ],
        ),
        body: Container(
            width: double.infinity,
            // height: double.infinity,
            color: rgba(255, 255, 255, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 32,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text((1 == widget.gender) ? '完善个人信息' : '基本资料', style: TextStyle(color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w600, fontSize: 23),),
                ),
                Stack(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      margin: EdgeInsets.only(top: 20, bottom: 0),
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                          backgroundImage: (null == headImg ||
                              headImg.isEmpty)
                              ? new AssetImage('assets/images/icon_femalehead.png') : new NetworkImage(headImg),
                          radius: 50),
                    ),
                    Positioned(
                        right: 5,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
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
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 20,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text((1 == widget.gender) ? '上传真实头像能获得更多关注哦' : '请上传真实头像，系统将进行审核', style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 13),),
                ),
                (1 == widget.gender) ? Container(
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 随机图片
                          if (index < picList.length - 1) {
                            index ++;
                            headImg = picList[index];
                          } else {
                            index = 0;
                            headImg = picList[0];
                          }
                          setState(() {
                          });
                          updateHeadimgInfo(headImg);
                        },
                        child: Image.asset(
                          'assets/images/icon_randomchoose.png',
                          height: 16,
                          width: 16,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                            '随机',
                            style: TextStyle(
                                fontSize: 13, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w400)),
                      )
                    ],
                  ),
                ) : Container(),
                Container(
                  height: 64,
                  margin: EdgeInsets.only(left: 40, right: 33, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 64,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 24),
                        child: Text('昵称',
                            style: TextStyle(
                                fontSize: 16,
                                color: rgba(69, 65, 103, 1),
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        height: 64,
                        width: 70,
                        padding: EdgeInsets.only(top: 24),
                        // padding: EdgeInsets.only(left: 130),
                        alignment: Alignment.centerRight,
                        child: TextField(
                          maxLength: 20,
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: '请输入昵称',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: rgba(218, 215, 229, 1),
                                  fontWeight: FontWeight.w400)),
                          onChanged: (e) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: rgba(241, 241, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 0.5,
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
                    rightChild: Container(
                      height: 64,
                      alignment: Alignment.center,
                      child: Text(
                        null == _birthdate ||
                            _birthdate.isEmpty
                            ? ((null == defalutDayStr || defalutDayStr.isEmpty) ? '' : defalutDayStr)
                            : _birthdate,
                        style: TextStyle(
                            fontSize: 14,
                            color: rgba(218, 215, 229, 1),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onPressed: () {
                      showDatePicker(context,
                          clickCallBack: (var str, var time) {
                            setState(() {
                              _birthdate = str;
                              ageV = CommonDate.getAgeFromBirthday(_birthdate);
                            });
                          });
                    }),
                Container(
                  color: rgba(241, 241, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 0.5,
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
                    rightChild: Container(
                      height: 64,
                      alignment: Alignment.center,
                      child: Text(
                        null == bodylength ||
                            bodylength.isEmpty
                            ? '请选择'
                            : bodylength + 'cm',
                        style: TextStyle(
                            fontSize: 14,
                            color: rgba(218, 215, 229, 1),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onPressed: () {
                      // 身高
                      // Pickers.showSinglePicker(context,
                      //     data: ['160', '165', '170', '175', '180', '185', '190', '195'],
                      //     selectData: bodylength,
                      //     onConfirm: (p, position) {
                      //       setState(() {
                      //         bodylength = p;
                      //       });
                      //     },
                      //     // onChanged: (p) => print('数据发生改变：$p')
                      // );
                      var aa = ['160', '165', '170', '175', '180', '185', '190', '195'];
                      JhPickerTool.showStringPicker(context,
                          data: aa,
                          clickCallBack: (int index,var str){
                            setState(() {
                              bodylength = str;
                            });
                            // print(index);
                            // print(str);
                          }
                      );
                    }),
                Container(
                  color: rgba(241, 241, 242, 1),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    // if (_nameController.text.toString().isNotEmpty || _birthdate.isNotEmpty || bodylength.isNotEmpty) {
                    //   Fluttertoast.showToast(msg: '请填写个人信息');
                    //   return;
                    // }
                    // 开启邂逅
                    updateUserInfo();
                  },
                  child: Container(
                    width: 290,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage((_nameController.text.toString().isNotEmpty || null != _birthdate || null != bodylength) ? 'assets/images/icon_surechoosed.png' : 'assets/images/icon_sureunchoose.png'),
                        //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                        // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 64),
                    child: Text(
                      '开启邂逅',
                      style: TextStyle(
                          color: rgba(255, 255, 255, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            )
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('account_id');
      var timeVal = DateTime.now();
      defalutDayStr = timeVal.year.toString() + '-' + ((timeVal.month.toString().length > 1) ? timeVal.month.toString() : '0' + timeVal.month.toString()) + '-' + ((timeVal.day.toString().length > 1) ? timeVal.day.toString() : '0' + timeVal.day.toString());
      ageV = CommonDate.getAgeFromBirthday(defalutDayStr);
      getUserInfo();
    });
  }
  // 根据出生日期获取年龄
  int getAgeFromBirthday(String strBirthday) {
    if(strBirthday == null || strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age --;
    }
    return age;
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
        // G.loadingomm.show(context);
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
      var res = await G.req.shop.editHeadimgReq(
          tk: this.widget.tk,
          userpic: picUrl
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        getUserInfo();
        // EMUserInfo userInfo = EMClient.getInstance.userInfoManager.getCurrentUserInfo() as EMUserInfo;
        // userInfo.avatarUrl = picUrl;
        // EMClient.getInstance.userInfoManager.updateOwnUserInfo(userInfo);
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
    }
  }

  /// 开启邂逅
  updateUserInfo() async {
    // if (null == value || value.isEmpty) {
    //   G.toast('用户名不能为空');
    //   return;
    // }
    try {
      var res = await G.req.shop.editLoginInfoeq(
        tk: this.widget.tk,
        username: _nameController.text.toString(),
        birthday: (null == _birthdate || _birthdate.isEmpty) ? defalutDayStr : _birthdate,
        bodylength: bodylength,
        age: ageV.toString()
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        // G.toast('修改成功');
        Navigator.pop(context);
        if (1 == widget.gender) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new MainUnlockPage(widget.tk, widget.gender, phone)));
        } else {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TabNavigate(widget.tk, phone, widget.gender)));
        }
        // EMUserInfo userInfo = EMClient.getInstance.userInfoManager.getCurrentUserInfo() as EMUserInfo;
        // userInfo.nickName = _nameController.text.toString();
        // EMClient.getInstance.userInfoManager.updateOwnUserInfo(userInfo);
      } else {
        G.toast('邂逅失败');
      }
    } catch (e) {
      G.toast('邂逅失败');
    }
  }

  /// 获取个人信息
  getUserInfo() async {
    try {
      var res = await G.req.shop.getUserInfoReq(
        tk: widget.tk,
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          setState(() {
            myInfoData = MyInfoParent.fromJson(res.data).data;
            if (null != myInfoData) {
              _birthdate = myInfoData.birthday;
              bodylength = myInfoData.bodylength;
              headImg = myInfoData.userpic;
              phone = myInfoData.phone;
              if (1 == widget.gender) {
                if (null == headImg) {
                  headImg = 'http://r2021dv7p.hn-bkt.clouddn.com/code/duck/2021-11-07-1fac3accaafc439999f789d01f99099c.jpg';
                }
              }
            }
          });
        }
      }
    } catch (e) {}
  }
}