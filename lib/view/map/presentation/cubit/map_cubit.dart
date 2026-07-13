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
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/view/map/data/repo/map_repo.dart';
import 'package:venus_driver/view/map/presentation/screen/trip_screen.dart';
import 'package:venus_driver/view/receipt/presentation/screen/receipt_screen.dart';
import 'package:venus_driver/widgets/custom_cancle_dialog.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';
import 'package:audioplayers/audioplayers.dart';
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

  Timer? _directionUpdateTimer; // periodic ETA/distance refresh
  String currentDistance = ''; // shown on map info card
  String currentDuration = ''; // shown on map info card
  LatLng? _destinationLatLng; // cached destination for periodic updates

  void getPolyPoints(lat, lng) async {
    emit(PolyLoaded());
    final pos = LocationService.instance.currentPosition;
    if (pos == null) return;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pos.latitude, pos.longitude),
        destination: PointLatLng(lat, lng),
        mode: TravelMode.driving,
      ),
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
    // Ensure LocationService is tracking (may already be running from HomeScreen).
    await LocationService.instance.startTracking();

    final GoogleMapController googleMapController = await controller.future;

    // Listen to Geolocator stream directly for map camera animations.
    // LocationService handles the GPS stream; here we just subscribe for UI.
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 4,
      ),
    ).listen((Position newPosition) async {
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 17.5,
          target: LatLng(newPosition.latitude, newPosition.longitude),
        ),
      ));
      emit(LocationUpdated());
    });
  }

  void startRealTimeDirectionUpdates(LatLng destination) {
    _destinationLatLng = destination;
    _directionUpdateTimer?.cancel();
    _directionUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateDirectionInfo();
    });
  }

  void stopRealTimeDirectionUpdates() {
    _directionUpdateTimer?.cancel();
    _directionUpdateTimer = null;
  }

  Future<void> _updateDirectionInfo() async {
    if (_destinationLatLng == null) return;
    final pos = LocationService.instance.currentPosition;
    if (pos == null) return;

    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${pos.latitude},${pos.longitude}'
        '&destination=${_destinationLatLng!.latitude},${_destinationLatLng!.longitude}'
        '&mode=driving&key=$mapKeyWithBilling';

    try {
      final response = await RequestHelper.getRequest(url);
      if (response == 'failed' || response['status'] != 'OK') return;

      final leg = response['routes'][0]['legs'][0];
      currentDistance = leg['distance']['text']; // e.g. "1.2 km"
      currentDuration = leg['duration']['text']; // e.g. "4 mins"

      // Refresh polyline with latest route
      final String encoded =
          response['routes'][0]['overview_polyline']['points'];
      polylineCoordinates = _decodePolyline(encoded);

      emit(DirectionUpdated(
          distance: currentDistance, duration: currentDuration));
    } catch (e) {
      log('Direction update error: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    final int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : result >> 1;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : result >> 1;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
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

  Future<void> notifyTripStarted(String clientUserId) async {
    await FirebaseDatabase.instance
        .ref("AcceptRide/$clientUserId")
        .update({'status': 'intheway'});
  }

  Future<void> notifyDriverArrived(String clientUserId) async {
    await FirebaseDatabase.instance
        .ref("Arrived/$clientUserId")
        .set({'arrived': true});
  }

  Future<void> notifyClientCancelled(String clientUserId) async {
    await FirebaseDatabase.instance
        .ref("cancleRides/$clientUserId")
        .set({'cancelled': true});
  }

  Future pickUPRide(
    tripDetails,
    rideId,
  ) async {
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
        await notifyDriverArrived(rideId);

        log(res.message.toString());
        MagicRouter.navigateTo(TripScreen(
          tripDetails: tripDetails,
          isOngoing: false,
        ));
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
        await notifyTripStarted(rideId);
        await notifyTripStarted(rideId);
        final destination = LatLng(
          double.parse(tripDetails.distanceLat),
          double.parse(tripDetails.distanceLng),
        );
        startRealTimeDirectionUpdates(destination);
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
        log("dasdsaddsadsaddad $err");
        emit(MapInitial());
      },
      (res) async {
        await showSnackBar(res.message.toString());
        emit(MapInitial());
        stopRealTimeDirectionUpdates();
        MagicRouter.navigateTo(const ReceiptScreen());
      },
    );
  }

  Future cancelledRide(
    rideId,
  ) async {
    emit(MapLoading());
    final res = await mapRepo.cancelledRide(rideId);
    res.fold(
      (err) async {
        await showSnackBar('Error');
        emit(MapInitial());
      },
      (res) async {
        emit(MapInitial());
        stopRealTimeDirectionUpdates();
        await notifyClientCancelled(rideId);
        MagicRouter.navigateTo(const HomeScreen());
      },
    );
  }

  Future cancleRideFireBase(context) async {
    refCancleRide.onValue.listen((DatabaseEvent event) async {
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
              stopRealTimeDirectionUpdates(); // [NEW] stop timer on client cancel
            });
        await assetsAudioPlayer
            .play(AssetSource('sounds/notification_sound.mp3'));
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

  @override
  Future<void> close() {
    stopRealTimeDirectionUpdates();
    return super.close();
  }
}
