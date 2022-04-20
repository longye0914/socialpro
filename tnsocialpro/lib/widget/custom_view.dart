import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:tnsocialpro/data/fanslist/data.dart';
import 'package:tnsocialpro/data/userinfo/data.dart';
import 'package:tnsocialpro/data/userlist/data.dart';
import 'package:tnsocialpro/data/visitlist/data.dart';
import 'package:tnsocialpro/data/voicelist/data.dart';
import 'package:tnsocialpro/event/myvoice_event.dart';
import 'package:tnsocialpro/pages/chat/chat_page.dart';
import 'package:tnsocialpro/pages/finishordertippage.dart';
import 'package:tnsocialpro/pages/login_index.dart';
import 'package:tnsocialpro/utils/colors.dart';
import 'package:tnsocialpro/utils/common.dart';
import 'package:tnsocialpro/utils/common_date.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/theme_ui.dart';

typedef ImgBtnFunc = void Function(String);

/**
 * 在线用户列表
 */
class UserCard extends StatelessWidget {
  MyUserData myInfoData;
  String tk, mheadimgV;
  int genderV;
  MyInfoData myInfo;
  UserCard({this.myInfoData, this.tk, this.genderV, this.mheadimgV, this.myInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: rgba(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(left: 11, right: 11),
                    child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            (null == myInfoData ||
                                null == myInfoData.userpic)
                                ? ''
                                : myInfoData.userpic),
                        radius: 11.0),
                  ),
                  (null == myInfoData.type || "3" == myInfoData.type || "4" == myInfoData.type) ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: Colors.grey, // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),) : Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: rgba(38, 231, 236, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(myInfoData.username,
                        style: TextStyle(
                            fontSize: 18,
                            color: rgba(69, 65, 103, 1),
                            fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.age || myInfoData.age.isEmpty) ? '' : myInfoData.age + '岁',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.bodylength || myInfoData.bodylength.isEmpty) ? '' : myInfoData.bodylength + 'cm',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        // margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.path || myInfoData.path.isEmpty) ? '' : myInfoData.path,
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          GestureDetector (
            onTap: () {
              // 聊天
              if (null == myInfoData) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LoginIndex()));
              } else {
                if (null == genderV || genderV == 1) {
                  // 男
                  // 聊天
                  chatConv(context);
                } else {
                  if (1 == myInfo.infoflag && 1 == myInfo.picflag && 1 == myInfo.voiceflag && 1 == myInfo.taskflag) {
                    // 聊天
                    chatConv(context);
                  } else {
                    // 完成接单设置
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                            new FinishOrdertipPage(tk, myInfo)));
                  }
                }
              }
            },
            child: Container(
              height: 30,
              width: 65,
              margin: EdgeInsets.only(right: 17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: rgba(69, 65, 103, 1),
                  borderRadius: BorderRadius.all(Radius.circular(17))),
              child: Text('聊天',
                  style: TextStyle(
                      fontSize: 14,
                      color: rgba(255, 255, 255, 1),
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(myInfoData.phone);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new ChatPage(
            tk,
            genderV,
            myInfoData.id,
            myInfoData.username,
            myInfoData.userpic,
            (null == myInfoData.priimset) ? '' : myInfoData.priimset.split('B')[0],
            mheadimgV,
            conv
        ),
      ),
    ).then((value) {
    });
    // Navigator.of(context).pushNamed(
    //   '/chat',
    //   arguments: [myInfoData.username, conv],
    // ).then((value) {
    // });
  }
}

/**
 * 最近来访列表
 */
