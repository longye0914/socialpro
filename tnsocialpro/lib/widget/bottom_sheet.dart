import 'dart:ui';

import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomActionSheet {
  static show(BuildContext context, List<String> data,
      {String title, Function callBack(int)}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              color: Color.fromRGBO(114, 114, 114, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //为了防止控件溢出
                  Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
//                                          height: 44.5,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: ListTile(
                                            onTap: () {
                                              //点击取消 弹层消失
                                              Navigator.pop(context);
                                              callBack(index);
                                            },
                                            title: new Text(
                                              data[index],
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                color: rgba(34, 34, 34, 1),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        index == data.length - 1
                                            ? Container()
                                            : Divider(
                                                height: 1,
                                                color: Color(0xFF3F3F3F),
                                              ),
                                      ],
                                );
                              },
                            )),
                          ],
                        ),
                  )),
                  SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: () {
                      //点击取消 弹层消失
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44.5,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text('取消',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: rgba(231, 120, 23, 1),
                            fontSize: 14,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
