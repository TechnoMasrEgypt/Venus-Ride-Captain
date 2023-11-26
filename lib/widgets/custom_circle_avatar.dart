import 'package:flutter/material.dart';

Widget customCircleAvatar({required double radius}) {
  return CircleAvatar(
    radius: radius,
    child: Image.asset('assets/images/user_icon.png'),
  );
}
