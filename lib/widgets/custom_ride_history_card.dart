import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/helpers/hex_color.dart';

Widget customRideHistoryCard({
  required BuildContext context,
  required String date,
  required String status,
  required String startTime,
  required String endTime,
  required String startRide,
  required String endRide,
  required String cost,
}) {
  return Container(
    height: 232.h,
    width: 293.w,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(width: .5, color: HexColor('97ADB6'))),
    child: Padding(
      padding: EdgeInsets.all(10.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                date,
                style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    startTime,
                    style: TextStyle(fontSize: 13.0.sp, color: Colors.black),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    endTime,
                    style: TextStyle(fontSize: 13.0.sp, color: Colors.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                      startRide,
                      style: TextStyle(
                          fontSize: 15.0.sp,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      maxLines: 2,
                      endRide,
                      style: TextStyle(
                          fontSize: 15.0.sp,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                LocaleKeys.subTotal.tr(),
                style:
                    TextStyle(fontSize: 18.0.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    ((double.parse(cost)) / 100).toString(),
                    style: TextStyle(
                        fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                  ),
                  const Text(" "),
                  Text(
                    LocaleKeys.dinar.tr(),
                    style: TextStyle(
                        fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
