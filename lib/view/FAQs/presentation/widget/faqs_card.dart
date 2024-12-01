import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/helpers/hex_color.dart';

class FAQsItem extends StatelessWidget {
  final String title;
  final String desc;
  const FAQsItem({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp, color: HexColor('#4B545A')),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            desc,
            style: TextStyle(fontSize: 15.sp, color: HexColor('#4B545A')),
          ),
        )
      ],
    );
  }
}
