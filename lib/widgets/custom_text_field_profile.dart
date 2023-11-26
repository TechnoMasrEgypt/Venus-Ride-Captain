import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/utils/brand_colors.dart';

Widget buildTextFieldOfEditProfile(
    {@required TextEditingController? controller,
    required String hint,
    required IconData icon,
    enabled = true}) {
  return TextField(
    controller: controller,
    cursorColor: BrandColors.colorPrimary,
    enabled: enabled,
    decoration: InputDecoration(
        icon: Container(
            width: 30.w,
            height: 30.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffD5DDE0),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            )),
        hintText: hint,
        // hintStyle: FontStyles.textStyle15,
        focusColor: Colors.white,
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: BrandColors.colorPrimary))),
  );
}
