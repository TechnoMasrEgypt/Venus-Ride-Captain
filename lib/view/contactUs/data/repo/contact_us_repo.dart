// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/contactUs/data/model/contact_us_model.dart';
import 'package:venus_driver/view/contactUs/data/model/send_msg_model.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

class ContactUsRepo {
  Future<Either<String, ContactUsModel>> getContactUs() async {
    final response = await DioHelper.get(DioString.contactUS, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print("Success ContactUsRepo");
        print(response);
        return Right(ContactUsModel.fromJson(jsonDecode(response.toString())));
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

  Future<Either<String, SendMsgModel>> sentMsg(String msg) async {
    print(msg);
    final response = await DioHelper.post(DioString.sentMsg, body: {
      'content': msg,
    }, headers: {
      'Accept': 'application/json',
      'lang': CacheHelper.getData(key: 'lang'),
      'userId': CacheHelper.getData(key: 'user'),
      'userType': "driver",
      'subject': "contact",
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print("Success LoginRepo");
        print(response);
        showSnackBar('Message has been sent');
        return Right(SendMsgModel.fromJson(jsonDecode(response.toString())));
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
