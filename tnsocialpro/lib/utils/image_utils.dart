
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';

class ImageUtils {
  
  static ImageProvider getAssetImage(String name, {String format: 'png'}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static ImageProvider getImageProvider(String imageUrl, {String holderImg: 'none'}) {
    if (null == imageUrl || imageUrl.isEmpty) {
      return AssetImage(getImgPath(holderImg));
    }
    return CachedNetworkImageProvider(imageUrl, errorListener: () => Toast.LENGTH_LONG);
  }

  static getImagecamera() async{
    // return await ImagePicker.pickImage(source: ImageSource.camera);
    List<Media> _listImagePaths = await getLocalMediaPath('camara');
    return _listImagePaths[0].path;
  }

  static getImagegallery() async {
    // return await ImagePicker.pickImage(source: ImageSource.gallery);
    // bool isStore = await Permission.storage.request().isGranted;
    // if (isStore) {
    // } else {
    //   openAppSettings();
    //   return null;
    // }
    List<Media> _listImagePaths = await getLocalMediaPath('image');
    return _listImagePaths[0].path;
  }

  static Future<List<Media>> getLocalMediaPath(String type) async {
    List<Media> _listImagePaths;
    if (type == 'image') {
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: true,
        selectCount: 1,
        showCamera: false,
        compressSize: 500,
        ///超过500KB 将压缩图片
        uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
        cropConfig: CropConfig(enableCrop: false, width: 1, height: 1)
      );
    } else if (type == 'camara') {
      Media media = await ImagePickers.openCamera(compressSize: 500);
      _listImagePaths = [];
      _listImagePaths.add(media);
    }
    return _listImagePaths;
  }

  // static Future<File> imageCompressAndGetFile(File file) async {
  //   if (file.lengthSync() < 200 * 1024) {
  //     return file;
  //   }
  //   var quality = 100;
  //   if (file.lengthSync() > 4 * 1024 * 1024) {
  //     quality = 50;
  //   } else if (file.lengthSync() > 2 * 1024 * 1024) {
  //     quality = 60;
  //   } else if (file.lengthSync() > 1 * 1024 * 1024) {
  //     quality = 70;
  //   } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
  //     quality = 80;
  //   } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
  //     quality = 90;
  //   }
  //   var dir = await path_provider.getTemporaryDirectory();
  //   var targetPath = dir.absolute.path +"/"+DateTime.now().millisecondsSinceEpoch.toString()+ ".jpg";
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     minWidth: 600,
  //     quality: quality,
  //     rotate: 0,
  //   );
  //
  //   return result;
  // }
}

