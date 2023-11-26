// ignore_for_file: missing_required_param

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/auth/presentation/cubit/login/login_cubit.dart';
import 'package:venus_driver/view/auth/presentation/screens/enter_phone.dart';
import 'package:venus_driver/widgets/ProgressDialog.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_text_field.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  bool localeIsEn = true;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customIconBack(
                      icon: Icons.language,
                      onTap: () {
                        if (localeIsEn == true) {
                          context.setLocale(const Locale('en'));
                          CacheHelper.saveData(key: 'lang', value: 'en');
                        } else {
                          context.setLocale(const Locale('ar'));
                          CacheHelper.saveData(key: 'lang', value: 'ar');
                        }
                        localeIsEn = !localeIsEn;
                        // // AppStorage.cacheLang(
                        // //     Localizations.localeOf(context).languageCode);
                      },
                    ),
                  ],
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.emailOrPhoneNumber.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    customTextField(
                        startIcon: const Icon(Icons.mail),
                        isPassword: false,
                        type: TextInputType.emailAddress,
                        controller: cubit.emailController),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      LocaleKeys.password.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    customTextField(
                        startIcon: const Icon(Icons.lock),
                        isPassword: showPassword == false ? false : true,
                        type: TextInputType.visiblePassword,
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        endIcon: showPassword == true
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        controller: cubit.passwordController),
                    SizedBox(
                      height: 40.h,
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return state is LoginLoading
                            ? Center(
                                child:
                                    ProgressDialog(status: 'Logging you in...'))
                            : Center(
                                child: customAuthButton(
                                    text: LocaleKeys.signIn.tr(),
                                    onTap: cubit.login,
                                    hight: 60.h,
                                    width: 300.w),
                              );
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    InkWell(
                      onTap: () {
                        MagicRouter.navigateTo(const EnterPhoneScreen());
                      },
                      child: Text(
                        LocaleKeys.forgetPassword.tr(),
                        style: TextStyle(
                            color: BrandColors.colorTextLight, fontSize: 15.sp),
                      ),
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
