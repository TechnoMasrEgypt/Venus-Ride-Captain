import 'package:flutter/material.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

void showUpdateProfileDialog(BuildContext context, var cubit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Profile'),
        content: Text('Do you want to update your image profile?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (cubit.photo != null) {
                await cubit.editImageProfile();
              } else {
                showSnackBar("you must choose photo first");
              }
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
