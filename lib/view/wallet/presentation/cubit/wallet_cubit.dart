import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/view/wallet/data/model/wallet_model.dart';
import 'package:venus_driver/view/wallet/data/repo/wallet_history_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());
  final walletRepo = WalletRepo();

  static WalletCubit of(context) => BlocProvider.of(context);

  List<WalletHistoryData> listOfWalletHistory = [];

  Future getWalletHistory() async {
    emit(WalletLoading());
    final res = await walletRepo.getWalletHistory();
    res.fold(
      (err) {
        showSnackBar(err);
        log("Error : $err");
        emit(WalletInitial());
      },
      (res) async {
        listOfWalletHistory = res.data;
        print ("Wallet History : ${listOfWalletHistory.length}");
        emit(WalletInitial());
      },
    );
  }
}
