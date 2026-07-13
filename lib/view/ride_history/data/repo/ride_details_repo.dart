
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/ride_history/data/model/ride_details_model.dart';

class HistoryRideDetailsRepo {
  Future<Either<String, HistotyRideDetailsModel>> getHistoryRideDetails(
      int rideId) async {
    final response =
        await DioHelper.get(DioString.getHistoryRideDetails, headers: {
          'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideId,
    });
    try {
      if (response.statusCode == 200) {
        log("Success HistoryRideDetailsRepo");
        // log(AppStorage.getLang);
        print(response);
        return Right(
            HistotyRideDetailsModel.fromJson(jsonDecode(response.toString())));
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
