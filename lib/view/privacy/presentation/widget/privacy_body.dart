import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class PrivacyBody extends StatelessWidget {
  const PrivacyBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = PrivacyCubit.of(context);
    return BlocBuilder<PrivacyCubit, PrivacyState>(
      builder: (context, state) {
        return state is PrivacyLoading
            ? const LoadingIndicator()
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customIconBack(
                                  icon: Localizations.localeOf(context)
                                              .languageCode ==
                                          'en'
                                      ? Icons.keyboard_arrow_right
                                      : Icons.keyboard_arrow_left,
                                  onTap: () => Navigator.pop(context)),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            LocaleKeys.privacy.tr(),
                            style: TextStyle(
                                fontSize: 25.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          Text(
                            HelperMethods.parseHtmlString(
                                cubit.privacyData!.content),
                            style: TextStyle(fontSize: 15.sp),
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
