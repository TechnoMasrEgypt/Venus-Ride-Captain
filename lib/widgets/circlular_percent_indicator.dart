import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';

CircularPercentIndicator circlularPercentIndicator(
    {required String wallets, required double percent}) {
  return CircularPercentIndicator(
    radius: 75.0.r,
    lineWidth: 13.0,
    animation: true,
    percent: percent,
    center: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          wallets,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0.sp,
              color: BrandColors.deepBlue),
        ),
        Text(
          LocaleKeys.availableBalance.tr(),
          style:
              TextStyle(fontSize: 12.0.sp, color: BrandColors.colorTextLight),
        ),
      ],
    ),
    circularStrokeCap: CircularStrokeCap.round,
    progressColor: BrandColors.deepBlue,
  );
}
