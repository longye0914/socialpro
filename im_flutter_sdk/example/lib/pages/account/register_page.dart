import 'package:easeim_flutter_demo/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController;
  TextEditingController _pwdController;
  TextEditingController _confPwdController;
  bool _agreeProtocal = false;

  @override
  void initState() {
    super.initState();
    updateTextFieldController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: GestureDetector(
          onTap: () => hiddenKeyboard(),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.3),
                  BlendMode.srcOver,
                ),
                alignment: Alignment.bottomCenter,
                image: AssetImage('images/login_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    left: 24,
                    top: 10,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Image.asset(
                          'images/register_back.png',
                          fit: BoxFit.fill,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 88,
                        ),
                        Text(
                          '????????????',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        // ?????????
                        Container(
                          padding: EdgeInsets.fromLTRB(33, 38, 33, 0),
                          child: loginRegistTextField(
                            hintText: '?????????',
                            controller: _usernameController,
                            rightIcon: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                'images/login_usename_clear.png',
                              ),
                              onPressed: () {
                                _usernameController.text = '';
                              },
                            ),
                          ),
                        ),
                        // ??????
                        Container(
                          padding: EdgeInsets.fromLTRB(33, 20, 33, 0),
                          child: loginRegistTextField(
                            hintText: '??????',
                            isPwd: true,
                            controller: _pwdController,
                          ),
                        ),
                        // ????????????
                        Container(
                          padding: EdgeInsets.fromLTRB(33, 20, 33, 0),
                          child: loginRegistTextField(
                            hintText: '????????????',
                            isPwd: true,
                            controller: _confPwdController,
                          ),
                        ),
                        Container(
                          height: 70,
                          margin: EdgeInsets.only(
                              top: 5, left: 48, right: 48, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      _agreeProtocal = !_agreeProtocal;
                                    });
                                  },
                                  icon: Image.asset(
                                    _agreeProtocal
                                        ? 'images/login_protocal_selected.png'
                                        : 'images/login_protocal_unselected.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FlatButton(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '?????? ???????????? ??? ????????????',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                        loginRegisterButton(
                          enable: _agreeProtocal,
                          margin: EdgeInsets.only(left: 33, right: 33),
                          onPressed: _doRegisterAction,
                          title: '??????',
                          beginColor: Colors.blue[400],
                          endColor: Colors.blue[800],
                          disabelColor: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          behavior: HitTestBehavior.translucent,
        ),
      ),
    );
  }

  void updateTextFieldController() {
    _usernameController = TextEditingController();
    _usernameController.addListener(() {});
    _pwdController = TextEditingController();
    _pwdController.addListener(() {});
    _confPwdController = TextEditingController();
    _confPwdController.addListener(() {});
  }

  hiddenKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _doRegisterAction() async {
    try {
      SmartDialog.showLoading(msg: '?????????...');
      await EMClient.getInstance
          .createAccount(_usernameController.text, _confPwdController.text);

      SmartDialog.showToast('????????????');
      Navigator.of(context).pushReplacementNamed('/login');
    } on EMError catch (e) {
      SmartDialog.showToast('???????????? $e');
    } finally {
      SmartDialog.dismiss();
    }
  }
}
