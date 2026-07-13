import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/models/success_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/home/data/model/ride_request_details.dart';
import 'package:venus_driver/view/home/data/repo/check_ride.dart';

class HomeRepo {
  Future<Either<String, RideRequistDetails>> acceptDriverRide(
      String rideId, int driverId) async {
    final response = await DioHelper.get(DioString.acceptDriverRide, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'driver': driverId,
      'ride': int.parse(rideId),
      'startTime':
          DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5),
    });
    log(DateFormat.Hm().format(DateTime.now()).substring(0, 5));
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success acceptDriverRide");
        return Right(
            RideRequistDetails.fromJson(jsonDecode(response.toString())));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.toString()))
            .message
            .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SuccessModel>> updateLocation(lat, lng) async {
    log('userid ${CacheHelper.getData(key: 'id')}');
    log('token ${CacheHelper.getData(key: 'token')}');
    log('app  driver');
    final response = await DioHelper.post(DioString.updatelocation, headers: {
      'user': CacheHelper.getData(key: 'id'),
      'token': CacheHelper.getData(key: 'token'),
      'app': 'driver',
    }, body: {
      'lat': lat,
      'lng': lng,
    });
    try {
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['status'] == 'success') {
        // log("Success pickUPRide");
        return Right(SuccessModel.fromJson(response.data));
      } else {
        final message = response.data is Map
            ? ErrorModel.fromJson(response.data).message.toString()
            : response.data.toString();
        return Left(message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

// Add inside HomeRepo class
 Future<Either<String, OngoingRideModel>> checkOngoingRide() async {
  try {
    final response = await DioHelper.get(
      DioString.checkOngoingRide,
      headers: {
        'lang': CacheHelper.getData(key: 'lang'),
        'user_id': CacheHelper.getData(key: 'id'),
        'token': CacheHelper.getData(key: 'token'),
        'app': 'driver',
      },
    );

    log('🔥 [HomeRepo] statusCode = ${response.statusCode}');
    log('🔥 [HomeRepo] full response = ${response.data}');

    if (response.statusCode == 200 &&
        response.data is Map &&
        response.data['id'] != null){
      log("Success checkOngoingRide");
      return Right(OngoingRideModel.fromJson(response.data));
    } else {
      final message = response.data is Map
          ? (response.data['message']?.toString() ?? 'no_ride')
          : 'no_ride';
      return Left(message);
    }
  } catch (e) {
    log('🔥 [HomeRepo] checkOngoingRide exception: $e');
    return Left(e.toString()); // ← no crash, just returns Left
  }
}

  Future<Either<String, SuccessModel>> sendToken() async {
    final response = await DioHelper.get(DioString.sentToken, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'user_id': CacheHelper.getData(key: 'id'),
      'token': CacheHelper.getData(key: 'token'),
      'app': 'driver',
    });
    log('----------------------------');
    log(CacheHelper.getData(key: 'lang'));
    log(CacheHelper.getData(key: 'id').toString());
    log(CacheHelper.getData(key: 'token'));
    log('----------------------------');
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success SendToken");
        return Right(SuccessModel.fromJson(jsonDecode(response.toString())));
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
