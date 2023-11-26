import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/helpers/hex_color.dart';

Widget customTextField(
    {@required Icon? endIcon,
    @required Widget? startIcon,
    @required String? hintText,
    required bool isPassword,
    required TextEditingController controller,
    required TextInputType type,
    VoidCallback? onPressed,
    Function(String)? onChanged}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    style: TextStyle(color: Colors.black.withOpacity(.8)),
    obscureText: isPassword,
    keyboardType: type,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(10.0.w),
      isDense: true,
      filled: true,
      prefixIconColor: BrandColors.deepBlue,
      fillColor: HexColor('#F7F8F8'),
      prefixIcon: startIcon,
      suffixIcon: endIcon != null
          ? IconButton(
              splashRadius: 5,
              color: HexColor("#97ADB6"),
              onPressed: onPressed,
              icon: endIcon,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      hintMaxLines: 1,
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: 14.sp, fontFamily: 'Poppins', color: HexColor('#B5B5B5')),
    ),
  );
}
