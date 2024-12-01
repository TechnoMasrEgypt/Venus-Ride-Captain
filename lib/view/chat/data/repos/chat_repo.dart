import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/chat/data/models/send_message_model.dart';
import '../../../../models/error_model.dart';

class ChatRepo {
  Future<Either<String, SendMessageModel>> sendMessage(
      {required String msg, required int rideId}) async {
    final response = await DioHelper.post(DioString.sendMessage, body: {
      'message': msg,
    }, headers: {
      'userId': CacheHelper.getData(key: 'id'),
      'type': 'driver',
      'lang': CacheHelper.getData(key: 'lang'),
      'ride': rideId
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        print("Success LoginRepo");
        print(response);
        return Right(
            SendMessageModel.fromJson(jsonDecode(response.toString())));
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
