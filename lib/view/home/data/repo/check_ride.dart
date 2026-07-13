import 'dart:developer';

import 'package:venus_driver/dataModels/trip_details.dart';

class OngoingRideModel {
  final int id;
  final String status;
  final String startRide;
  final String endRide;
  final String startTime;
  final String endTime;
  final String cost;

  OngoingRideModel({
    required this.id,
    required this.status,
    required this.startRide,
    required this.endRide,
    required this.startTime,
    required this.endTime,
    required this.cost,
  });

  factory OngoingRideModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    log('🔥 [OngoingRideModel] raw data = $data');
    return OngoingRideModel(
      id: data['id'] ?? 0,
      status: data['status']?.toString() ?? '',
      startRide: data['startRide']?.toString() ?? '',
      endRide: data['endRide']?.toString() ?? '',
      startTime: data['startTime']?.toString() ?? '',
      endTime: data['endTime']?.toString() ?? '',
      cost: data['cost']?.toString() ?? '0',
    );
  }

  TripDetails toTripDetails() => TripDetails(
        clientName: '',
        cost: cost,
        endTime: endTime,
        endTrip: endRide,
        startTime: startTime,
        phone: '',
        startTrip: startRide,
        currentLat: '0',
        currentLng: '0',
        distanceLat: '0',
        distanceLng: '0',
        photo: '',
        ride: id.toString(),
        rideType: '',
      );
}
