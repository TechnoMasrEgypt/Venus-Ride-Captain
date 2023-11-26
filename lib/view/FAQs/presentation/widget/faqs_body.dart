import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/FAQs/presentation/cubit/faqs_cubit.dart';
import 'package:venus_driver/view/FAQs/presentation/widget/faqs_card.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

import '../../../../widgets/custom_icon_back.dart';

class FAQsBody extends StatelessWidget {
  const FAQsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqsCubit, FaqsState>(
      builder: (context, state) {
        final cubit = FaqsCubit.of(context);
        return state is FaqsLoading
            ? const LoadingIndicator()
            : SafeArea(
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                        Text(
                          LocaleKeys.faq.tr(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: cubit.listOfFAQsData.length,
                          itemBuilder: (context, index) {
                            return FAQsItem(
                              title: cubit.listOfFAQsData[index].question,
                              desc: HelperMethods.parseHtmlString(
                                  cubit.listOfFAQsData[index].answer),
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
