import 'package:dio/dio.dart';
import 'package:venus_driver/utils/dio_string.dart';

class DioHelper {
  static Dio dioSingleton = Dio()..options.baseUrl = DioString.baseUrl;

  static Future<Response<dynamic>> post(
      String path, {
        FormData? formData,
        Map<String, dynamic>? body,
        Map<String, dynamic>? headers,
      }) {
    // إذا كان فيه body ننسخه، وإذا ما فيه نبدأ بواحد فاضي
    final Map<String, dynamic> mergedBody = Map.from(body ?? {});

    // نضيف البراميترات اللي في الهيدر إلى البودي
    if (headers != null) {
      mergedBody.addAll(headers);
    }

    dioSingleton.options.headers = headers;

    return dioSingleton.post(
      path,
      data: formData ?? FormData.fromMap(mergedBody),
      options: Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
  }

  static Future<Response<dynamic>> get(
      String path, {
        Map<String, dynamic>? headers,
        Map<String, String>? body,
      }) {
    // ندمج body مع الهيدر (إذا حبيت ترسل GET ومعه body)
    final Map<String, dynamic> mergedBody = Map.from(body ?? {});
    if (headers != null) {
      mergedBody.addAll(headers);
    }
    print("body :"+mergedBody.toString());

    dioSingleton.options.headers = headers;
    return dioSingleton.get(
      path,
      queryParameters: mergedBody, // عشان GET يستخدمهم كـ Query params
    );
  }
}
