import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

Widget customReviewCard(
    {required BuildContext context,
    required String photo,
    required String name,
    required dynamic rating,
    required String msg}) {
  return SizedBox(
    child: Column(
      children: [
        SizedBox(
          height: 60.h,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(photo),
                    ),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0.sp,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 125.w),
          child: RatingStars(
            editable: false,
            rating: rating.toDouble(),
            color: Colors.amber,
            iconSize: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(msg,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0.sp,
                  color: Colors.black)),
        )
      ],
    ),
  );
}
