// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/update_password/data/model/update_password_model.dart';

class UpdatePasswordRepo {
  Future<Either<String, UpdatePasswordModel>> updatePassword(
      String password, String coPassword) async {
    final response = await DioHelper.post(DioString.updatePassword, body: {
      'password': password,
      'password_confirmation': coPassword,
    }, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'user': CacheHelper.getData(key: 'user'),
    });
    print(password);
    print('--------------');
    print(
      CacheHelper.getData(key: 'user'),
    );
    print('--------------');
    print(password);
    print(coPassword);

    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print("Success LoginRepo");
        print(response);
        return Right(
            UpdatePasswordModel.fromJson(jsonDecode(response.toString())));
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
