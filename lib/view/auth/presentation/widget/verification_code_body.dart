import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/auth/presentation/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';

class VerificationCodeBody extends StatefulWidget {
  const VerificationCodeBody({
    super.key,
  });

  @override
  State<VerificationCodeBody> createState() => _VerificationCodeBodyState();
}

class _VerificationCodeBodyState extends State<VerificationCodeBody> {
  int timeLeft = 0;

  void _startCountDown() {
    timeLeft = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PhoneAuthCubit.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: customIconBack(
                      icon: Localizations.localeOf(context).languageCode == 'en'
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_left,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                alignment: Alignment.center,
                height: 105.h,
                width: 267.w,
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.codeSend.tr(),
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: BrandColors.colorTextSemiLight),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CacheHelper.getData(key: 'pho'),
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: BrandColors.colorTextSemiLight),
                        ),
                        Text(
                          LocaleKeys.sms.tr(),
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: BrandColors.colorTextSemiLight),
                        ),
                      ],
                    ),
                    OtpTextField(
                      numberOfFields: 6,
                      enabledBorderColor: BrandColors.colorPrimary,
                      cursorColor: BrandColors.colorPrimary,
                      focusedBorderColor: Colors.amber,
                      showFieldAsBox: false,
                      textStyle: TextStyle(
                          fontSize: 25.sp, color: BrandColors.colorPrimary),
                      borderWidth: 2.0,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        // if (verificationCode != "111111") {
                        //   showSnackBar(
                        //     LocaleKeys.verificationCode.tr(),
                        //   );
                        //   return;
                        // }
                        // MagicRouter.navigateTo(const UpdatePasswordScreen());
                        cubit.verifyOTPCode(verificationCode);
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    timeLeft == 0
                        ? InkWell(
                            onTap: _startCountDown,
                            child: Text(
                              LocaleKeys.resendCode.tr(),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15.sp,
                                  color: BrandColors.colorTextSemiLight),
                            ))
                        : Text(
                            "Resend code ( 0:${timeLeft.toString()} )",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15.sp,
                                color: BrandColors.colorTextResendCode),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