class UserVisitCard extends StatelessWidget {
  Visitlist myInfoData;
  String tk, mheadimgV;
  int genderV;
  MyInfoData myInfo;
  UserVisitCard({this.myInfoData, this.tk, this.genderV, this.mheadimgV, this.myInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: rgba(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(left: 11, right: 11),
                    child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            (null == myInfoData ||
                                null == myInfoData.userpic)
                                ? ''
                                : myInfoData.userpic),
                        radius: 11.0),
                  ),
                  (null == myInfoData.shopUser.type || "3" == myInfoData.shopUser.type || "4" == myInfoData.shopUser.type) ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: Colors.grey, // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),) : Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: rgba(38, 231, 236, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(myInfoData.username,
                        style: TextStyle(
                            fontSize: 18,
                            color: rgba(69, 65, 103, 1),
                            fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.age || myInfoData.shopUser.age.isEmpty) ? '' : myInfoData.shopUser.age + '岁',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.bodylength || myInfoData.shopUser.bodylength.isEmpty) ? '' : myInfoData.shopUser.bodylength + 'cm',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        // margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.path || myInfoData.shopUser.path.isEmpty) ? '' : myInfoData.shopUser.path,
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(bottom: 10, right: 0),
                child: Text(CommonDate.timeUtils(myInfoData.create_time), style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 10),),
              ),
              GestureDetector (
                onTap: () {
                  // 聊天
                  if (null == myInfoData) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LoginIndex()));
                  } else {
                    if (null == genderV || genderV == 1) {
                      // 男
                      // 聊天
                      chatConv(context);
                    } else {
                      if (1 == myInfo.infoflag && 1 == myInfo.picflag && 1 == myInfo.voiceflag && 1 == myInfo.taskflag) {
                        // 聊天
                        chatConv(context);
                      } else {
                        // 完成接单设置
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                new FinishOrdertipPage(tk, myInfo)));
                      }
                    }
                  }
                },
                child: Container(
                  height: 30,
                  width: 65,
                  margin: EdgeInsets.only(right: 17),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: rgba(69, 65, 103, 1),
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                  child: Text('聊天',
                      style: TextStyle(
                          fontSize: 14,
                          color: rgba(255, 255, 255, 1),
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(myInfoData.shopUser.phone);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new ChatPage(
            tk,
            genderV,
            myInfoData.id,
            myInfoData.username,
            myInfoData.userpic,
            (null == myInfoData.shopUser || null == myInfoData.shopUser.priimset) ? '' : myInfoData.shopUser.priimset.split('B')[0],
            mheadimgV,
            conv
        ),
      ),
    ).then((value) {
    });
  }
}

/**
 * 喜欢我列表
 */
class UserFansCard extends StatelessWidget {
  Fanslist myInfoData;
  String tk, mheadimgV;
  int genderV;
  MyInfoData myInfo;
  UserFansCard({this.myInfoData, this.tk, this.genderV, this.mheadimgV, this.myInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: rgba(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(left: 11, right: 11),
                    child: new CircleAvatar(
                        backgroundImage: new NetworkImage(
                            (null == myInfoData ||
                                null == myInfoData.userpic)
                                ? ''
                                : myInfoData.userpic),
                        radius: 11.0),
                  ),
                  (null == myInfoData.shopUser.type || "3" == myInfoData.shopUser.type || "4" == myInfoData.shopUser.type) ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: rgba(38, 231, 236, 1), // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),) : Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: new BoxDecoration(
                        // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                        color: Colors.grey, // 底色
                        shape: BoxShape.circle, // 默认值也是矩形
                      ),
                      margin: EdgeInsets.only(left: 5, right: 20),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                    ),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(myInfoData.username,
                        style: TextStyle(
                            fontSize: 18,
                            color: rgba(69, 65, 103, 1),
                            fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.age || myInfoData.shopUser.age.isEmpty) ? '' : myInfoData.shopUser.age + '岁',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.bodylength || myInfoData.shopUser.bodylength.isEmpty) ? '' : myInfoData.shopUser.bodylength + 'cm',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        // margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData || null == myInfoData.shopUser.path || myInfoData.shopUser.path.isEmpty) ? '' : myInfoData.shopUser.path,
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(bottom: 10, right: 20),
                child: Text(CommonDate.timeUtils(myInfoData.create_time), style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 10),),
              ),
              GestureDetector (
                onTap: () {
                  // 聊天
                  if (null == myInfoData) {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LoginIndex()));
                  } else {
                    if (null == genderV || genderV == 1) {
                      // 男
                      // 聊天
                      chatConv(context);
                    } else {
                      if (1 == myInfo.infoflag && 1 == myInfo.picflag && 1 == myInfo.voiceflag && 1 == myInfo.taskflag) {
                        // 聊天
                        chatConv(context);
                      } else {
                        // 完成接单设置
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                new FinishOrdertipPage(tk, myInfo)));
                      }
                    }
                  }
                },
                child: Container(
                  height: 30,
                  width: 65,
                  margin: EdgeInsets.only(right: 17),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: rgba(69, 65, 103, 1),
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                  child: Text('聊天',
                      style: TextStyle(
                          fontSize: 14,
                          color: rgba(255, 255, 255, 1),
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(myInfoData.shopUser.phone);
    if (null != myInfoData) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new ChatPage(
              tk,
              genderV,
              myInfoData.id,
              myInfoData.username,
              myInfoData.userpic,
              (null == myInfoData.shopUser || null == myInfoData.shopUser.priimset) ? '' : myInfoData.shopUser.priimset.split('B')[0],
              mheadimgV,
              conv
          ),
        ),
      ).then((value) {
      });
    }
  }
}

