import 'package:dio/dio.dart';

class DioHelper {

  static Dio? dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://noteapi.popssolutions.net',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
  }) async
  {
    return await dio!.get(
      url,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async
  {
    return dio!.post(
      url,
      data: data,

    );
  }
}