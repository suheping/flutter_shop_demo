// import 'dart:io';
import 'package:dio/dio.dart';
import '../config/service_url.dart';
import 'dart:async';

Future customRequest(pathName, {formData}) async {
  try {
    print('开始请求。。。。$pathName');
    Dio dio = new Dio();
    Response response;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    if (formData == null) {
      response = await dio.post(servicePath[pathName]);
    } else {
      response = await dio.post(
        servicePath[pathName],
        data: formData,
      );
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    return print(e);
  }
}
