import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dataModels/trip_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/home/data/model/ride_request_details.dart';
import 'package:venus_driver/view/home/data/repo/home_repo.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/presentation/screen/map_screen.dart';
import 'package:venus_driver/widgets/custom_cancle_dialog.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

import 'package:audioplayers/audioplayers.dart';

part 'home_state.dart';

void _navigateToScreenFromNotification() {
  if (CacheHelper.getData(key: 'login') == true) {
    MagicRouter.navigateAndPopAll(const HomeScreen());
  } else {
    MagicRouter.navigateAndPopAll(const LoginScreen());
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit of(context) => BlocProvider.of(context);
  final homeRepo = HomeRepo();
  RideRequistDetailsData? rideRequistDetailsData;
  TripDetails? tripDetails;
  dynamic checkData;
  Future updateLocation(double lat, double lng) async {
    final res = await homeRepo.updateLocation(lat, lng);
    res.fold((err) {
      log("[HomeCubit] Silent updateLocation failed: ${err.toString()}");
      emit(UpdateLocationFailed());
    }, (res) {
      log("[HomeCubit] Silent updateLocation success");

      emit(UpdateLocationSuccess());
    });
  }

  Future acceptDriverRide(
      {required int driverId, required BuildContext context}) async {
    emit(HomeLoading());
    final res = await homeRepo.acceptDriverRide(tripDetails!.ride, driverId);
    res.fold(
      (err) async {
        await showCancleAlertDialog(
            context: context,
            title: err,
            onTap: () {
              MagicRouter.pop();
            });
        // await showSnackBar(err);
        log(err);
        emit(HomeInitial());
      },
      (res) async {
        rideRequistDetailsData = res.data;
        emit(HomeInitial());

        // [FIX] Write acceptance notification to client BEFORE removing request
        await _notifyClientDriverAccepted(tripDetails!.ride);

        MagicRouter.navigateTo(MapScreen(tripDetails: tripDetails));

        await Future.delayed(const Duration(seconds: 2)); // let client read it
        refRequset.remove();
      },
    );
  }

  Future<void> _notifyClientDriverAccepted(String clientUserId) async {
    await FirebaseDatabase.instance.ref("AcceptRide/$clientUserId").set({
      'board': CacheHelper.getData(key: 'board'),
      'driver': CacheHelper.getData(key: 'name'),
      'phone': CacheHelper.getData(key: 'phone'),
      'photo': CacheHelper.getData(key: 'photo'),
      'rate': CacheHelper.getData(key: 'rate') ?? 0,
      'type': CacheHelper.getData(key: 'carType'),
      'IDdriver': CacheHelper.getData(key: 'id'),
      'ride': int.parse(tripDetails!.ride),
    });
  }

  /// Sends the FCM token to the backend silently (no loading state emitted).
  Future sendToken() async {
    final res = await homeRepo.sendToken();
    res.fold(
      (err) => log('[HomeCubit] sendToken error: $err'),
      (res) => log('[HomeCubit] sendToken success'),
    );
  }

  /// Starts real-time location tracking via [LocationService].
  /// Safe to call multiple times — LocationService guards against double-start.
  Future<void> startLocationTracking() async {
    try {
      LocationService.instance.onLocationUpdated = (lat, lng) {
        updateLocation(lat, lng);
      };
      await LocationService.instance.startTracking();
      emit(LocationLoaded());
    } catch (e) {
      showSnackBar('Location Not Available');
      emit(LocationInitial());
    }
  }

  @override
  Future<void> close() {
    LocationService.instance.onLocationUpdated = null;
    return super.close();
  }

  /// Called once when HomeScreen mounts.
  /// Location tracking is already started by SplashScreen; this just ensures
  /// the Firebase listener is active and the FCM token is up to date.
  Future<void> initHome() async {
    log('🏠 [HomeCubit] initHome()');
    emit(HomeLoading());
    await startLocationTracking();
    sendToken();
    await getRequest();
    emit(HomeInitial());
  }

  Future getRequest() async {
    print("Start requestes");
    refRequset.onValue.listen(
      (DatabaseEvent event) async {
        print("start evant ${event.snapshot.value} ");
        print("path " + refRequset.path);
        checkData = event.snapshot.value;
        emit(GetRequest());
        if (event.snapshot.value == null) {
          emit(DoneRequest());
          assetsAudioPlayer.stop();
          return;
        } else {
          final Map data = event.snapshot.value as Map;
          await assetsAudioPlayer.play(
            AssetSource('sounds/notification_sound.mp3'),
          );
          print("Doneeeee");
          print("Before launch app");
          // Add delay before launching app
          await Future.delayed(Duration(milliseconds: 500));
          print("After launch app");
          String startRide = data['startRide'].toString();
          String endRide = data['endRide'].toString();
          String phone = data['phone'].toString();
          String startTime = data['startTime'].toString();
          String endTime = data['endTime'].toString();
          String client = data['client'].toString();
          String cost = data['cost'].toString();
          String currentLat = data['currentLat'].toString();
          String currentLng = data['currentLng'].toString();
          String distanceLat = data['distanceLat'].toString();
          String distanceLng = data['distanceLng'].toString();
          String photo = data['photo'].toString();
          String ride = data['ride'].toString();
          String rideType = data['rideType'].toString();
          tripDetails = TripDetails(
              clientName: client,
              cost: cost,
              endTime: endTime,
              endTrip: endRide,
              startTime: startTime,
              phone: phone,
              startTrip: startRide,
              currentLat: currentLat,
              currentLng: currentLng,
              distanceLat: distanceLat,
              distanceLng: distanceLng,
              photo: photo,
              ride: ride,
              rideType: rideType);
          emit(DoneRequest());
        }
      },
    );
  }
}
