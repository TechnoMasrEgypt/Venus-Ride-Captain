// ignore_for_file: use_build_context_synchronously, await_only_futures, deprecated_member_use
import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dataModels/trip_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/view/chat/presentations/views/chat_view.dart';
import 'package:venus_driver/view/map/presentation/cubit/map_cubit.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_cancel_button.dart';
import 'package:venus_driver/widgets/custom_back_dialog.dart';
import 'package:venus_driver/widgets/custom_drawer.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';

import '../../../chat/presentations/views_models/chat_cubit/cubit/chat_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({required this.tripDetails, super.key});
  final TripDetails? tripDetails;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String mapTheme = '';
  int countTimedown = 3;
  void cancleTime() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      log('$countTimedown:00');
      countTimedown--;
      if (countTimedown == 0) {
        timer.cancel();
        log('Countdown finished!');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cancleTime();
    DefaultAssetBundle.of(context)
        .loadString('assets/style/silver_theme.json')
        .then((value) => {mapTheme = value});
    log(widget.tripDetails!.rideType);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapCubit()
            ..setCustomMarker()
            ..getPolyPoints(double.parse(widget.tripDetails!.currentLat),
                double.parse(widget.tripDetails!.currentLng))
            ..getCurrentPositionUpdate()
            ..cancleRideFireBase(context),
        ),
        BlocProvider(
            create: (context) => ChatCubit()
              ..getAllMessages(rideId: int.parse(widget.tripDetails!.ride))),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        buildWhen: (p, c) =>
            c is LocationUpdated ||
            c is DirectionUpdated ||
            c is PolyLoading ||
            c is PolyLoaded ||
            c is MapInitial ||
            c is MapLoading ||
            c is CancleLoaded ||
            c is CancleLoading,
        builder: (context, state) {
          final cubit = MapCubit.of(context);
          return Scaffold(
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
              floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 385.w),
                child: InkWell(
                  onTap: () {
                    HelperMethods.openMap(
                        double.parse(widget.tripDetails!.currentLat),
                        double.parse(widget.tripDetails!.currentLng));
                  },
                  child: const CircleAvatar(
                    backgroundColor: BrandColors.colorPrimary,
                    radius: 25,
                    child: Icon(
                      Icons.navigation_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              body: WillPopScope(
                  onWillPop: () async {
                    return (await showBackAlertDialog(
                            action: LocaleKeys.yes.tr(),
                            content: LocaleKeys.cancelRide.tr(),
                            context: context,
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              cubit.cancelledRide(widget.tripDetails!.ride);
                              HelperMethods.cancleLocationUpdates();
                            })) ??
                        false;
                  },
                  child: SlidingUpPanel(
                    defaultPanelState: PanelState.OPEN,
                    maxHeight: MediaQuery.of(context).size.height / 1.90,
                    minHeight: 125.w,
                    controller: cubit.panelController,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.r),
                        topLeft: Radius.circular(30.r)),
                    parallaxEnabled: true,
                    body: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GoogleMap(
                          padding: EdgeInsets.only(bottom: 125.h),
                          initialCameraPosition: CameraPosition(
                            zoom: 13.5,
                            target: LatLng(
                              LocationService.instance.currentPosition?.latitude ?? googlePlex.target.latitude,
                              LocationService.instance.currentPosition?.longitude ?? googlePlex.target.longitude,
                            ),
                          ),
                          myLocationEnabled: false,
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId("route"),
                              points: cubit.polylineCoordinates,
                              color: BrandColors.colorPrimary,
                              width: 5,
                            ),
                          },
                          markers: {
                            Marker(
                              rotation: LocationService.instance.currentPosition?.heading ?? 0,
                              markerId: const MarkerId("CurrentPosition"),
                              icon: cubit.currentLocationIcon,
                              position: LatLng(
                                LocationService.instance.currentPosition?.latitude ?? googlePlex.target.latitude,
                                LocationService.instance.currentPosition?.longitude ?? googlePlex.target.longitude,
                              ),
                            ),
                            Marker(
                              markerId: const MarkerId("destination"),
                              icon: cubit.destinationIcon,
                              position: LatLng(
                                  double.parse(widget.tripDetails!.currentLat),
                                  double.parse(widget.tripDetails!.currentLng)),
                            ),
                          },
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(mapTheme);
                            cubit.controller.complete(controller);
                            cubit.mapController = controller;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.w, right: 13.w),
                          child: Builder(builder: (context) {
                            return customIconBack(
                              icon: Icons.menu,
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    panelBuilder: (ScrollController scroll) {
                      return Stack(
                        children: [
                          Positioned(
                            top: 10.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.r)),
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                            width: 75.w,
                                            height: 75.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    widget.tripDetails!.photo),
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          widget.tripDetails!.clientName
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0.sp,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 135.h,
                                  width: 360.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                          width: .5,
                                          color: HexColor('97ADB6'))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: widget.tripDetails!.rideType !=
                                            "not_directed"
                                        ? Column(
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
                                                        widget.tripDetails!
                                                            .startTime,
                                                        style: TextStyle(
                                                            fontSize: 13.0.sp,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 30.h,
                                                      ),
                                                      Text(
                                                        widget.tripDetails!
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
                                                          Icons.arrow_drop_down,
                                                          color:
                                                              Color(0xff4B545A),
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
                                                          widget.tripDetails!
                                                              .startTrip,
                                                          style: TextStyle(
                                                              fontSize: 15.0.sp,
                                                              color:
                                                                  Colors.black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        Text(
                                                          maxLines: 2,
                                                          widget.tripDetails!
                                                              .endTrip,
                                                          style: TextStyle(
                                                              fontSize: 15.0.sp,
                                                              color:
                                                                  Colors.black,
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
                                          )
                                        : Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  CacheHelper.getData(
                                                              key: 'lang') ==
                                                          'en'
                                                      ? "A trip without a known destination"
                                                      : "رحلة بدون وجهة معروفة",
                                                  style: TextStyle(
                                                      fontSize: 18.0.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  Icons.location_off,
                                                  color:
                                                      BrandColors.colorPrimary,
                                                  size: 60.r,
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 70.h,
                                  width: 360.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                          width: .5,
                                          color: HexColor('97ADB6'))),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        children: [
                                          widget.tripDetails!.rideType !=
                                                  "not_directed"
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      LocaleKeys.dinar.tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18.0.sp,
                                                          color: HexColor(
                                                              '#3E4958')),
                                                    ),
                                                    Text(
                                                      widget.tripDetails!.cost,
                                                      style: TextStyle(
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 45.0.sp,
                                                          color: HexColor(
                                                              '#3E4958')),
                                                    ),
                                                  ],
                                                )
                                              : const Icon(Icons.attach_money),
                                          const Spacer(),
                                          BlocBuilder<ChatCubit, ChatState>(
                                            builder: (context, state) {
                                              final cubit =
                                                  ChatCubit.get(context);
                                              // final driver = cubit.isDriver(
                                              //     driverId: widget.iDdriver);
                                              // int messageCount = cubit
                                              //         .messages.isNotEmpty
                                              //     ? cubit.messages.length
                                              //     : 0; {
                                              return InkWell(
                                                onTap: () async {
                                                  await MagicRouter.navigateTo(
                                                      ChatView(
                                                          driverName: widget
                                                              .tripDetails!
                                                              .clientName,
                                                          rideId: int.parse(
                                                              widget
                                                                  .tripDetails!
                                                                  .ride)));
                                                  cubit.resetMessageCount();
                                                },
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                      height: 44.h,
                                                      width: 80.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.r)),
                                                          color: Colors.green),
                                                      child: Center(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            LocaleKeys.chat
                                                                .tr(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    15.0.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                    // cubit.messages.any((message) =>
                                                    //             message.userId
                                                    //                 .toString() ==
                                                    //             CacheHelper.getData(
                                                    //                     key:
                                                    //                         'id')
                                                    //                 .toString()) &&
                                                    cubit.messages.isNotEmpty
                                                        ? Positioned(
                                                            right: -4,
                                                            top: -8,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              width: 20.w,
                                                              height: 20.h,
                                                            ))
                                                        : SizedBox()
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              launch(widget.tripDetails!
                                                      .callphone()
                                                  // 'tel://${int.parse(widget.tripDetails!.phone)}'
                                                  );
                                            },
                                            child: Container(
                                              height: 44.h,
                                              width: 121.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.r)),
                                                  color: BrandColors.deepBlue),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 17.5,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(Icons.phone),
                                                  ),
                                                  Text(
                                                    LocaleKeys.contact.tr(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0.sp,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      state is MapLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : customAuthButton(
                                              color: BrandColors.deepBlue,
                                              text: LocaleKeys.arrived.tr(),
                                              onTap: () {
                                                cubit.pickUPRide(
                                                    widget.tripDetails,
                                                    widget.tripDetails!.ride);
                                                HelperMethods
                                                    .cancleLocationUpdates();
                                              },
                                              hight: 50.h,
                                              width: 160.w),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      customCancelButton(onTap: () {
                                        if (countTimedown == 0) {
                                          showBackAlertDialog(
                                              action: LocaleKeys.yes.tr(),
                                              content:
                                                  LocaleKeys.cancleFee.tr(),
                                              context: context,
                                              onPressed: () {
                                                cubit.cancelledRide(
                                                    widget.tripDetails!.ride);
                                              });
                                        } else {
                                          cubit.cancelledRide(
                                              widget.tripDetails!.ride);
                                        }
                                      }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  )));
        },
      ),
    );
  }
}
