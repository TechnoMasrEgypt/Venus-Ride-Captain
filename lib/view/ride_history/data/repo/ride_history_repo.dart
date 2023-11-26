import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/ride_history/data/model/ride_history_model.dart';

class RideHistoryRepo {
  Future<Either<String, RideHistoryModel>> getRideHistory() async {
    final response = await DioHelper.get(DioString.historyRides, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'typeId': CacheHelper.getData(key: 'id'),
      'type': 'driver'
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success getRideHistory");
        return Right(
            RideHistoryModel.fromJson(jsonDecode(response.toString())));
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
