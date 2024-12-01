import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/privacy/data/model/privacy_model.dart';

class PrivacyRepo {
  Future<Either<String, PrivacyModel>> getPrivacy() async {
    final response = await DioHelper.get(DioString.privacy, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'page': "2",
    });
    try {
      if (response.statusCode == 200) {
        log("Success PrivacyRepo");
        return Right(PrivacyModel.fromJson(jsonDecode(response.toString())));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.toString()))
            .message
            .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
