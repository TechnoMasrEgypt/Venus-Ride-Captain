import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/auth/presentation/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:venus_driver/widgets/ProgressDialog.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_text_field.dart';

class EnterPhoneBody extends StatefulWidget {
  const EnterPhoneBody({super.key});

  @override
  State<EnterPhoneBody> createState() => _EnterPhoneBodyState();
}

class _EnterPhoneBodyState extends State<EnterPhoneBody> {
  @override
  Widget build(BuildContext context) {
    final cubit = PhoneAuthCubit.of(context);
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
                          LocaleKeys.phoneNumber.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                        customTextField(
                            onChanged: (p0) {},
                            type: TextInputType.phone,
                            onPressed: () {},
                            endIcon: const Icon(Icons.phone),
                            controller: cubit.phoneNumberController,
                            isPassword: false,
                            startIcon: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    countryListTheme: CountryListThemeData(
                                        bottomSheetHeight: 500.h),
                                    context: context,
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: Text(
                                  '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            hintText: ''),
                        SizedBox(
                          height: 40.h,
                        ),
                        BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
                          builder: (context, state) {
                            return state is Loading
                                ? Center(
                                    child: ProgressDialog(
                                        status: 'Logging you in...'))
                                : Center(
                                    child: customAuthButton(
                                        text: LocaleKeys.confirm.tr(),
                                        onTap: cubit.phoneAuth,
                                        hight: 60.h,
                                        width: 300.w),
                                  );
                          },
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
