import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/FAQs/data/model/faqs_model.dart';

class FaqsRepo {
  Future<Either<String, FaqsModel>> getFaqs() async {
    final response = await DioHelper.get(DioString.faqs, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
    });
    try {
      if (response.statusCode == 200) {
        log("Success LoginRepo");
        return Right(FaqsModel.fromJson(jsonDecode(response.toString())));
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