/**
 * 看过我  我喜欢用户列表
 */
class MyUserCard extends StatelessWidget {
  MyUserData myInfoData;
  String tk, mheadimgV;
  int genderV;
  MyInfoData myInfo;
  MyUserCard({this.myInfoData, this.tk, this.genderV, this.mheadimgV, this.myInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
          color: rgba(245, 245, 245, 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(left: 11, right: 11),
                child: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                        (null == myInfoData ||
                            null == myInfoData.userpic || myInfoData.userpic.isEmpty)
                            ? ''
                            : myInfoData.userpic),
                    radius: 11.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text((null == myInfoData ||
                        null == myInfoData.username || myInfoData.username.isEmpty)
                        ? ''
                        : myInfoData.username,
                        style: TextStyle(
                            fontSize: 18,
                            color: rgba(69, 65, 103, 1),
                            fontWeight: FontWeight.w500)),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData ||
                            null == myInfoData.age || myInfoData.age.isEmpty)
                            ? ''
                            : myInfoData.age + '岁',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData ||
                            null == myInfoData.bodylength || myInfoData.bodylength.isEmpty)
                            ? ''
                            : myInfoData.bodylength + 'cm',
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        // margin: EdgeInsets.only(right: 6),
                        child: Text((null == myInfoData ||
                            null == myInfoData.path || myInfoData.path.isEmpty)
                            ? ''
                            : myInfoData.path,
                            style: TextStyle(
                                fontSize: 13,
                                color: rgba(150, 148, 166, 1),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // 聊天
              if (null == myInfoData) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LoginIndex()));
              } else {
                if (null == genderV || genderV == 1) {
                  // 男
                  // 聊天
                  chatConv(context);
                } else {
                  if (1 == myInfo.infoflag && 1 == myInfo.picflag && 1 == myInfo.voiceflag && 1 == myInfo.taskflag) {
                    // 聊天
                    chatConv(context);
                  } else {
                    // 完成接单设置
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                            new FinishOrdertipPage(tk, myInfo)));
                  }
                }
              }
            },
            child: Container(
              height: 30,
              width: 65,
              margin: EdgeInsets.only(right: 17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: rgba(69, 65, 103, 1),
                  borderRadius: BorderRadius.all(Radius.circular(17))),
              child: Text('聊天',
                  style: TextStyle(
                      fontSize: 14,
                      color: rgba(255, 255, 255, 1),
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  chatConv(BuildContext context) async {
    EMConversation conv = await EMClient.getInstance.chatManager
        .getConversation(myInfoData.phone);
    if (null != myInfoData) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new ChatPage(
              tk,
              genderV,
              myInfoData.id,
              myInfoData.username,
              myInfoData.userpic,
              (null == myInfoData.priimset) ? '' : myInfoData.priimset.split('B')[0],
              mheadimgV,
              conv
          ),
        ),
      ).then((value) {
      });
    }
    // Navigator.of(context).pushNamed(
    //   '/chat',
    //   arguments: [myInfoData.username, conv],
    // ).then((value) {
    // });
  }
}

