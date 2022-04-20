import 'package:dio/dio.dart';
import 'package:tnsocialpro/utils/constants.dart';

/// 初始化dio
Dio initDio() {
  BaseOptions _baseOptions = BaseOptions(
    baseUrl: Constants.requestUrl,
  );

  Dio dio = Dio(_baseOptions);
  return dio;
}
