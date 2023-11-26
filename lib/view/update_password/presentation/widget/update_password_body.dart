// ignore_for_file: missing_required_param

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/update_password/presentation/cubit/update_password_cubit.dart';
import 'package:venus_driver/widgets/ProgressDialog.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_text_field.dart';

class UpdatePasswordBody extends StatefulWidget {
  const UpdatePasswordBody({super.key});

  @override
  State<UpdatePasswordBody> createState() => _UpdatePasswordBodyState();
}

class _UpdatePasswordBodyState extends State<UpdatePasswordBody> {
  bool showPassword = true;
  bool showCoPassword = true;
  @override
  Widget build(BuildContext context) {
    final cubit = UpdatePasswordCubit.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
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
                      LocaleKeys.newPassword.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    customTextField(
                        isPassword: showPassword == true ? true : false,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      LocaleKeys.confirmPassword.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    customTextField(
                        isPassword: showCoPassword == true ? true : false,
                        type: TextInputType.visiblePassword,
                        onPressed: () {
                          setState(() {
                            showCoPassword = !showCoPassword;
                          });
                        },
                        endIcon: showCoPassword == true
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        controller: cubit.passwordCoController),
                    SizedBox(
                      height: 40.h,
                    ),
                    BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
                      builder: (context, state) {
                        return state is UpdatePasswordLoading
                            ? Center(
                                child: ProgressDialog(
                                    status: 'Update Password...'))
                            : Center(
                                child: customAuthButton(
                                    hight: 60.h,
                                    width: 300.w,
                                    text: LocaleKeys.confirm.tr(),
                                    onTap: cubit.updatePassword),
                              );
                      },
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
