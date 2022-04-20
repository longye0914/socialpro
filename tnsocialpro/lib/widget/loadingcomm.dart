import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingComm {
  show(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container(
          child: Builder(builder: (BuildContext context) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: rgba(0, 0, 0, 0.8),
                ),
                width: 231,
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(),
                      height: 60,
                      width: 60,
                    ),
                    // CupertinoActivityIndicator(
                    //   radius: 14,
                    // ),
                    Container(
                      height: 25,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 15, left: 20),
                      alignment: Alignment.center,
                      child: Text(
                        '正在上传…',
                        style: TextStyle(
                            color: rgba(255, 255, 255, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
      // barrierDismissible: false,
      // barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor: rgba(255, 255, 255, 0),
      // transitionDuration: const Duration(milliseconds: 150),
      // transitionBuilder: (BuildContext context, Animation<double> animation,
      //     Animation<double> secondaryAnimation, Widget child) {
      //   return FadeTransition(
      //     opacity: CurvedAnimation(
      //       parent: animation,
      //       curve: Curves.easeOut,
      //     ),
      //     child: child,
      //   );
      // },
    );
  }

  hide(BuildContext context) {
    Navigator.pop(context);
//    G.pop();
  }
}
