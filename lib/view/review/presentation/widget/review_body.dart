import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/review/presentation/cubit/reviews_cubit.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_review_card.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class ReviewBody extends StatelessWidget {
  const ReviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(builder: (context, state) {
      final cubit = ReviewsCubit.of(context);
      return state is ReviewsLoading
          ? const LoadingIndicator()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            customIconBack(
                              icon: Localizations.localeOf(context)
                                          .languageCode ==
                                      'en'
                                  ? Icons.keyboard_arrow_right
                                  : Icons.keyboard_arrow_left,
                              onTap: () {
                                MagicRouter.pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: cubit.listOfReviews.isEmpty
                              ? Lottie.asset('assets/json/rating.json')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: cubit.listOfReviews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return customReviewCard(
                                        context: context,
                                        msg: cubit
                                                .listOfReviews[index].message ??
                                            '',
                                        name: cubit
                                            .listOfReviews[index].client.name,
                                        photo: cubit
                                            .listOfReviews[index].client.photo,
                                        rating:
                                            cubit.listOfReviews[index].rating);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(
                                    thickness: 1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
