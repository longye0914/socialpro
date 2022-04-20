import 'package:flutter/material.dart';

class NavigatePush {
    ///跳转到指定页面
    static push(BuildContext context, Widget page) {
         Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }
}