
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';

class PolicyDetail extends StatefulWidget {
  String data, title;
  PolicyDetail({Key key, this.title, this.data}) : super(key: key);
  _PolicyDetailState createState() => _PolicyDetailState();
}

class _PolicyDetailState extends State<PolicyDetail> {

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppbar(context: context, borderBottom: false, title: this.widget.title),
          body: (null == this.widget.data || this.widget.data.isEmpty) ? new Container() : SingleChildScrollView(
            child: Html(
//              padding: EdgeInsets.all(10),
//              useRichText: true,
//              showImages: true,
//              renderNewlines: true,
//              shrinkToFit: true,
              data: this.widget.data,
            ),
          ),
        ));
  }
}