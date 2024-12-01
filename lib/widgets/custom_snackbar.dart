import 'dart:async';

import 'package:flutter/material.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/utils/brand_colors.dart';

// void showSnackBar(String title) {
//   final snackBar = SnackBar(
//     backgroundColor: BrandColors.colorPrimary,
//     content: Text(
//       title,
//       textAlign: TextAlign.center,
//       style: const TextStyle(fontSize: 15),
//     ),
//   );
//   globalScaffoldKey.currentState!.showSnackBar(snackBar);
// }

showSnackBar(String title,
    {bool popPage = false,
    duration = 2,
    Color color = BrandColors.colorPrimary}) {
  ScaffoldMessenger.of(MagicRouter.currentContext!).hideCurrentSnackBar();
  ScaffoldMessenger.of(MagicRouter.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
      duration: Duration(seconds: duration),
    ),
  );
  if (popPage) Timer(const Duration(seconds: 5), () => MagicRouter.pop());
}
