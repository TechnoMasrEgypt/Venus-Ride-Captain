import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/home/presentation/cubit/home_cubit.dart';
import 'package:venus_driver/view/map/presentation/screen/map_screen.dart';
import 'package:venus_driver/view/map/presentation/screen/trip_screen.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/view/review/presentation/screen/review_Screen.dart';
import 'package:venus_driver/view/ride_history/presentation/screen/ride_history_screen.dart';
import 'package:venus_driver/widgets/circlular_percent_indicator.dart';
import 'package:venus_driver/widgets/custom_back_dialog.dart';
import 'package:venus_driver/widgets/custom_drawer.dart';
import 'package:venus_driver/widgets/custom_request_card.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    refCancleRide.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeCubit()..initHome()),
          BlocProvider(
            create: (context) => ProfileCubit()..getProfileDetails(),
          ),
        ],
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            // No navigation from HomeScreen — SplashScreen handles routing on startup.
          },
          child: Scaffold(
              drawer: CustomDrawer(
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
              ),
              backgroundColor: Colors.white,
              body: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                final cubit = HomeCubit.of(context);
                final cubitDetails = ProfileCubit.of(context);
                return RefreshIndicator(
                  color: BrandColors.colorPrimary,
                  onRefresh: () async {
                    await cubitDetails.getProfileDetails();
                  },
                  child: state is GetProfileDetailsLoading
                      ? const LoadingIndicator()
                      : WillPopScope(
                          onWillPop: () async {
                            return (await showBackAlertDialog(
                                    action: LocaleKeys.yes.tr(),
                                    content: LocaleKeys.exitApp.tr(),
                                    context: context,
                                    onPressed: () {
                                      refDriversInfo.remove();
                                      refRequset.remove();
                                      refReceiptRide.remove();
                                      Navigator.of(context).pop(true);
                                    })) ??
                                false;
                          },
                          child: SafeArea(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60.w,
                                          height: 60.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            // image: DecorationImage(
                                            //     fit: BoxFit.cover,
                                            //     image: NetworkImage(
                                            //       cubitDetails.driverData == null
                                            //           ? ""
                                            //           : cubitDetails
                                            //               .driverData!.photo,
                                            //     )),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        SizedBox(
                                          width: 100.w,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cubitDetails.driverData == null
                                                    ? ""
                                                    : cubitDetails
                                                        .driverData!.name
                                                        .toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                cubitDetails.driverData == null
                                                    ? ""
                                                    : cubitDetails
                                                        .driverData!.carType,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: BrandColors
                                                        .colorTextLight,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        BlocBuilder<ProfileCubit, ProfileState>(
                                          builder: (context, state) {
                                            return state is StatusLoaded
                                                ? const Center(
                                                    child:
                                                        LoadingIndicatorStatus())
                                                : InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    onTap: () async {
                                                      setState(() {
                                                        cubitDetails.driverData!
                                                                    .avabile ==
                                                                'online'
                                                            ? showSnackBar(
                                                                LocaleKeys
                                                                    .nowNotAvailableRequests
                                                                    .tr())
                                                            : showSnackBar(
                                                                LocaleKeys
                                                                    .nowAvailableRequests
                                                                    .tr());
                                                        cubitDetails.driverData!
                                                                    .avabile ==
                                                                'offline'
                                                            ? cubitDetails
                                                                .goOnline()
                                                            : cubitDetails
                                                                .goOffline();
                                                      });
                                                    },
                                                    child: BlocBuilder<
                                                        ProfileCubit,
                                                        ProfileState>(
                                                      builder:
                                                          (context, state) {
                                                        return Container(
                                                          height: 36.w,
                                                          width: 80.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                            color: cubitDetails
                                                                        .driverData ==
                                                                    null
                                                                ? Colors.white
                                                                : cubitDetails
                                                                            .driverData!
                                                                            .avabile ==
                                                                        'offline'
                                                                    ? Colors.red[
                                                                        400]
                                                                    : Colors.green[
                                                                        400],
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xffDDDDDD),
                                                                blurRadius: 6.0,
                                                                spreadRadius:
                                                                    2.0,
                                                                offset: Offset(
                                                                    0.0, 0.0),
                                                              )
                                                            ],
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            cubitDetails.driverData ==
                                                                    null
                                                                ? ""
                                                                : cubitDetails
                                                                            .driverData!
                                                                            .avabile ==
                                                                        'offline'
                                                                    ? LocaleKeys
                                                                        .offline
                                                                        .tr()
                                                                    : LocaleKeys
                                                                        .online
                                                                        .tr(),
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        );
                                                      },
                                                    ),
                                                  );
                                          },
                                        ),
                                        SizedBox(width: 10.w),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () async {
                                            // showCancleAlertDialog(
                                            //     context: context);
                                            // log(isOnline.toString());
                                            // showCancleAlertDialog(
                                            //     context: context);

                                            // FirebaseMessaging firebaseMessaging =
                                            //     FirebaseMessaging.instance;
                                            // String? token =
                                            //     await firebaseMessaging
                                            //         .getToken();
                                            // // deviceToken = token;
                                            // log("token is $token");
                                            // log(cubitDetails.driverData!.photo);
                                            // log(CacheHelper.getData(
                                            //     key: 'token'));
                                            log(LocationService
                                                    .instance.currentPosition
                                                    ?.toString() ??
                                                'position not available');
                                          },
                                          child: Container(
                                              height: 36.w,
                                              width: 36.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: HexColor('#F7F8F8'),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xffDDDDDD),
                                                    blurRadius: 6.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(0.0, 0.0),
                                                  )
                                                ],
                                              ),
                                              child: SizedBox(
                                                height: 18.h,
                                                width: 16.w,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                      'assets/images/notifcation.svg'),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10.w),
                                        Builder(builder: (context) {
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () {
                                              Scaffold.of(context).openDrawer();
                                            },
                                            child: Container(
                                                height: 36.w,
                                                width: 36.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  color: HexColor('#F7F8F8'),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color(0xffDDDDDD),
                                                      blurRadius: 6.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(0.0, 0.0),
                                                    )
                                                  ],
                                                ),
                                                child: SizedBox(
                                                  height: 18.h,
                                                  width: 16.w,
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                        'assets/images/menu.svg'),
                                                  ),
                                                )),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            MagicRouter.navigateTo(
                                                const RideHistoryScreen());
                                          },
                                          child: Container(
                                            height: 65.h,
                                            width: 95.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffDDDDDD),
                                                  blurRadius: 25,
                                                  spreadRadius: 2.0,
                                                  offset: Offset(0.0, 0.0),
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cubitDetails.driverData ==
                                                          null
                                                      ? ""
                                                      : cubitDetails
                                                          .driverData!.rides
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0.sp,
                                                      color:
                                                          BrandColors.deepBlue),
                                                ),
                                                Text(
                                                  LocaleKeys.trip.tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0.sp,
                                                      color: BrandColors
                                                          .colorTextLight),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 65.h,
                                          width: 95.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xffDDDDDD),
                                                blurRadius: 25,
                                                spreadRadius: 2.0,
                                                offset: Offset(0.0, 0.0),
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 20.w,
                                                width: 20.w,
                                                child: Image.asset(
                                                    'assets/images/Star.png'),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                cubitDetails.driverData == null
                                                    ? ""
                                                    : cubitDetails
                                                        .driverData!.rating
                                                        .toStringAsFixed(1)
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0.sp,
                                                    color: BrandColors
                                                        .colorTextLight),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            MagicRouter.navigateTo(
                                                const ReviewScreen());
                                          },
                                          child: Container(
                                            height: 65.h,
                                            width: 95.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xffDDDDDD),
                                                  blurRadius: 25,
                                                  spreadRadius: 2.0,
                                                  offset: Offset(0.0, 0.0),
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cubitDetails.driverData ==
                                                          null
                                                      ? ""
                                                      : cubitDetails
                                                          .driverData!.rates
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0.sp,
                                                      color:
                                                          BrandColors.deepBlue),
                                                ),
                                                Text(
                                                  LocaleKeys.ratings.tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0.sp,
                                                      color: BrandColors
                                                          .colorTextLight),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  circlularPercentIndicator(
                                      percent: .6,
                                      wallets: cubitDetails.driverData == null
                                          ? ""
                                          : HelperMethods.formatBalance(
                                              cubitDetails.driverData!.wallets)),
                                  SizedBox(height: 30.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        LocaleKeys.availableRequests.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0.sp,
                                            color: BrandColors.deepBlue),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: const Divider(
                                      thickness: 1,
                                    ),
                                  ),
                                  BlocBuilder<HomeCubit, HomeState>(
                                    builder: (context, state) {
                                      final trip = cubit.tripDetails;
                                      final hasRequest = cubit.checkData !=
                                              null &&
                                          trip != null;
                                      final showLoading =
                                          (state is GetRequest ||
                                                  state is HomeLoading) &&
                                              !hasRequest;
                                      if (showLoading) {
                                        return const LoadingIndicator();
                                      }
                                      return Container(
                                        color: Colors.white,
                                        height: 320.w,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        child: cubitDetails.driverData ==
                                                    null ||
                                                cubitDetails.driverData!.avabile !=
                                                    'online' ||
                                                trip == null
                                            ? Lottie.asset(
                                                'assets/json/moving_car.json')
                                            : customRequestCard(
                                                context: context,
                                                cost: trip.cost,
                                                endTime: trip.endTime,
                                                endTrip: trip.endTrip,
                                                name: trip.clientName,
                                                startTime: trip.startTime,
                                                startTrip: trip.startTrip,
                                                image: trip.photo,
                                                onTap: () async {
                                                  await cubit.acceptDriverRide(
                                                      context: context,
                                                      driverId: cubitDetails
                                                          .driverData!
                                                          .id);
                                                  await refRequset.remove();
                                                },
                                                statusRide:
                                                    trip.rideType ==
                                                            "not_directed"
                                                        ? true
                                                        : false),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          )),
                );
              })),
        ));
  }
}
