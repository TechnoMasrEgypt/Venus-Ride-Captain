import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';

Future<dynamic> showCancleAlertDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onTap,
}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: SizedBox(
            height: 205.h,
            child: Column(
              children: [
                Image.asset('assets/images/standard.png'),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0.sp,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8.h,
                ),
                customAuthButton(
                    text: LocaleKeys.back.tr(),
                    onTap: onTap,
                    hight: 35.h,
                    width: 100.w)
              ],
            ),
          )));
}
