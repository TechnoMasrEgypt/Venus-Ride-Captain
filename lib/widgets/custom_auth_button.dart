import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/utils/brand_colors.dart';

Widget customAuthButton(
    {required String text,
    required VoidCallback onTap,
    required double hight,
    required double width,
    Color color = BrandColors.colorPrimary}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: hight,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.r)), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
