import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/dataModels/trip_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/home/data/model/ride_request_details.dart';
import 'package:venus_driver/view/home/data/repo/home_repo.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/presentation/screen/map_screen.dart';
import 'package:venus_driver/widgets/custom_cancle_dialog.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

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
        // await showSnackBar(res.message);
        emit(HomeInitial());
        MagicRouter.navigateTo(MapScreen(
          tripDetails: tripDetails,
        ));
        refRequset.remove();
      },
    );
  }

  Future sendToken() async {
    emit(HomeLoading());
    final res = await homeRepo.sendToken();
    res.fold(
      (err) async {
        log(err);
        emit(HomeInitial());
      },
      (res) async {
        emit(HomeInitial());
      },
    );
  }

  void getCurrentPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        showSnackBar('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LocationSettings settings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
    positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position newposition) {
      currentPosition = newposition;
      updateLocation();
    });
  }

  void updateLocation() async {
    print("update success");
    await refDriversInfo.set({
      "name": CacheHelper.getData(key: 'name'),
      "location": {
        "lat": currentPosition.latitude,
        "lng": currentPosition.longitude,
        "accuracy": currentPosition.accuracy,
        "altitude": currentPosition.altitude,
        "speed": currentPosition.speed,
        "speedAccuracy": currentPosition.speedAccuracy,
        "heading": currentPosition.heading,
        "timestamp": currentPosition.timestamp.toString(),
        "id": CacheHelper.getData(key: 'id'),
      },
    });
  }

  Future getRequest() async {
    print("Start requestes");
    refRequset.onValue.listen((DatabaseEvent event) async {
      print("start enant ${event.snapshot.value} ");
      checkData = event.snapshot.value;
      emit(GetRequest());
      if (event.snapshot.value == null) {
        emit(DoneRequest());
        assetsAudioPlayer.stop();
        return;
      } else {
        final Map data = event.snapshot.value as Map;
        assetsAudioPlayer.open(
          Audio("assets/sounds/alert.mp3"),
          autoStart: false,
          showNotification: true,
        );
        assetsAudioPlayer.play();
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
    });
  }
}
