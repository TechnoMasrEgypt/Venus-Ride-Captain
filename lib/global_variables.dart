import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:audioplayers/audioplayers.dart';

String mapKey = 'AIzaSyBaj8TdogqYDV8xOtl2HyJT7HO8m1IkcIE';
String mapKeyWithBilling = 'AIzaSyBaj8TdogqYDV8xOtl2HyJT7HO8m1IkcIE';

final globalScaffoldKey = GlobalKey<ScaffoldMessengerState>();
const CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.0274113, 31.3732026),
  zoom: 14.4746,
);

DatabaseReference get refDriversInfo => FirebaseDatabase.instance
    .ref("Drivers/${CacheHelper.getData(key: 'id').toString()}");
DatabaseReference get refRequset => FirebaseDatabase.instance
    .ref("RequestRide/${CacheHelper.getData(key: 'id').toString()}");
DatabaseReference get refReceiptRide => FirebaseDatabase.instance
    .ref("ReceiptRide/${CacheHelper.getData(key: 'id').toString()}");
DatabaseReference get refCancleRide => FirebaseDatabase.instance
    .ref("cancleDriverRides/${CacheHelper.getData(key: 'id').toString()}");
final assetsAudioPlayer = AudioPlayer();

FirebaseAuth auth = FirebaseAuth.instance;
Country selectedCountry = Country(
    phoneCode: '20',
    countryCode: 'EG',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Egypt',
    example: 'Egypt',
    displayName: 'Egypt',
    displayNameNoCountryCode: 'EG',
    e164Key: '');
const kMessagesCollection = ('messages');
const kMessage = ('message');
const kCreatedAt = ('createdAt');
const kDeepBlue = Color(0xff001447);
DatabaseReference listenChat2({required int rideId}) {
  return FirebaseDatabase.instance.ref("notifyChatDriver/$rideId");
}
