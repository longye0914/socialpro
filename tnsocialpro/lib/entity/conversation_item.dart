
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:tnsocialpro/utils/common_date.dart';
import 'package:tnsocialpro/widget/common_widgets.dart';
import 'package:tnsocialpro/widget/wx_expression.dart';

class ConversationItem extends StatefulWidget {
  @override
  const ConversationItem({EMConversation conv, VoidCallback onTap})
      : _conv = conv,
        _onTap = onTap;
  final EMConversation _conv;
  final VoidCallback _onTap;

  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
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
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                // 头像
                Positioned(
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: 20,
                      top: 20,
                      // bottom: sHeight(14),
                      right: 15,
                    ),
                    child: new CircleAvatar(
                        backgroundImage: (widget._conv.ext['userpic'].toString().isEmpty) ? new AssetImage('images/contact_default_avatar.png') : new NetworkImage(widget._conv.ext['userpic'].toString()),
                        radius: 50),
                  )
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // 姓名
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            _showName(),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        // 时间
                        Container(
                          margin: EdgeInsets.only(
                              left: 5, right: 20, top: 26),
                          child: Text(
                            _latestMessageTime(),
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 详情
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // 详情
                        Container(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            _showInfo(),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(150, 148, 166, 1),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // 未读
                        Container(
                          margin: EdgeInsets.only(
                              left: 5, right: 15),
                          child: unreadCoundWidget(
                            _unreadCount(),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(
                        //       left: 5, right: 23),
                        //   child: Positioned(
                        //     top: 10,
                        //     right: 5,
                        //     child: unreadCoundWidget(
                        //       _unreadCount(),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 消息详情
  String _showInfo() {
    String showInfo = '';
    EMMessage _latestMesage = this.widget._conv.latestMessage;
    if (_latestMesage == null) {
      return showInfo;
    }

    switch (_latestMesage.body.type) {
      case EMMessageBodyType.TXT:
        var body = _latestMesage.body as EMTextMessageBody;
        showInfo = body.content;
        break;
      case EMMessageBodyType.IMAGE:
        showInfo = '[图片]';
        break;
      case EMMessageBodyType.VIDEO:
        showInfo = '[视频]';
        break;
      case EMMessageBodyType.FILE:
        showInfo = '[文件]';
        break;
      case EMMessageBodyType.VOICE:
        showInfo = '[语音]';
        break;
      case EMMessageBodyType.LOCATION:
        showInfo = '[位置]';
        break;
      default:
        showInfo = '';
    }
    return showInfo;
  }

  /// 显示的名称
  String _showName() {
    return this.widget._conv.name;
  }

  /// 未读数
  int _unreadCount() {
    return this.widget._conv.unreadCount;
  }

  /// 消息时间
  String _latestMessageTime() {
    if (this.widget._conv.latestMessage == null) {
      return '';
    }
    return CommonDate.timeShowUtils(this.widget._conv.latestMessage?.serverTime ?? 0);
  }
}
