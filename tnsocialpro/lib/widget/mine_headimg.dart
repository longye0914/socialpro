import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tnsocialpro/utils/colors.dart';


class MineImg extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  MineImg(this.imgUrl, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: (null == imgUrl || '' == imgUrl) ? Image.asset(
          'assets/images/default_headpic.png',
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          width: width,
          height: height,
      ) : Image(
        image: CachedNetworkImageProvider(imgUrl),
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
      decoration: BoxDecoration(border: Border.all(color: Colours.orangebg)),
    );
  }
}
