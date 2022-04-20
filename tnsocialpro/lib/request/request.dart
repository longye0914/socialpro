import 'package:dio/dio.dart';
import 'package:tnsocialpro/request/init_dio.dart';
import 'package:tnsocialpro/request/req_business.dart';
import 'package:tnsocialpro/request/req_user.dart';

class Request {
  Dio _dio;

  Request() {
    _dio = initDio();
  }

  ReqUser get user => ReqUser(_dio);

  ReqBusiness get shop => ReqBusiness(_dio);
}