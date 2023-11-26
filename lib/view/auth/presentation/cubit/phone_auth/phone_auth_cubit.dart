import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/auth/data/repo/phone_auth_repo.dart';
import 'package:venus_driver/view/auth/presentation/screens/verification_code_screen.dart';
import 'package:venus_driver/view/update_password/presentation/screen/update_password_screen.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());
  static PhoneAuthCubit of(context) => BlocProvider.of(context);
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  late String verificationId;
  var receivedID = '';
  late String phoneNumber;
  final phoneAuthRepo = PhoneAuthRepo();

  void verifyUserPhoneNumber() {
    emit(Loading());
    auth.verifyPhoneNumber(
      phoneNumber: '+${selectedCountry.phoneCode}${phoneNumberController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then(
              (value) => log('Logged In Successfully'),
            );
        CacheHelper.saveData(
            key: 'pho',
            value:
                '+${selectedCountry.phoneCode}${phoneNumberController.text}');

        emit(SetPhone());
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        await CacheHelper.saveData(
            key: 'verificationId', value: verificationId);
        emit(CodeSend());
        showSnackBar('Code Send');
        MagicRouter.navigateTo(const VerificationCodeScreen());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTPCode(otpCode) async {
    emit(PhoneNumberSubmited());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: CacheHelper.getData(key: 'verificationId'),
      smsCode: otpCode,
    );
    try {
      await auth.signInWithCredential(credential).then((value) {
        log('User Login In Successful');
        MagicRouter.navigateTo(const UpdatePasswordScreen());
        emit(PhoneOTPVerified());
      });
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  Future phoneAuth() async {
    emit(Loading());
    final res = await phoneAuthRepo.phoneAuth(phoneNumberController.text);
    res.fold(
      (err) async {
        showSnackBar(err);
        emit(PhoneAuthInitial());
      },
      (res) async {
        emit(PhoneAuthInitial());
        await CacheHelper.saveData(key: 'id', value: res.data.id);
        await CacheHelper.saveData(key: 'user', value: res.data.user);
        await CacheHelper.saveData(key: 'name', value: res.data.name);
        await CacheHelper.saveData(key: 'photo', value: res.data.photo);
        await CacheHelper.saveData(key: 'email', value: res.data.email);
        await CacheHelper.saveData(key: 'lang', value: res.data.language);

        CacheHelper.saveData(key: 'lang', value: 'en');
        verifyUserPhoneNumber();
      },
    );
  }
}
