import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.support.tr(),
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      customIconBack(
                          icon: Localizations.localeOf(context).languageCode ==
                                  'en'
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    LocaleKeys.sendaMessage.tr(),
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // CustomMessageTextField(
                  //   hint: LocaleKeys.yourMessageHere.tr(),
                  //   maxLines: 5,
                  // ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Center(
                    child: customAuthButton(
                        text: LocaleKeys.submit.tr(),
                        onTap: () {},
                        hight: 50.h,
                        width: 280.w),
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactUsSocialIcon extends StatelessWidget {
  const ContactUsSocialIcon({
    super.key,
    required this.image,
    required this.link,
  });
  final String image;
  final String? link;

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(link ?? ''))) {
      throw Exception('Could not launch $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchUrl();
      },
      child: Container(
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
      this.onChanged,
      required this.controller})
      : super(key: key);

  final String hint;
  final int maxLines;
  final void Function(String?)? onSave;
  final Function(String)? onChanged;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSave,
      controller: controller,
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
