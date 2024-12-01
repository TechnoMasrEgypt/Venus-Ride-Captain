import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';

Widget walletCard({required String wallet, required String date}) {
  return Container(
      height: 58.h,
      width: 358.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(width: .5, color: HexColor('97ADB6'))),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.dinar.tr(),
                  style: TextStyle(
                      height: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0.sp,
                      color: HexColor('#3E4958')),
                ),
                Text(
                  wallet,
                  style: TextStyle(
                      // height: 1.3,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0.sp,
                      color: HexColor('#3E4958')),
                ),
              ],
            ),
            const Spacer(),
            Text(
              date,
              style: TextStyle(
                  // height: 1,
                  fontSize: 18.0.sp,
                  color: Colors.black),
            ),
          ],
        ),
      )));
}
