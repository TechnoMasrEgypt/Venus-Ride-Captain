import 'package:dio/dio.dart';
import 'package:venus_driver/utils/dio_string.dart';

class DioHelper {
  static Dio dioSingleton = Dio()..options.baseUrl = DioString.baseUrl;

  static Future<Response<dynamic>> post(String path,
      {FormData? formData,
      Map<String, dynamic>? body,
      Map<String, dynamic>? headers}) {
    dioSingleton.options.headers = headers;
    return dioSingleton.post(path,
        data: formData ?? FormData.fromMap(body!),
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ));
  }

  static Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? headers, Map<String, String>? body}) {
    dioSingleton.options.headers = headers;
    return dioSingleton.get(path);
  }
}
