import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:venus_driver/dataModels/direction_details.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/helpers/helper_methods.dart';
import 'package:venus_driver/helpers/request_helper.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/data/repo/map_repo.dart';
import 'package:venus_driver/view/map/presentation/screen/trip_screen.dart';
import 'package:venus_driver/view/receipt/presentation/screen/receipt_screen.dart';
import 'package:venus_driver/widgets/custom_cancle_dialog.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  static MapCubit of(context) => BlocProvider.of(context);
  final mapRepo = MapRepo();
  DirectionDetails? directionDetails;
  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController mapController;
  final panelController = PanelController();

  List<LatLng> polylineCoordinates = [];
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getPolyPoints(lat, lng) async {
    emit(PolyLoaded());
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey, // Your Google Map Key
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(lat, lng),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      emit(PolyLoading());
    }
  }

  void getCurrentPositionUpdate() async {
    emit(LocationInitial());
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    GoogleMapController googleMapController = await controller.future;
    LocationSettings settings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
    positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position newposition) {
      emit(LocationLoaded());
      currentPosition = newposition;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 17.5,
              target: LatLng(newposition.latitude, newposition.longitude))));
      emit(LocationLoading());
    });
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/3.0x/ic_pick.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/car.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  Future pickUPRide(tripDetails, rideId) async {
    emit(MapLoading());
    final res = await mapRepo.pickUPRide(rideId);
    res.fold(
      (err) async {
        await showSnackBar('Error');
        emit(MapInitial());
      },
      (res) async {
        await showSnackBar(res.message.toString());
        emit(MapInitial());
        log(res.message.toString());
        MagicRouter.navigateTo(TripScreen(tripDetails: tripDetails));
      },
    );
    panelController.open();
  }

  Future rideWay(
    tripDetails,
    rideId,
  ) async {
    emit(MapLoading());
    final res = await mapRepo.rideWay(rideId);
    res.fold(
      (err) async {
        await showSnackBar(err);
        log(err);
        emit(MapInitial());
      },
      (res) async {
        await showSnackBar(res.message.toString());
        log(res.message.toString());
        emit(MapInitial());
      },
    );
  }

  Future rideDone(
      {required rideID,
      required startAddress,
      required endAddress,
      required km}) async {
    emit(RideDoneLoading());
    final res = await mapRepo.rideDone(
        endAddress: endAddress,
        km: km,
        rideID: rideID,
        startAddress: startAddress);
    res.fold(
      (err) async {
        await showSnackBar('Error');
        log(err);
        emit(MapInitial());
      },
      (res) async {
        await showSnackBar(res.message.toString());
        emit(MapInitial());
        MagicRouter.navigateTo(const ReceiptScreen());
      },
    );
  }

  Future cancelledRide(rideId) async {
    emit(MapLoading());
    final res = await mapRepo.cancelledRide(rideId);
    res.fold(
      (err) async {
        await showSnackBar('Error');
        emit(MapInitial());
      },
      (res) async {
        emit(MapInitial());
        MagicRouter.navigateTo(const HomeScreen());
      },
    );
  }

  Future cancleRideFireBase(context) async {
    refCancleRide.onValue.listen((DatabaseEvent event) {
      emit(CancleLoaded());
      if (event.snapshot.value == null) {
        emit(CancleLoading());
        return;
      } else {
        showCancleAlertDialog(
            context: context,
            title: LocaleKeys.clientCancleRide.tr(),
            onTap: () {
              HelperMethods.cancleLocationUpdates();
              MagicRouter.navigateAndPopAll(const HomeScreen());
              assetsAudioPlayer.stop();
              refCancleRide.remove();
            });
        assetsAudioPlayer.play();
        emit(CancleLoading());
      }
    });
  }

  Future<DirectionDetails?> getDirectionDetails(
      {required LatLng startPosition,
      required LatLng endPosition,
      required rideID}) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKeyWithBilling';

    var response = await RequestHelper.getRequest(url);
    if (response == 'failed' || response['status'] != 'OK') {
      return null;
    }

    directionDetails = DirectionDetails(
      distanceText: response['routes'][0]['legs'][0]['distance']['text'],
      distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
      durationText: response['routes'][0]['legs'][0]['duration']['text'],
      durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      encodedPoints: response['routes'][0]['overview_polyline']['points'],
      endAddress: response['routes'][0]['legs'][0]['start_address'],
      startAddress: response['routes'][0]['legs'][0]['end_address'],
    );
    rideDone(
        endAddress: directionDetails!.endAddress,
        km: directionDetails!.distanceValue / 1000,
        rideID: rideID,
        startAddress: directionDetails!.startAddress);
    return directionDetails;
  }
}
