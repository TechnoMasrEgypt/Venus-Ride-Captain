import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/models/driver_model.dart';
import 'package:venus_driver/view/profile/data/model/edit_data_model.dart';

class ProfileRepo {
  Future<Either<String, DriverModel>> driverStatus(String status) async {
    final response =
        await DioHelper.post(DioString.updateDriverStatus, headers: {
      'Accept': 'application/json',
      'lang': CacheHelper.getData(key: 'lang'),
      'driver': CacheHelper.getData(key: 'id'),
    }, body: {
      'status': status,
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success HomeRepo");
        return Right(DriverModel.fromJson(jsonDecode(response.toString())));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.toString()))
            .message
            .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, DriverModel>> getProfileDetails() async {
    final response = await DioHelper.get(DioString.profile, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'driver': CacheHelper.getData(key: 'id'),
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success GetProfileDetailsRepo");
        return Right(DriverModel.fromJson(jsonDecode(response.toString())));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.toString()))
            .message
            .toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, EditDataModel>> editImageProfile(
    XFile photo,
  ) async {
    String fileName = photo.path.split('/').last;
    FormData body = FormData.fromMap({
      "photo": await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    final response = await DioHelper.post(DioString.updateProfile,
        headers: {
          'Accept': 'application/json',
          'lang': CacheHelper.getData(key: 'lang'),
          'user': CacheHelper.getData(key: 'user'),
        },
        formData: body);
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success EditImageProfileRepo");
        return Right(EditDataModel.fromJson(jsonDecode(response.toString())));
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