/**
 * 男 首页用户列表
 */
class MainUserCard extends StatelessWidget {
  MyUserData myInfoData;
  String tk;
  MainUserCard({this.myInfoData, this.tk});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      // decoration: BoxDecoration(
      //     color: rgba(255, 255, 255, 1),
      //     borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 270,
            width: double.infinity,
            alignment: Alignment.topRight,
            decoration: new BoxDecoration(
              color: Colors.grey,
              // border: new Border.all(width: 2.0, color: Colors.transparent),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              image: new DecorationImage(
                image: new NetworkImage((null == myInfoData.userpic || myInfoData.userpic.isEmpty) ? '' : myInfoData.userpic),
                fit: BoxFit.cover
                //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
                // centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
              ),
            ),
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: 8),
                    width: 120,
                    child: Text((null == myInfoData.username || myInfoData.username.isEmpty) ? '' : myInfoData.username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18, color: rgba(255, 255, 255, 1),fontWeight: FontWeight.w500)),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 22,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: rgba(209, 99, 242, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(18),
                            )),
                        margin: EdgeInsets.only(left: 0),
                        child: Text(
                            (null == myInfoData.age || myInfoData.age.isEmpty)
                                ? '未知'
                                : myInfoData.age + '岁',
                            style: TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                      Container(
                        height: 22,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: rgba(242, 197, 99, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(18),
                            )),
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                            (myInfoData.bodylength == null || myInfoData.bodylength.isEmpty)
                                ? '未知'
                                : myInfoData.bodylength + 'cm',
                            style: TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                      Container(
                        height: 22,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: rgba(99, 182, 242, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(18),
                            )),
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                            (myInfoData.path == null || myInfoData.path.isEmpty)
                                ? '未知'
                                : myInfoData.path,
                            style: TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
          Container(
            height: 110,
            // color: rgba(255, 255, 255, 1),
            decoration: BoxDecoration(
                color: rgba(255, 255, 255, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                )),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 36,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: rgba(245, 245, 245, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(18),
                          )),
                      margin: EdgeInsets.only(top: 10, left: 15),
                      child: Row(
                        children: [
                          Container(
                            height: 13,
                            width: 11,
                            margin: EdgeInsets.only(left: 17),
                            child: Image.asset(
                              'assets/images/icon_female.png',
                              height: 16,
                              width: 16,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text('语音',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                          (null == myInfoData.voiceset || myInfoData.voiceset.isEmpty) ? Container() : Container(
                            margin: EdgeInsets.only(left: 23),
                            child: Text(myInfoData.voiceset.split('B')[0],
                                style: TextStyle(
                                    fontSize: 18,
                                    color: rgba(234, 117, 187, 1),
                                    fontWeight: FontWeight.w500)),
                          ),
                          (null == myInfoData.voiceset || myInfoData.voiceset.isEmpty) ? Container() : Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text('甜甜券/分钟',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: rgba(69, 65, 103, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                    (null == myInfoData.type || "3" == myInfoData.type || "4" == myInfoData.type) ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(left: 23),
                            child: Text('离线',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: rgba(150, 148, 166, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                          Container(
                            decoration: new BoxDecoration(
                              // border: new Border.all(color: Colors.white, width: 6), // 边色与边宽度
                              color: Colors.grey, // 底色
                              shape: BoxShape.circle, // 默认值也是矩形
                            ),
                            margin: EdgeInsets.only(left: 5, right: 20),
                            height: 6,
                            width: 6,
                            alignment: Alignment.center,
                          ),
                        ]) : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(left: 23),
                            child: Text('在线',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: rgba(150, 148, 166, 1),
                                    fontWeight: FontWeight.w400)),
                          ),
                          Container(
                            decoration: new BoxDecoration(
                              // border: new Border.all(color: Colors.white, width: 6), // 边色与边宽度
                              color: rgba(38, 231, 236, 1), // 底色
                              shape: BoxShape.circle, // 默认值也是矩形
                            ),
                            margin: EdgeInsets.only(left: 5, right: 20),
                            height: 6,
                            width: 6,
                            alignment: Alignment.center,
                          ),
                        ]),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text((null == myInfoData.myselfintro || myInfoData.myselfintro.isEmpty) ? '' : myInfoData.myselfintro,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          color: rgba(69, 65, 103, 1),
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/**
 * 音频列表
 */
class VoiceCard extends StatelessWidget {
  Voicelist myInfoData;
  String tk;
  int index, idNow;
  VoiceCard({this.myInfoData, this.tk, this.index, this.idNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 70,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            decoration: new BoxDecoration(
              // color: Colors.grey,
              // border: new Border.all(width: 2.0, color: Colors.transparent),
              // borderRadius: new BorderRadius.all(new Radius.circular(0)),
              image: new DecorationImage(
                image: new AssetImage('assets/images/icon_voiceplaybg.png'),),),
            // decoration: BoxDecoration(
            //     color: rgba(255, 255, 255, 1),
            //     borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(left: 23, right: 13),
                      child: Image.asset('assets/images/icon_voiceplay.png'),
                    ),
                    Container(
                      width: 116,
                      height: 23,
                      margin: EdgeInsets.only(right: 15),
                      child: Image.asset('assets/images/icon_voiceplaytip.png'),
                    ),
                    Container(
                      child: Text(myInfoData.voicetime.toString() + 's',
                          style: TextStyle(
                              fontSize: 16,
                              color: rgba(255, 255, 255, 1),
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // 更多
                    _showPopupMenu(context, index, myInfoData);
                  },
                  child: Container(
                    width: 25,
                    height: 20,
                    margin: EdgeInsets.only(right: 13),
                    child: Image.asset('assets/images/icon_voiceplaymore.png'),
                  ),
                ),
              ],
            ),
          ),
          (1 == myInfoData.showflag) ? Container(
            height: 22,
            width: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: rgba(150, 148, 166, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(18),
                )),
            margin: EdgeInsets.only(left: 25, bottom: 70),
            child: Text('展示',
                style: TextStyle(
                    fontSize: 10, color: rgba(255, 255, 255, 1))),
          ) : Container(),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context, int index, Voicelist voiceData) {
    showDialog(
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: (180 + double.parse(index.toString())*90),
                right: 15,
                width: 150,
                child: Material(
                  color: rgba(209, 99, 242, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(5),
                    //   color: rgba(76, 76, 76, 1),
                    // ),
                    height: 102,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // 展示/取消展示
                            Navigator.of(context).pop();
                            setShowUserVoice(myInfoData.id, (1 == myInfoData.showflag) ? 0 : 1);
                          },
                          child: Container(
                            height: 50,
                            width: 90,
                            alignment: Alignment.center,
                            child: Text((1 == voiceData.showflag) ? '取消展示' : '展示',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: rgba(255, 255, 255, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          color: rgba(255, 255, 255, 1),
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            // 删除
                            Navigator.of(context).pop();
                            deleteUserVoice(myInfoData.id);
                          },
                          child: Container(
                            height: 50,
                            width: 90,
                            alignment: Alignment.center,
                            child: Text('删除',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: rgba(255, 255, 255, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  /// 删除用户音频
  deleteUserVoice(int id) async {
    try {
      var res = await G.req.shop.deleteVoiceReq(
          tk: tk,
          id: id
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          myvoiceBus.fire(new MyVoiceEvent(''));
        }
      }
    } catch (e) {}
  }

  /// 设置展示
  setShowUserVoice(int id, int showflag) async {
    try {
      var res = await G.req.shop.handleVoiceReq(
          tk: tk,
          id: id,
          showflag: showflag
      );
      if (res.data != null) {
        int code = res.data['code'];
        if (20000 == code) {
          if (idNow != id) {
            try {
              var res = await G.req.shop.handleVoiceReq(
                  tk: tk,
                  id: idNow,
                  showflag: 0
              );
              if (res.data != null) {
                int code = res.data['code'];
                if (20000 == code) {
                  myvoiceBus.fire(new MyVoiceEvent(''));
                }
              }
            } catch (e) {}
          }
          myvoiceBus.fire(new MyVoiceEvent(''));
        }
      }
    } catch (e) {}
  }
}

/**
 * 我的数据
 */
class MydataCard extends StatelessWidget {
  final String title;
  final String remark;
  final String headPic;
  MydataCard({this.title, this.remark, this.headPic});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 120,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 160,
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: NetworkImage(headPic),
                        fit: BoxFit.cover,
                      ),
                      color: Colours.light_grey,
                      border: Border.all(color: Colours.light_grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          child: IconButton(
                              alignment: Alignment.center,
                              iconSize: 30,
                              padding: EdgeInsets.only(top: 25),
                              icon: Image.asset(
                                  Constant.ASSETS_IMG + 'ic_playing.png')),
                        ),
                      ],
                    ),
                  ),
//                  child: Container(
//                    height: 92,
//                    width: 160,
//                    margin: EdgeInsets.all(10),
//                    decoration: new BoxDecoration(
//                      border: new Border.all(color: Colors.white, width: 1), // 边色与边宽度
//                      color: Colors.transparent, // 底色
//                      shape: BoxShape.rectangle, // 默认值也是矩形
//                    ),
//                    alignment: Alignment.center,
//                    child: (null == headPic || "" == headPic) ? Image.asset(
//                      'lib/assets/images/home/banner_default.png',
//                      height: 74,
//                      width: 95,
//                      fit: BoxFit.cover,
//                    ) :Image.network(
//                      headPic,
//                      height: 91,
//                      width: 151,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 0, top: 10, bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 5, right: 0, top: 0, bottom: 3),
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colours.backbg,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 5, right: 1, top: 5, bottom: 5),
                            child: Text(
                              // .replaceAll("&lt;", "").replaceAll("p&gt;", "").replaceAll('/', "")
                              remark,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14, color: Colours.lightback),
                            ),
                          ),
                        ]),
                  ),
                  flex: 2,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 6),
              height: 1,
              color: Colours.light_grey,
            )
          ],
        ));
  }
}

