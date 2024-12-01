import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/driver_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/auth/data/model/error_phone_auth_model.dart';

class PhoneAuthRepo {
  Future<Either<String, DriverModel>> phoneAuth(String phone) async {
    final response = await DioHelper.post(DioString.checkPhone, body: {
      'phone': '0$phone',
    }, headers: {
      'lang': 'en',
      'type': 'driver',
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success CheckPhoneRepo");
        return Right(DriverModel.fromJson(jsonDecode(response.toString())));
      } else {
        return Left(
            ErrorPhoneAuthModel.fromJson(jsonDecode(response.toString()))
                .errors
                .phone[0]
                .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
