import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/view/contactUs/presentation/cubit/contact_us_cubit.dart';
import 'package:venus_driver/view/support/support_screen.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class ContactUSBody extends StatelessWidget {
  const ContactUSBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
      builder: (context, state) {
        final cubit = ContactUsCubit.of(context);
        return state is ContactUsLoading
            ? const LoadingIndicator()
            : SafeArea(
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
                                LocaleKeys.contactUs.tr(),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              customIconBack(
                                  icon: Localizations.localeOf(context)
                                              .languageCode ==
                                          'en'
                                      ? Icons.keyboard_arrow_right
                                      : Icons.keyboard_arrow_left,
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Card(
                            elevation: 4,
                            shadowColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mark_email_read_outlined,
                                        color: Colors.blue.shade100,
                                        size: 20.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        cubit.contactUsData?.email ?? "",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: HexColor('#7B6F72')),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Text(
                                    LocaleKeys.followOnSocialMedia.tr(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1D1617)),
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ContactUsSocialIcon(
                                        image: 'assets/images/face.png',
                                        link:
                                            cubit.contactUsData?.facebook ?? "",
                                      ),
                                      ContactUsSocialIcon(
                                        image: 'assets/images/insta.png',
                                        link:
                                            cubit.contactUsData?.instgram ?? "",
                                      ),
                                      ContactUsSocialIcon(
                                        image: 'assets/images/twiter.png',
                                        link:
                                            cubit.contactUsData?.twitter ?? "",
                                      ),
                                      ContactUsSocialIcon(
                                        image: 'assets/images/tiktoc.png',
                                        link: cubit.contactUsData?.tiktok ?? "",
                                      ),
                                      ContactUsSocialIcon(
                                        image: 'assets/images/snap.png',
                                        link:
                                            cubit.contactUsData?.snapchat ?? "",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 58.h,
                          ),
                          Text(
                            LocaleKeys.sendaMessage.tr(),
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomMessageTextField(
                            hint: LocaleKeys.yourMessageHere.tr(),
                            maxLines: 5,
                            controller: cubit.msgController,
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          BlocBuilder<ContactUsCubit, ContactUsState>(
                            builder: (context, state) {
                              return state is SendMsgLoading
                                  ? const Center(child: LoadingIndicator())
                                  : Center(
                                      child: customAuthButton(
                                          text: LocaleKeys.submit.tr(),
                                          onTap: cubit.sendMsg,
                                          hight: 50.h,
                                          width: 280.w),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
