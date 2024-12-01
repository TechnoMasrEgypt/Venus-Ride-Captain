import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/view/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:venus_driver/widgets/circlular_percent_indicator.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_drawer.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReceiptCubit()..getReceiptRide(),
          ),
          BlocProvider(
            create: (context) => ProfileCubit()..getProfileDetails(),
          ),
        ],
        child: Scaffold(drawer: CustomDrawer(
          changeLang: (newValue) {
            if (newValue == '🇺🇸  English') {
              setState(() {
                context.setLocale(const Locale('en'));
              });
              CacheHelper.saveData(key: 'lang', value: 'en');
            } else {
              setState(() {
                context.setLocale(const Locale('ar'));
              });

              CacheHelper.saveData(key: 'lang', value: 'ar');
            }
          },
        ), body:
            BlocBuilder<ReceiptCubit, ReceiptState>(builder: (context, state) {
          final cubit = ReceiptCubit.of(context);
          final cubitDetails = ProfileCubit.of(context);
          return state is GetReceiptLoading
              ? const LoadingIndicator()
              : WillPopScope(
                  onWillPop: () async => false,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Builder(builder: (context) {
                                      return customIconBack(
                                        icon: Icons.menu,
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  return state is GetProfileDetailsLoading
                                      ? const LoadingIndicator()
                                      : circlularPercentIndicator(
                                          percent: .6,
                                          wallets: (cubitDetails
                                                      .driverData!.wallets /
                                                  100)
                                              .toStringAsFixed(2)
                                              .toString());
                                },
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              SizedBox(
                                width: 333.w,
                                child: Card(
                                  elevation: 8,
                                  shadowColor: Colors.blueGrey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80.w,
                                          width: 80.w,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffF7F8F9),
                                              shape: BoxShape.circle),
                                          child: const Center(
                                              child: Icon(
                                            Icons.check,
                                            color: Color(0xff2C3C93),
                                            size: 30,
                                          )),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Text(
                                          LocaleKeys.yourTripHasEnded.tr(),
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#3E4958')),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Container(
                                          height: 135.h,
                                          width: 293.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              border: Border.all(
                                                  width: .5,
                                                  color: HexColor('97ADB6'))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          cubit.receiptDetails!
                                                              .startTime
                                                              .substring(0, 5),
                                                          style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 30.h,
                                                        ),
                                                        Text(
                                                          cubit.receiptDetails!
                                                              .endTime,
                                                          style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            color: BrandColors
                                                                .colorPrimary,
                                                            size: 12.w,
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Container(
                                                            width: 1.2.w,
                                                            height: 40.h,
                                                            color: const Color(
                                                                0xff3E4958),
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Color(
                                                                0xff4B545A),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 194.w,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            maxLines: 2,
                                                            cubit
                                                                .receiptDetails!
                                                                .startRide,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    15.0.sp,
                                                                color: Colors
                                                                    .black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                          Text(
                                                            maxLines: 2,
                                                            cubit
                                                                .receiptDetails!
                                                                .endRide,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    15.0.sp,
                                                                color: Colors
                                                                    .black,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Column(
                                          children: [
                                            const Divider(
                                              thickness: 1.5,
                                              color: Color(0xffD5DDE0),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      LocaleKeys.youTravelled
                                                          .tr(),
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    ),
                                                    const Text(' '),
                                                    Text(
                                                      cubit.receiptDetails!
                                                          .distance,
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    ),
                                                    const Text(' '),
                                                    Text(
                                                      LocaleKeys.km.tr(),
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    ),
                                                    const Text(' '),
                                                    Text(
                                                      LocaleKeys.inx.tr(),
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    ),
                                                    const Text(' '),
                                                    Text(
                                                      cubit
                                                          .receiptDetails!.time,
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    ),
                                                    const Text(' '),
                                                    Text(
                                                      LocaleKeys.mins.tr(),
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  LocaleKeys.tripFare.tr(),
                                                  style: TextStyle(
                                                    fontSize: 16.0.sp,
                                                  ),
                                                ),
                                                const Text(" "),
                                                Row(
                                                  children: [
                                                    Text((double.parse(cubit
                                                                .receiptDetails!
                                                                .cost) /
                                                            100)
                                                        .toStringAsFixed(2)
                                                        .toString()),
                                                    Text(LocaleKeys.dinar.tr()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  LocaleKeys.previousCancelFees
                                                      .tr(),
                                                  style: TextStyle(
                                                    fontSize: 16.0.sp,
                                                  ),
                                                ),
                                                const Text(" "),
                                                Row(
                                                  children: [
                                                    Text(
                                                      (int.parse(cubit
                                                                  .receiptDetails!
                                                                  .fee) /
                                                              100)
                                                          .toString(),
                                                    ),
                                                    Text(
                                                      LocaleKeys.dinar.tr(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Late',
                                                  style: TextStyle(
                                                    fontSize: 16.0.sp,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      (int.parse(cubit
                                                                  .receiptDetails!
                                                                  .late) /
                                                              100)
                                                          .toString(),
                                                    ),
                                                    const Text(" "),
                                                    Text(
                                                      LocaleKeys.dinar.tr(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Discount',
                                                  style: TextStyle(
                                                    fontSize: 16.0.sp,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text((double.parse(cubit
                                                                .receiptDetails!
                                                                .discount) /
                                                            100)
                                                        .toStringAsFixed(2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.5,
                                              color: Color(0xffD5DDE0),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  LocaleKeys.subTotal.tr(),
                                                  style: TextStyle(
                                                      fontSize: 18.0.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      (double.parse(cubit
                                                                  .receiptDetails!
                                                                  .total) /
                                                              100)
                                                          .toStringAsFixed(2)
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18.0.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Text(" "),
                                                    Text(
                                                      LocaleKeys.dinar.tr(),
                                                      style: TextStyle(
                                                          fontSize: 18.0.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              customAuthButton(
                                  text: 'New Trip',
                                  onTap: () {
                                    MagicRouter.navigateAndPopAll(
                                        const HomeScreen());
                                    refReceiptRide.remove();
                                  },
                                  hight: 50.h,
                                  width: 200.w)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        })));
  }
}
