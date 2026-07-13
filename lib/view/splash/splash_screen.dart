import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/home/data/repo/home_repo.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/presentation/screen/map_screen.dart';
import 'package:venus_driver/view/map/presentation/screen/trip_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// The screen to navigate to — resolved by [_checkAndNavigate].
  Widget? _destination;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// Runs the 2-second minimum delay AND the route-resolution in parallel.
  /// Navigation fires once, after BOTH futures complete.
  Future<void> _init() async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _checkAndNavigate(),
    ]);

    // _destination is always set before _checkAndNavigate() returns
    MagicRouter.navigateAndPopAll(_destination!);
  }

  /// Determines the correct destination and stores it in [_destination].
  /// Never throws. Never calls MagicRouter directly.
  Future<void> _checkAndNavigate() async {
    // Not logged in → LoginScreen
    if (CacheHelper.getData(key: 'login') != true) {
      _destination = const LoginScreen();
      return;
    }

    // Pre-start GPS so Map/Trip screens have a position ready immediately
    try {
      await LocationService.instance.startTracking();
    } catch (_) {}

    // Check for an ongoing ride on the backend
    try {
      final result = await HomeRepo().checkOngoingRide();
      result.fold(
        (err) {
          log('🚀 [SplashScreen] No ongoing ride → HomeScreen ($err)');
          _destination = const HomeScreen();
        },
        (ride) {
          log('🚀 [SplashScreen] Ongoing ride: status=${ride.status}');
          final tripDetails = ride.toTripDetails();

          if (ride.status == 'intheway') {
            // Trip in progress → TripScreen (ongoing = true)
            _destination = TripScreen(tripDetails: tripDetails, isOngoing: true);
          } else if (ride.status == 'beign' || ride.status == 'pickup') {
            // Accepted, not started → MapScreen
            _destination = MapScreen(tripDetails: tripDetails);
          } else {
            // Completed / unknown → HomeScreen
            _destination = const HomeScreen();
          }
        },
      );
    } catch (e) {
      log('🚀 [SplashScreen] Error → HomeScreen ($e)');
      _destination = const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Image.asset('assets/images/white_logo.png'),
          ),
        ),
      ),
    );
  }
}
