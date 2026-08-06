import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/FAQs/presentation/screen/faq_screen.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/contactUs/presentation/screen/contact_us_screen.dart';
import 'package:venus_driver/view/privacy/presentation/screen/privacy_screen.dart';
import 'package:venus_driver/view/profile/presentation/screen/profile_screen.dart';
import 'package:venus_driver/view/ride_history/presentation/screen/ride_history_screen.dart';
import 'package:venus_driver/view/wallet/presentation/screen/wallet_screen.dart';

import '../translations/locale_keys.g.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.changeLang});
  final Function(String) changeLang;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static const menuItems = <String>[
    '🇸🇦  عربي',
    '🇺🇸  English',
  ];
  static const menuItems2 = <String>[
    'عربي 🇸🇦',
    '🇺🇸  English',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 260.h,
              color: BrandColors.deepBlue,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      CacheHelper.getData(key: 'id') != null
                          ? Container(
                              width: 90.w,
                              height: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      CacheHelper.getData(key: 'photo')),
                                ),
                              ),
                            )
                          : Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child:
                                  Image.asset('assets/images/user_icon.png')),
                      Positioned(
                        top: -6.h,
                        right: -1.w,
                        child: InkWell(
                          onTap: () {
                            MagicRouter.navigateTo(const ProfileScreen());
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 25.w,
                                width: 25.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: BrandColors.deepBlue,
                                ),
                                // child: Icon(Icons.edit_outlined),
                              ),
                              Positioned(
                                  bottom: 5.h,
                                  left: 5.w,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 25.r,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    CacheHelper.getData(key: 'name').toString().toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Colors.white),
                  ),
                  Text(
                    CacheHelper.getData(key: 'email').toString().toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        listTileOfDrawer(
          title: LocaleKeys.wallet.tr(),
          onTap: () {
            MagicRouter.navigateTo(const WalletHistoryScreen());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        listTileOfDrawer(
          title: LocaleKeys.rideHistory.tr(),
          onTap: () {
            MagicRouter.navigateTo(const RideHistoryScreen());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ListTile(
          title: Text(LocaleKeys.changeLanguage.tr(),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
          trailing: PopupMenuButton<String>(
            onSelected: widget.changeLang,
            //  (String newValue) {
            //   if (newValue == '🇺🇸  English') {
            //     setState(() {
            //       context.setLocale(const Locale('en'));
            //     });
            //     CacheHelper.saveData(key: 'lang', value: 'en');
            //   } else {
            //     setState(() {
            //       context.setLocale(const Locale('ar'));
            //     });

            //     CacheHelper.saveData(key: 'lang', value: 'ar');
            //   }
            // },
            itemBuilder: (BuildContext context) {
              return Localizations.localeOf(context).languageCode == 'en'
                  ? menuItems
                      .map(
                        (String value) => PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList()
                  : menuItems2
                      .map(
                        (String value) => PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList();
            },
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        listTileOfDrawer(
          title: LocaleKeys.privacy.tr(),
          onTap: () {
            MagicRouter.navigateTo(const PrivacyScreen());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        listTileOfDrawer(
          title: LocaleKeys.contactUs.tr(),
          onTap: () {
            MagicRouter.navigateTo(const ContactUsScreen());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        listTileOfDrawer(
          title: LocaleKeys.faq.tr(),
          onTap: () {
            MagicRouter.navigateTo(const FAQscreen());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        listTileOfDrawer(
          // onTap: AppStorage.signOut,
          title: LocaleKeys.logOut.tr(),
          onTap: () async {
            MagicRouter.navigateAndPopAll(const LoginScreen());
            await CacheHelper.removeAllData();
            refDriversInfo.remove();
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    )));
  }
}

Widget listTileOfDrawer(
    {required VoidCallback onTap,
    IconData icon = Icons.arrow_forward_ios_outlined,
    required String title}) {
  return ListTile(
    onTap: onTap,
    trailing: Icon(
      icon,
      color: const Color(0xff97ADB6),
      size: 23.w,
    ),
    title: Text(
      title,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
    ),
    dense: true,
  );
}
