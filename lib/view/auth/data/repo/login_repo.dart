// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/driver_model.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';

class LoginRepo {
  Future<Either<String, DriverModel>> login(
      String email, String password) async {
    final response = await DioHelper.post(DioString.login, body: {
      'email': email,
      'password': password,
      'device_token': CacheHelper.getData(key: 'token'),
    }, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
    });
    log(CacheHelper.getData(key: 'token'));
    log(CacheHelper.getData(key: 'lang'));
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print("Success LoginRepo");
        print(response);
        return Right(DriverModel.fromJson(jsonDecode(response.toString())));
      } else {
        print(response);
        return Left(ErrorModel.fromJson(jsonDecode(response.toString()))
            .message
            .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
