import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';

Widget customRequestCard({
  required BuildContext context,
  required String name,
  required String image,
  required String startTrip,
  required String endTrip,
  required String startTime,
  required String endTime,
  required String cost,
  required VoidCallback onTap,
  required bool statusRide,
}) {
  return Padding(
    padding: EdgeInsets.all(8.0.w),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: Column(
          children: [
            SizedBox(
              height: 55.w,
              width: 292.w,
              child: Row(
                children: [
                  Container(
                      width: 75.w,
                      height: 75.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(image),
                        ),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0.sp,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      refRequset.remove();
                    },
                    child: Icon(
                      Icons.highlight_off,
                      color: Colors.red[400],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 10.w),
              child: Container(
                height: 135.w,
                width: 292.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(width: .5, color: HexColor('97ADB6'))),
                child: Padding(
                  padding: EdgeInsets.all(10.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      statusRide == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      startTime,
                                      style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Text(
                                      endTime,
                                      style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.w),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: BrandColors.colorPrimary,
                                        size: 12.w,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                        width: 1.2.w,
                                        height: 40.h,
                                        color: const Color(0xff3E4958),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xff4B545A),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 194.w,
                                  child: Column(
                                    children: [
                                      Text(
                                        maxLines: 2,
                                        startTrip,
                                        style: TextStyle(
                                            fontSize: 15.0.sp,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(
                                        maxLines: 2,
                                        endTrip,
                                        style: TextStyle(
                                            fontSize: 15.0.sp,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Text(
                                    CacheHelper.getData(key: 'lang') == 'en'
                                        ? "A trip without a known destination"
                                        : "رحلة بدون وجهة معروفة",
                                    style: TextStyle(
                                        fontSize: 18.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.location_off,
                                    color: BrandColors.colorPrimary,
                                    size: 60.w,
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 65.h,
                width: 292.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(width: .5, color: HexColor('97ADB6'))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: statusRide == false
                              ? Row(
                                  children: [
                                    Text(
                                      LocaleKeys.dinar.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0.sp,
                                          color: HexColor('#3E4958')),
                                    ),
                                    Text(
                                      cost,
                                      style: TextStyle(
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.0.sp,
                                          color: HexColor('#3E4958')),
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                        statusRide == false ? const Spacer() : Container(),
                        statusRide == false
                            ? customAuthButton(
                                text: LocaleKeys.accept.tr(),
                                onTap: onTap,
                                hight: 44.h,
                                width: 105.w,
                                color: BrandColors.deepBlue)
                            : customAuthButton(
                                text: LocaleKeys.accept.tr(),
                                onTap: onTap,
                                hight: 44.h,
                                width: 240.w,
                                color: BrandColors.deepBlue)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
