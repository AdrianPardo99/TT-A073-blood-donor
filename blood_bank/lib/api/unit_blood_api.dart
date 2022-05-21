import 'package:dio/dio.dart';

import 'package:blood_bank/services/local_storage.dart';

class UnitBloodApi {
  static Dio _dio = new Dio();

  /* Configure dio HTTP client */
  static void configureDio() {
    /* Base url */
    _dio.options.baseUrl = "http://192.168.100.12:8085/api/v1";
    /* Configure headers */
    _dio.options.headers = {
      "Authorization": "Bearer ${LocalStorage.prefs.getString('token') ?? ''}"
    };
  }

  /* Configure get http client */
  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(path);
      return resp.data;
    } catch (e) {
      print(e);
      throw ("Error in get petition");
    }
  }

  /* Configure post http client */
  static Future httpPost(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    try {
      final resp = await _dio.post(path, data: formData);
      return resp.data;
    } catch (e) {
      print(e);
      throw ("Error in post petition");
    }
  }
}
