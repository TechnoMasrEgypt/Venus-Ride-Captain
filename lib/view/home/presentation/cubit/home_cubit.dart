import 'dart:async';
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
  StreamSubscription<DatabaseEvent>? _requestSubscription;

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
    final details = tripDetails;
    if (details == null) return;
    emit(HomeLoading());
    final res = await homeRepo.acceptDriverRide(details.ride, driverId);
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
        await _notifyClientDriverAccepted(details.ride);

        MagicRouter.navigateTo(MapScreen(tripDetails: details));

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
      'ride': int.parse(clientUserId),
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
    _requestSubscription?.cancel();
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
    if (_requestSubscription != null) return;
    print("Start requestes");
    _requestSubscription = refRequset.onValue.listen(
      (DatabaseEvent event) async {
        print("start evant ${event.snapshot.value} ");
        print("path " + refRequset.path);
        checkData = event.snapshot.value;
        if (isClosed) return;
        if (event.snapshot.value == null) {
          tripDetails = null;
          emit(DoneRequest());
          assetsAudioPlayer.stop();
          return;
        }
        try {
          final Map data = event.snapshot.value as Map;
          tripDetails = TripDetails(
              clientName: data['client'].toString(),
              cost: data['cost'].toString(),
              endTime: data['endTime'].toString(),
              endTrip: data['endRide'].toString(),
              startTime: data['startTime'].toString(),
              phone: data['phone'].toString(),
              startTrip: data['startRide'].toString(),
              currentLat: data['currentLat'].toString(),
              currentLng: data['currentLng'].toString(),
              distanceLat: data['distanceLat'].toString(),
              distanceLng: data['distanceLng'].toString(),
              photo: data['photo'].toString(),
              ride: data['ride'].toString(),
              rideType: data['rideType'].toString());
        } catch (e) {
          log('[HomeCubit] Failed to parse request: $e');
          emit(DoneRequest());
          return;
        }
        emit(GetRequest());
        try {
          await assetsAudioPlayer.play(
            AssetSource('sounds/notification_sound.mp3'),
          );
          print("Doneeeee");
          print("Before launch app");
          await Future.delayed(const Duration(milliseconds: 500));
          print("After launch app");
        } catch (e) {
          log('[HomeCubit] Request sound error: $e');
        } finally {
          // Always resolve the state so the UI never stays stuck on loading.
          emit(DoneRequest());
        }
      },
    );
  }
}
