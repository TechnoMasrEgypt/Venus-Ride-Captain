import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/models/success_model.dart';
import 'package:venus_driver/utils/dio_string.dart';

class MapRepo {
  Future<Either<String, SuccessModel>> pickUPRide(rideID) async {
    final response = await DioHelper.get(DioString.pickUPRide, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideID,
      'startTime':
          DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5),
    });
    log(DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5));
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success pickUPRide");
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

  Future<Either<String, SuccessModel>> rideWay(rideID) async {
    final response = await DioHelper.get(DioString.rideBeign, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideID,
      'startTime':
          DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5),
    });
    log(DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5));
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success rideWay");
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

  Future<Either<String, SuccessModel>> rideDone(
      {required rideID,
      required startAddress,
      required endAddress,
      required km}) async {
    final response = await DioHelper.post(DioString.rideDone, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideID,
    }, body: {
      'endTime': DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5),
      'destinationLocation': endAddress,
      'startLocation': startAddress,
      'km': km,
    });
    log(rideID);
    log(km.toString());
    log(DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5));
    try {
      if (response.statusCode == 200) {
        log("Success rideDone");
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

  Future<Either<String, SuccessModel>> cancelledRide(rideID) async {
    final response = await DioHelper.post(DioString.cancelledRide, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideID,
      'type': 'driver',
      'cancel_time':
          DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5),
    }, body: {
      'reasonCancelled': 'driver'
    });
    log(DateFormat.Hm('en_US').format(DateTime.now()).substring(0, 5));
    try {
      if (response.statusCode == 200) {
        log("Success cancelledRide");
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
