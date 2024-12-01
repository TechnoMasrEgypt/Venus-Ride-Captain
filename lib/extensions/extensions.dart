import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:venus_driver/widgets/appalert.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return "";
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }
}

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get toPadding => MediaQuery.of(this).viewPadding.top;
  double get bottom => MediaQuery.of(this).viewInsets.bottom;
}

class PermissionHandlerPermissionService {
  @override
  static Future<PermissionStatus> requestPhotosPermission() async {
    return await Permission.photos.request();
  }

  @override
  static Future<bool> handlePhotosPermission(BuildContext context) async {
    PermissionStatus photosPermissionStatus = await requestPhotosPermission();

    if (photosPermissionStatus != PermissionStatus.granted) {
      print(
          '😰 😰 😰 😰 😰 😰 Permission to photos not granted! 😰 😰 😰 😰 😰 😰');
      await showDialog(
        context: context,
        builder: (_context) => AppAlertDialog(
          onConfirm: () => openAppSettings(),
          title: 'Photos Permission',
          subtitle:
              'Photos permission should Be granted to use this feature, would you like to go to app settings to give photos permission?',
        ),
      );
      return false;
    }
    return true;
  }
}
