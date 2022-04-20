import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/event/modifybody_event.dart';
import 'package:tnsocialpro/event/modifyname_event.dart';
import 'package:tnsocialpro/utils/global.dart';
import 'package:tnsocialpro/widget/a_button.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';

String contentName;

class ModifyBodyheiPage extends StatefulWidget {
  String titleName, tk, name;
  ModifyBodyheiPage(
      {Key key,
      @required this.titleName,
      @required this.tk,
      @required this.name})
      : super(key: key);
  _ModifyBodyheiPageState createState() => _ModifyBodyheiPageState();
}

class _ModifyBodyheiPageState extends State<ModifyBodyheiPage> {
  // TextEditingController _contentEtController = TextEditingController();
  TextEditingController _contentEtController;

  @override
  void initState() {
    super.initState();
    contentName = widget.name;
    _contentEtController = TextEditingController.fromValue(TextEditingValue(
        text: (null == contentName || contentName.isEmpty)
            ? ''
            : contentName, //判断keyword是否为空
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: (null == contentName || contentName.isEmpty)
                ? 0
                : contentName.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: rgba(255, 255, 255, 1),
      appBar: customAppbar(
          context: context, borderBottom: false, title: widget.titleName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            color: rgba(255, 255, 255, 1),
            margin: EdgeInsets.all(18),
            alignment: Alignment.centerLeft,
            child: AButton.normal(
              width: 338,
              height: 60,
              plain: true,
              bgColor: rgba(255, 255, 255, 1),
              padding: EdgeInsets.only(left: 20, right: 20),
              borderColor: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                // maxLength: 50,
                controller: _contentEtController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.deepPurpleAccent,
                autofocus: true,
                decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: rgba(0, 0, 0, 1),
                        fontWeight: FontWeight.w400)),
                onChanged: (e) {
                  setState(() {});
                },
              ),),
          ),
          Container(
            child: Text('昵称不能超过20个字符，支持中英文、数字、符号', style: TextStyle(color: rgba(150, 148, 166, 1), fontWeight: FontWeight.w400, fontSize: 11),),
          ),
          Container(
            width: 290,
            height: 55,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 64),
            child: AButton.normal(
                width: 290,
                height: 55,
                plain: true,
                bgColor: rgba(209, 99, 242, 1),
                borderColor: rgba(209, 99, 242, 1),
                borderRadius: BorderRadius.circular(27.5),
                child: Text(
                  '立即提交',
                  style: TextStyle(
                      color: rgba(255, 255, 255, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                color: rgba(255, 255, 255, 1),
                onPressed: () {
                  // 立即提交
                  updateUserInfo(_contentEtController.text.toString());
                }),
          ),
        ],
      )
    );
  }

  /// 修改用户名
  updateUserInfo(String value) async {
    // if (null == value || value.isEmpty) {
    //   G.toast('用户名不能为空');
    //   return;
    // }
    try {
      var res = await G.req.shop.editBodylengReq(
        tk: this.widget.tk,
        bodylength: value,
      );

      var data = res.data;

      if (data == null) return null;
      // G.loading.hide(context);
      int code = data['code'];
      if (20000 == code) {
        // 修改
        modifyBodyBus.fire(new ModifyBodyEvent(value));
        // setState(() {});
        G.toast('修改成功');
        Navigator.pop(context);
      } else {
        G.toast('修改失败');
      }
    } catch (e) {
      G.toast('修改失败');
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    contentName = '';
    _contentEtController.text = '';
  }
}
