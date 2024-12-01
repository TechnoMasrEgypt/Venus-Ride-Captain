import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/helpers/hex_color.dart';

Widget customSocialButton({required IconData icon}) {
  return Container(
    height: 50.h,
    width: 50.w,
    decoration: BoxDecoration(
      border: Border.all(color: HexColor('#DDDADA')),
      borderRadius: BorderRadius.all(Radius.circular(14.r)),
    ),
    child: Center(
        child: Icon(
      icon,
    )),
  );
}
