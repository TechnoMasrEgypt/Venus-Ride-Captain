// ignore_for_file: use_build_context_synchronously, await_only_futures, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dataModels/trip_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/utils/brand_colors.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/presentation/cubit/map_cubit.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_back_dialog.dart';
import 'package:venus_driver/widgets/custom_drawer.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({required this.tripDetails, super.key});
  final TripDetails? tripDetails;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String mapTheme = '';
  bool startTrip = false;

  @override
  void initState() {
    super.initState();
    HelperMethods.disableLocationUpdates();
    DefaultAssetBundle.of(context)
        .loadString('assets/style/silver_theme.json')
        .then((value) => {mapTheme = value});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit()
        ..setCustomMarker()
        ..getPolyPoints(double.parse(widget.tripDetails!.distanceLat),
            double.parse(widget.tripDetails!.distanceLng))
        ..getCurrentPositionUpdate(),
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
                      child: Icon(Icons.navigation_rounded),
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
                              target: LatLng(currentPosition.latitude,
                                  currentPosition.longitude),
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
                                rotation: currentPosition.heading,
                                markerId: const MarkerId("CurrentPosition"),
                                icon: cubit.currentLocationIcon,
                                position: LatLng(currentPosition.latitude,
                                    currentPosition.longitude),
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
                                  child: customAuthButton(
                                      text: startTrip
                                          ? LocaleKeys.endTrip.tr()
                                          : LocaleKeys.startTrip.tr(),
                                      onTap: () {
                                        setState(() {
                                          if (!startTrip) {
                                            startTrip = !startTrip;
                                            cubit.rideWay(widget.tripDetails,
                                                widget.tripDetails!.ride);
                                          } else {
                                            cubit.getDirectionDetails(
                                                endPosition: LatLng(
                                                    currentPosition.latitude,
                                                    currentPosition.longitude),
                                                rideID:
                                                    widget.tripDetails!.ride,
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
