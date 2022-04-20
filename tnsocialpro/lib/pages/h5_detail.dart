
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/common_util.dart';
import 'package:tnsocialpro/widget/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';


class H5Detail extends StatefulWidget {
  String d_catename, content;
  H5Detail({Key key, this.d_catename, this.content}) : super(key: key);
  _H5DetailState createState() => _H5DetailState();
}

class _H5DetailState extends State<H5Detail> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1),
        child: Scaffold(
            appBar: customAppbar(context: context, borderBottom: false, title: (null == this.widget.d_catename) ? '' : this.widget.d_catename),
            body: (null == this.widget.content) ? Container() : WebView(
              initialUrl: this.widget.content,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                } else if (request.url.startsWith('tel:')) {
                  CommonUtil.launchPhone(request.url);
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            )));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}