/**
 * 生活档案列表
 */
class LifeCard extends StatelessWidget {
  final String title;
  final String remark;
  LifeCard({this.title, this.remark});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 44.5,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 30, right: 1),
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                            TextStyle(fontSize: 14, color: Colours.text_gray),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 10.0),
                    child: Text(
                      remark,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, color: Colours.backbg),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                      margin:
                          EdgeInsets.only(right: 30.0, top: 10.0, bottom: 10),
                      height: 12,
                      width: 12,
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/icon_right.png')),
                  flex: 1,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 6),
              height: 1,
              color: Colours.light_grey,
            )
          ],
        ));
  }
}

/**
 * 提现明细列表
 */
class WithdrawCard extends StatelessWidget {
  final String withdrawmon;
  final String createTime;
  final int applystatus;
  WithdrawCard({this.withdrawmon, this.createTime, this.applystatus});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 65,
//        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1),
                      child: Text(
                        '提现',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                        TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32),
                    child: Text(
                      '-' + (double.parse(withdrawmon)*100).toString().substring(0, (double.parse(withdrawmon)*100).toString().length - 2),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 12),
                      child: Text(
                        createTime,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                            TextStyle(fontSize: 12, color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32, top: 6),
                    child: Text(
                      '¥' + withdrawmon.toString(),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14, color: rgba(150, 148, 166, 1)),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32, top: 6),
                    child: Text(
                      (0 == applystatus) ? '提现申请中' : (1 == applystatus) ? '提现成功' : '提现失败',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14, color: rgba(150, 148, 166, 1)),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 32, right: 32, top: 12),
              height: 1,
              color: rgba(241, 241, 242, 1),
            ),
          ],
        ));
  }
}

