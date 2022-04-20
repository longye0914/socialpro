import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/colors.dart';


class DetailImg extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  DetailImg(this.imgUrl, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: (null == imgUrl || '' == imgUrl) ? Image.asset(
          'assets/images/default_headpic.png',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: width,
          height: height,
      ) : Image(
        image: CachedNetworkImageProvider(imgUrl),
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
    );
  }
}
