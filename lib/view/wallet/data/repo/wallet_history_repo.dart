import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dioHelper/dio_helper.dart';
import 'package:venus_driver/models/error_model.dart';
import 'package:venus_driver/utils/dio_string.dart';
import 'package:venus_driver/view/wallet/data/model/wallet_model.dart';

class WalletRepo {
  Future<Either<String, WalletHistoryModel>> getWalletHistory() async {
    final response = await DioHelper.get(DioString.walletReviews, headers: {
      'lang': CacheHelper.getData(key: 'lang'),
      'driver': CacheHelper.getData(key: 'id'),
    });
    try {
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        log("Success getWalletHistory");
        return Right(
            WalletHistoryModel.fromJson(jsonDecode(response.toString())));
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
