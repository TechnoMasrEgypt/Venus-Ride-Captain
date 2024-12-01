import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // const Center(
        //     child: SpinKitSquareCircle(
        //   color: BrandColors.colorPrimary,
        //   size: 50.0,
        // ));
        Center(
            child: SizedBox(
                height: 150.h,
                width: 150.w,
                child: Lottie.asset('assets/json/carloading.json')));
  }
}

class LoadingIndicatorStatus extends StatelessWidget {
  const LoadingIndicatorStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // const Center(
        //     child: SpinKitSquareCircle(
        //   color: BrandColors.colorPrimary,
        //   size: 50.0,
        // ));
        Center(
            child: SizedBox(
                height: 60.h,
                width: 80.w,
                child: Lottie.asset('assets/json/loadingx.json')));
  }
}
