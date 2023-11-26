import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/contactUs/presentation/cubit/contact_us_cubit.dart';
import 'package:venus_driver/view/contactUs/presentation/widget/contact_us_body.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit()..getContactUs(),
      child: const Scaffold(body: ContactUSBody()),
    );
  }
}

class ContactUsSocialIcon extends StatelessWidget {
  const ContactUsSocialIcon({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      height: 35.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: .5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(image),
      ),
    );
  }
}

class CustomMessageTextField extends StatelessWidget {
  const CustomMessageTextField(
      {Key? key,
      required this.hint,
      this.maxLines = 1,
      this.onSave,
      this.onChanged})
      : super(key: key);

  final String hint;
  final int maxLines;
  final void Function(String?)? onSave;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSave,
      onChanged: onChanged,
      maxLines: maxLines,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return '$hint is required';
        } else {
          return null;
        }
      },
      cursorColor: BrandColors.colorPrimary,
      style: const TextStyle(color: BrandColors.colorPrimary),
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff5f5f5),
          hintText: hint,
          // hintStyle: ,
          border: buildOutlineBorder(),
          enabledBorder: buildOutlineBorder(),
          focusedBorder: buildOutlineBorder(Colors.grey.shade400)),
    );
  }

  OutlineInputBorder buildOutlineBorder([color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