/**
 * 收入明细列表
 */
class InComeCard extends StatelessWidget {
  final String withdrawmon;
  final String username;
  final String createTime;
  final int itemtype;
  InComeCard({this.withdrawmon, this.username, this.createTime, this.itemtype});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        // height: 65,
//        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 10),
                      child: Text.rich(
                        new TextSpan(
                            text: '与',
                            style: new TextStyle(
                                color: rgba(150, 148, 166, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: username,
                                  style: new TextStyle(
                                      color: rgba(69, 65, 103, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none, overflow: TextOverflow.ellipsis),),
                              new TextSpan(
                                  text: (0 == itemtype) ? '语音通话' : (1 == itemtype) ? '视频通话' : '私聊',
                                  style: new TextStyle(
                                      color: rgba(150, 148, 166, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none)),
                            ]),
                      ),
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32, top: 10),
                    child: Text(
                      '+' + (withdrawmon).toString(),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 15),
                      child: Text(
                        createTime,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                        TextStyle(fontSize: 12, color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 32, right: 32, top: 12),
              height: 1,
              color: rgba(241, 241, 242, 1),
            ),
          ],
        ));
  }
}

/**
 * 充值明细列表
 */
class PayoutCard extends StatelessWidget {
  final String withdrawmon;
  final String createTime;
  PayoutCard({this.withdrawmon, this.createTime});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 65,
//        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1),
                      child: Text(
                        '充值',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                        TextStyle(fontSize: 16, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32),
                    child: Text(
                      '+' + (double.parse(withdrawmon)*100).toString().substring(0, (double.parse(withdrawmon)*100).toString().length - 2),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 12),
                      child: Text(
                        createTime,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                        TextStyle(fontSize: 12, color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32, top: 6),
                    child: Text(
                      '¥' + withdrawmon.toString(),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14, color: rgba(150, 148, 166, 1)),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 32, right: 32, top: 12),
              height: 1,
              color: rgba(241, 241, 242, 1),
            ),
          ],
        ));
  }
}

/**
 * 支出明细列表
 */
class ConsumeCard extends StatelessWidget {
  final String withdrawmon;
  final String username;
  final String createTime;
  final int itemtype;
  ConsumeCard({this.withdrawmon, this.username, this.createTime, this.itemtype});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        // height: 65,
//        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 10),
                      child: Text.rich(
                        new TextSpan(
                            text: '与',
                            style: new TextStyle(
                                color: rgba(150, 148, 166, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: username,
                                  style: new TextStyle(
                                      color: rgba(69, 65, 103, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none)),
                              new TextSpan(
                                  text: (0 == itemtype) ? '语音通话' : (1 == itemtype) ? '视频通话' : '私聊',
                                  style: new TextStyle(
                                      color: rgba(150, 148, 166, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none)),
                            ]),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 1, right: 32, top: 10),
                    child: Text(
                      '-' + (withdrawmon).toString(),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18, color: rgba(69, 65, 103, 1), fontWeight: FontWeight.w500),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 1, top: 15),
                      child: Text(
                        createTime,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style:
                        TextStyle(fontSize: 12, color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 32, right: 32, top: 12),
              height: 1,
              color: rgba(241, 241, 242, 1),
            ),
          ],
        ));
  }
}