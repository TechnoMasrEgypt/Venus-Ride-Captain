import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';

Future<dynamic> showBackAlertDialog({
  required BuildContext context,
  required String content,
  required String action,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(LocaleKeys.areYouSure.tr()),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(LocaleKeys.no.tr())),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            onPressed: onPressed,
            child: Text(action)),
      ],
    ),
  );
}
