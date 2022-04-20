/*
 * @Author: meetqy
 * @since: 2019-08-08 16:16:47
 * @lastTime: 2019-08-15 14:57:57
 * @LastEditors: meetqy
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tnsocialpro/data/bannerlist/data.dart';
import 'package:tnsocialpro/pages/h5_detail.dart';
import 'package:tnsocialpro/pages/policy_detail.dart';

class CustomSwiper extends StatelessWidget {
  final List<Bannerlist> images;
  final int index;
  final double height;

  /// 轮播图
  /// ```
  /// @param {List<String>} images - 轮播图地址
  /// @param {int} index - 初始下标位置
  /// @param {double} height - 容器高度
  /// ```
  CustomSwiper(this.images, {this.index, this.height = 84});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Swiper(
          index: index,
          onTap: (index) {
            String urlStr = images[index].url;
            if (null != urlStr && urlStr.isNotEmpty) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => H5Detail(
                        d_catename: '', content: (urlStr.contains('http:') || urlStr.contains('https:')) ? urlStr : 'https://' + urlStr)),
              );
              // Navigator.push(
              //   context,
              //   new MaterialPageRoute(
              //       builder: (context) => PolicyDetail(
              //           title: '', data: urlStr)),
              // );
            }
          },
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/icon_maintopbg.png',
                  image: images[index].src,
                  fit: BoxFit.cover,
                ));
          },
          itemCount: images.length,
          pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(size: 6, activeSize: 6)),
          autoplay: true,
          duration: 1000,
          autoplayDisableOnInteraction: true,
          autoplayDelay: 3000),
    );
  }
}
