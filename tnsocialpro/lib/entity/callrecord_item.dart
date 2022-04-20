
import 'package:flutter/material.dart';
import 'package:tnsocialpro/data/callrecord/data.dart';
import 'package:tnsocialpro/widget/common_widgets.dart';

class CallRecordItem extends StatefulWidget {
  @override
  const CallRecordItem({CallRecordData conv, VoidCallback onTap, int gender, int status})
      : _conv = conv,
        _onTap = onTap,
        _gender = gender,
        _status = status;
  final CallRecordData _conv;
  final VoidCallback _onTap;
  final int _gender, _status;

  _CallRecordItemState createState() => _CallRecordItemState();
}

class _CallRecordItemState extends State<CallRecordItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.grey[300],
      onTap: () => this.widget._onTap(),
      child: Container(
        height: sWidth(95),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Stack(
            //   children: [
            //     // 头像
            //     Positioned(
            //       child: Container(
            //         width: 52,
            //         height: 52,
            //         alignment: Alignment.centerLeft,
            //         margin: EdgeInsets.only(
            //           left: sWidth(20),
            //           top: sHeight(20),
            //           // bottom: sHeight(14),
            //           right: sWidth(15),
            //         ),
            //         child: CircleAvatar(
            //             backgroundImage: (null == _showHeadpic() || _showHeadpic().isEmpty ) ? new AssetImage('images/contact_default_avatar.png') : new NetworkImage(_showHeadpic()),
            //             radius: 50),
            //       ),
            //     ),
            //     // 在线状态
            //     // Positioned(
            //     //   top: sHeight(10),
            //     //   right: sWidth(5),
            //     //   child: unreadCoundWidget(
            //     //     _unreadCount(),
            //     //   ),
            //     // ),
            //   ],
            // ),
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    left: sWidth(20),
                    top: sHeight(20),
                    // bottom: sHeight(14),
                    right: sWidth(15),
                  ),
                  child: new CircleAvatar(
                      backgroundImage: (null == _showHeadpic() || _showHeadpic().isEmpty ) ? new AssetImage('images/contact_default_avatar.png') : new NetworkImage(_showHeadpic()),
                      radius: 50),
                ),
                // (1 == widget._status) ? Positioned(
                //   right: 0,
                //   bottom: 0,
                //   child: Container(
                //     decoration: new BoxDecoration(
                //       // border: new Border.all(color: rgba(38, 231, 236, 1), width: 6), // 边色与边宽度
                //       color: rgba(38, 231, 236, 1), // 底色
                //       shape: BoxShape.circle, // 默认值也是矩形
                //     ),
                //     margin: EdgeInsets.only(left: 5, right: 20),
                //     height: 12,
                //     width: 12,
                //     alignment: Alignment.center,
                //   ),) : Container()
              ],
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 姓名
                  Container(
                    padding: EdgeInsets.only(top: sHeight(24)),
                    child: Text(
                      _showName(),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(69, 65, 103, 1),
                          fontSize: sFontSize(16),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  // 时长
                  Container(
                    margin: EdgeInsets.only(
                        left: sWidth(0), top: sWidth(10)),
                    child: Text(
                      '通话' + this.widget._conv.calllength,
                      maxLines: 1,
                      style: TextStyle(
                          color: Color.fromRGBO(150, 148, 166, 1),
                          fontSize: sFontSize(14),
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 时间点
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // 时间点
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: sWidth(10), right: sWidth(15)),
                    child: Text(
                      this.widget._conv.create_time,
                      maxLines: 1,
                      style: TextStyle(
                          color: Color.fromRGBO(150, 148, 166, 1),
                          fontSize: sFontSize(10),
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  // 图标
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(
                         right: sWidth(23)),
                    child: Image.asset((0 == this.widget._conv.calltype) ? 'assets/images/icon_callvoice.png' : 'assets/images/icon_callvideo.png', height: (0 == this.widget._conv.calltype) ? 21 : 19, width: (0 == this.widget._conv.calltype) ? 16 : 23, fit: BoxFit.fill,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示头像
  String _showHeadpic() {
    return (1 == this.widget._gender) ? this.widget._conv.anthorpic : this.widget._conv.userpic;
  }

  /// 显示的名称
  String _showName() {
    return (1 == this.widget._gender) ? this.widget._conv.anthorname : this.widget._conv.username;
  }

  /// 在线状态
  int _unreadCount() {
    return this.widget._conv.calltype;
  }
}