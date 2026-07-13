// ignore_for_file: use_build_context_synchronously, await_only_futures, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dataModels/trip_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/helpers/hex_color.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/chat/presentations/views/chat_view.dart';
import 'package:venus_driver/view/chat/presentations/views_models/chat_cubit/cubit/chat_cubit.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/presentation/cubit/map_cubit.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_back_dialog.dart';
import 'package:venus_driver/widgets/custom_drawer.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';

class TripScreen extends StatefulWidget {
  const TripScreen(
      {required this.tripDetails, this.isOngoing = false, super.key});
  final TripDetails? tripDetails;
  final bool isOngoing;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String mapTheme = '';
  bool startTrip = false;

  @override
  void initState() {
    super.initState();
    startTrip = widget.isOngoing; // ← set from outside

    HelperMethods.disableLocationUpdates();
    DefaultAssetBundle.of(context)
        .loadString('assets/style/silver_theme.json')
        .then((value) => {mapTheme = value});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = MapCubit()
              ..setCustomMarker()
              ..getPolyPoints(double.parse(widget.tripDetails!.distanceLat),
                  double.parse(widget.tripDetails!.distanceLng))
              ..getCurrentPositionUpdate();

            // ✅ safe here — cubit is already created
            if (widget.isOngoing) {
              cubit.startRealTimeDirectionUpdates(LatLng(
                double.parse(widget.tripDetails!.distanceLat),
                double.parse(widget.tripDetails!.distanceLng),
              ));
            }

            return cubit;
          },
        ),
        BlocProvider(
            create: (context) => ChatCubit()
              ..getAllMessages(rideId: int.parse(widget.tripDetails!.ride))),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final cubit = MapCubit.of(context);
          return WillPopScope(
            onWillPop: () async {
              return (await showBackAlertDialog(
                      action: LocaleKeys.yes.tr(),
                      content: LocaleKeys.cancelRide.tr(),
                      context: context,
                      onPressed: () {
                        MagicRouter.navigateAndPopAll(const HomeScreen());
                        cubit.cancelledRide(widget.tripDetails!.ride);
                        HelperMethods.cancleLocationUpdates();
                      })) ??
                  false;
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
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: InkWell(
                    onTap: () {
                      if (!startTrip) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content:
                                      Text(LocaleKeys.pleaseStartTheTrip.tr()),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                BrandColors.colorPrimary),
                                        onPressed: () {
                                          MagicRouter.pop();
                                        },
                                        child: Text(LocaleKeys.ok.tr())),
                                  ],
                                ));
                      } else {
                        HelperMethods.openMap(
                            double.parse(widget.tripDetails!.distanceLat),
                            double.parse(widget.tripDetails!.distanceLng));
                      }
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
                body: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GoogleMap(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            initialCameraPosition: CameraPosition(
                              zoom: 13.5,
                              target: LatLng(
                                LocationService
                                        .instance.currentPosition?.latitude ??
                                    googlePlex.target.latitude,
                                LocationService
                                        .instance.currentPosition?.longitude ??
                                    googlePlex.target.longitude,
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
                                rotation: LocationService
                                        .instance.currentPosition?.heading ??
                                    0,
                                markerId: const MarkerId("CurrentPosition"),
                                icon: cubit.currentLocationIcon,
                                position: LatLng(
                                  LocationService
                                          .instance.currentPosition?.latitude ??
                                      googlePlex.target.latitude,
                                  LocationService.instance.currentPosition
                                          ?.longitude ??
                                      googlePlex.target.longitude,
                                ),
                              ),
                              Marker(
                                markerId: const MarkerId("destination"),
                                icon: cubit.destinationIcon,
                                position: LatLng(
                                    double.parse(
                                        widget.tripDetails!.distanceLat),
                                    double.parse(
                                        widget.tripDetails!.distanceLng)),
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
                            padding: EdgeInsets.only(top: 40.h, right: 13.w),
                            child: Builder(builder: (context) {
                              return customIconBack(
                                icon: Icons.menu,
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            }),
                          ),
                          state is RideDoneLoading && startTrip
                              ? const Positioned(
                                  bottom: 30,
                                  right: 50,
                                  child: Center(
                                      child: CircularProgressIndicator()))
                              : Positioned(
                                  bottom: 30,
                                  right: 90,
                                  child: SizedBox(
                                    height: 110.h,
                                    //  width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (!startTrip)
                                          SizedBox(
                                            width: 250.w,
                                            height: 50.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                BlocBuilder<ChatCubit,
                                                    ChatState>(
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
                                                        await MagicRouter
                                                            .navigateTo(ChatView(
                                                                driverName: widget
                                                                    .tripDetails!
                                                                    .clientName,
                                                                rideId: int
                                                                    .parse(widget
                                                                        .tripDetails!
                                                                        .ride)));
                                                        cubit
                                                            .resetMessageCount();
                                                      },
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 44.h,
                                                            width: 80.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(15
                                                                            .r)),
                                                                color: Colors
                                                                    .green),
                                                            child: Center(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  LocaleKeys
                                                                      .chat
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15.0
                                                                              .sp,
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
                                                          cubit.messages
                                                                  .isNotEmpty
                                                              ? Positioned(
                                                                  right: -4,
                                                                  top: -8,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .red,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    width: 20.w,
                                                                    height:
                                                                        20.h,
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
                                                        color: BrandColors
                                                            .deepBlue),
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
                                                          child:
                                                              Icon(Icons.phone),
                                                        ),
                                                        Text(
                                                          LocaleKeys.contact
                                                              .tr(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0.sp,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50.h,
                                          // width: double.infinity,
                                          // width: double.infinity,
                                          child: customAuthButton(
                                              text: startTrip
                                                  ? LocaleKeys.endTrip.tr()
                                                  : LocaleKeys.startTrip.tr(),
                                              onTap: () {
                                                setState(() {
                                                  if (!startTrip) {
                                                    startTrip = !startTrip;
                                                    cubit.rideWay(
                                                        widget.tripDetails,
                                                        widget
                                                            .tripDetails!.ride);
                                                  } else {
                                                    cubit.getDirectionDetails(
                                                        endPosition: LatLng(
                                                          LocationService
                                                                  .instance
                                                                  .currentPosition
                                                                  ?.latitude ??
                                                              googlePlex.target
                                                                  .latitude,
                                                          LocationService
                                                                  .instance
                                                                  .currentPosition
                                                                  ?.longitude ??
                                                              googlePlex.target
                                                                  .longitude,
                                                        ),
                                                        rideID: widget
                                                            .tripDetails!.ride,
                                                        startPosition: LatLng(
                                                            double.parse(widget
                                                                .tripDetails!
                                                                .currentLat),
                                                            double.parse(widget
                                                                .tripDetails!
                                                                .currentLng)));
                                                    HelperMethods
                                                        .cancleLocationUpdates();
                                                  }
                                                });
                                              },
                                              hight: 50.h,
                                              width: 250.w),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
