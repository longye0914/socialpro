// import 'package:color_dart/color_dart.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tnsocialpro/event/deletefeedback_event.dart';
// import 'package:tnsocialpro/event/modifyfeedback_event.dart';
// import 'package:tnsocialpro/utils/constants.dart';
//
// import 'package:tnsocialpro/widget/bottom_sheet.dart';
// import 'package:tnsocialpro/widget/loading_dialog.dart';
//
// enum PickImageType {
//   gallery,
//   camera,
// }
// var imageUrlV;
// int typeV;
//
// class UploadImageModel {
//   final File imageFile;
//   final int imageIndex;
//
//   UploadImageModel(this.imageFile, this.imageIndex);
// }
//
// class UploadImageItem extends StatelessWidget {
//   final GestureTapCallback onTap;
//   final Function callBack;
//   final UploadImageModel imageModel;
//   final Function deleteFun;
//   UploadImageItem({this.onTap, this.callBack, this.imageModel, this.deleteFun});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         // color: rgba(246, 246, 246, 1),
//         height: 122,
//         width: 92,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: rgba(245, 245, 245, 1)),
//         child: Stack(
//           // alignment: Alignment.topRight,
//           children: <Widget>[
//             Container(
//                 // height: 122,
//                 // width: 92,
//                 // margin: EdgeInsets.only(left: 16, right: 16),
//                 alignment: Alignment.center,
//                 child: imageModel == null
//                     ? InkWell(
//                         onTap: onTap ??
//                             () {
//                               BottomActionSheet.show(context, [
//                                 '拍照',
//                                 '选择图片',
//                               ], callBack: (i) {
//                                 callBack(i);
//                                 return;
//                               });
//                             },
//                         child: Container(
//                           height: 24,
//                           width: 24,
//                           alignment: Alignment.center,
//                           // decoration: BoxDecoration(
//                           //   borderRadius: BorderRadius.circular(6),
//                           //   color: rgba(255, 255, 255, 1),
//                           // ),
//                           // margin: EdgeInsets.all(29),
//                           child: Image.asset('assets/images/icon_addpic.png',
//                               height: 24, width: 24, fit: BoxFit.fill),
//                         ))
//                     : Image.file(imageModel.imageFile, height: 122,
//                     width: 92, fit: BoxFit.fill)),
//             Positioned(
//                 right: 20,
//                 top: 0,
//                 child: GestureDetector(
//                   onTap: () {
//                     if (imageModel != null) {
//                       deleteFun(this);
//                     }
//                   },
//                   child: (imageModel == null)
//                       ? Container()
//                       : ClipOval(
//                           //圆角删除按钮
//                           child: Container(
//                             padding: EdgeInsets.all(3),
//                             decoration: BoxDecoration(color: Colors.black54),
//                             child: Icon(
//                               Icons.close,
//                               size: 10,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                 )),
//           ],
//         ));
//   }
// }
//
// class UcarImagePicker extends StatefulWidget {
//   final String title;
//   final int maxCount;
//   final String tk;
//
//   UcarImagePicker({this.title, this.maxCount, this.tk});
//   @override
//   _UcarImagePickerState createState() => _UcarImagePickerState();
// }
//
// class _UcarImagePickerState extends State<UcarImagePicker> {
//   List _images = []; //保存添加的图片
//   int currentIndex = 0;
//   bool isDelete = false;
//   var _imgPath;
//   String filePath;
//   // List<String> picAppeng = [];
//   SharedPreferences _prefs;
//   List<UpdatePicData> updateDatas = [];
//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () async {
//       //版本名
//       _prefs = await SharedPreferences.getInstance();
//     });
//     _images.add(UploadImageItem(
//       callBack: (int i) async {
//         if (i == 0) {
//           print('拍照');
//           _getImage(0);
//         } else if (i == 1) {
//           print('选择照片');
//           _getImage(1);
//         }
//         /*else if (i == 2) {
//           _getImage(2);
//           print('拍视频');
//         } else {
//           _getImage(3);
//           print('选择视频');
//         }*/
// //        if (0 == typeV || 1 == typeV) {
// //          submitImg(_imgPath);
// //        } else {
// //          submitVideo(_imgPath);
// //        }
//       },
//     ));
//     super.initState();
//   }
//
//   @override
//   void deactivate() async {
//     super.deactivate();
//     // _prefs.setString('feedback',
//     //     picAppeng.toString().substring(1, picAppeng.toString().length - 1));
//   }
//
//   Future _getImage(int type) async {
//     var image;
//     if (0 == type) {
//       image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
//     } else if (1 == type) {
//       image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//     }
//     setState(() {
//       _imgPath = image;
//       _fileUplodImg(_imgPath);;
//     });
//     UploadImageItem();
//     setState(() {
//       if (null != _imgPath) {
//         _images.insert(
//             _images.length - 1,
//             UploadImageItem(
//               imageModel: UploadImageModel(_imgPath, currentIndex),
//               deleteFun: (UploadImageItem item) {
//                 // print('remove image at ${item.imageModel.imageIndex}');
//                 bool result = _images.remove(item);
//                 for (UpdatePicData updata in updateDatas) {
//                   if (item.imageModel.imageFile.toString() == updata.localPic) {
//                     updateDatas.remove(updata.remotePic);
//                     deleteFeedbackBus
//                         .fire(new DeleteFeedEvent(updata.remotePic));
//                   }
//                 }
//                 // if (null != picAppeng && picAppeng.isNotEmpty) {
//                 //   picAppeng.remove(0);
//                 // }
//                 // print('left is ${_images.length}');
//                 if (_images.length == widget.maxCount - 1 &&
//                     isDelete == false) {
//                   isDelete = true;
//                   _images.add(UploadImageItem(
//                     callBack: (int i) {
//                       if (i == 0) {
//                         _getImage(0);
//                       } else if (i == 1) {
//                         _getImage(1);
//                       }
//                       /*else if (i == 2){
//                         _getImage(2);
//                       } else {
//                         _getImage(3);
//                       }*/
//                     },
//                   ));
//                 }
//                 setState(() {});
//               },
//             ));
//       }
//       currentIndex++;
//       if (_images.length == widget.maxCount + 1) {
//         _images.removeLast();
//         isDelete = false;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
// //    _listen();
//     return Container(
//       // width: double.infinity,
//       // color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Wrap(
//             alignment: WrapAlignment.start,
//             // runSpacing: 5,
//             // spacing: 5,
//             children: List.generate(_images.length, (i) {
//               return _images[i];
//             }),
//           )
//         ],
//       ),
//     );
//   }
//
//   void _fileUplodImg(PickedFile filePath) async {
//     if (null == filePath) {
//       return;
//     }
//     showDialog(
//         context: context,
//         builder: (context) {
//           return new LoadingDialog();
//         });
//     String path = filePath.path;
//     var name = path.substring(path.lastIndexOf("/") + 1, path.length);
//
//     ///创建Dio
//     BaseOptions _baseOptions = BaseOptions(headers: {
//       'Authorization': this.widget.tk,
//     });
//     Dio _uoloadImgDio = Dio(_baseOptions);
//     FormData formdata = FormData.fromMap(
//         {"file": await MultipartFile.fromFile(path, filename: name)});
//
//     ///发送post
//     Response response = await _uoloadImgDio.post(
//       Constants.requestUrl + "qiniuphone/upLoadImage",
//       data: formdata,
//
//       ///这里是发送请求回调函数
//       ///[progress] 当前的进度
//       ///[total] 总进度
//       onSendProgress: (int progress, int total) {
//         print("当前进度是 $progress 总进度是 $total");
//       },
//     );
//
//     ///服务器响应结果
//     if (response.statusCode == 20000) {
//       Map map = response.data;
//       // 0 表示正常，1 表示该场景下违规，2 表示疑似违规
//       // int verify = map['data']['verify'];
//       // if (0 == verify || 2 == verify) {
//       String picUrl = map['data']['data'];
//       // picAppeng.add(picUrl);
//       updateDatas.add(new UpdatePicData(filePath.toString(), picUrl));
//       modifyFeedbackBus.fire(new ModifyFeedEvent(picUrl));
//       // setState(() {});
//       // // int id = map['data']['id'];
//       // // 修改
//       // modifyHeadBus.fire(new ModifyHeadEvent(avatar));
//       // // app 上传
//       // updateHeadimgInfo(avatar);
//       // } else {
//       //   G.toast('上传图片违规');
//       // }
//     }
//     Navigator.pop(context);
//   }
//
//   //监听Bus events
// //  void _listen(){
// //    photovedioBus.on<PhotovedioEvent>().listen((event){
// //      setState(() {
// //        imageUrlV = event.imageUrl;
// //        typeV = event.type;
// //        if (0 == typeV || 1 == typeV) {
// //          submitImg(_imgPath);
// //        } else {
// //          submitVideo(_imgPath);
// //        }
// //      });
// //    });
// //  }
// }
//
// class UpdatePicData {
//   UpdatePicData(this.localPic, this.remotePic);
//
//   final String localPic;
//   final String remotePic;
// }
