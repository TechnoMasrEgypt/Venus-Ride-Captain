import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';

Widget customCancelButton({required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 50.h,
      width: 144.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 25,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: Center(
        child: Text(
          LocaleKeys.cancel.tr(),
          style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
