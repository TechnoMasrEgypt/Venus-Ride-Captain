import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:venus_driver/view/ride_history/presentation/cubit/ride_history_cubit.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_ride_history_card.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class RideHistoryBody extends StatelessWidget {
  const RideHistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideHistoryCubit, RideHistoryState>(
        builder: (context, state) {
      final cubit = RideHistoryCubit.of(context);
      return state is RideHistoryLoading
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
                                Navigator.maybePop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: cubit.listOfRideHistoryData.isEmpty
                              ? Lottie.asset('assets/json/manwaitingcar.json')
                              // Center(
                              //     child: Text(
                              //       'No Trips',
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 32.0.sp,
                              //           color: BrandColors.colorPrimary),
                              //     ),
                              //   )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: cubit.listOfRideHistoryData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return customRideHistoryCard(
                                        time: cubit
                                            .listOfRideHistoryData[index].time,
                                        context: context,
                                        cost: cubit.listOfRideHistoryData[index].costRide
                                            .toString(),
                                        date: cubit.listOfRideHistoryData[index].date
                                            .toString()
                                            .split(' ')[0],
                                        endRide: cubit.listOfRideHistoryData[index].endRide
                                            .toString(),
                                        endTime: cubit
                                            .listOfRideHistoryData[index]
                                            .endTime
                                            .toString()
                                            .substring(0, 5),
                                        startRide: cubit
                                            .listOfRideHistoryData[index]
                                            .startRide
                                            .toString(),
                                        startTime: cubit
                                            .listOfRideHistoryData[index]
                                            .startTime
                                            .toString()
                                            .substring(0, 5),
                                        status: cubit.listOfRideHistoryData[index].status == 'cancelled'
                                            ? cubit.listOfRideHistoryData[index].status
                                            : '');
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
