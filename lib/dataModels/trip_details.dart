class TripDetails {
  final String startTrip;
  final String endTrip;
  final String startTime;
  final String endTime;
  final String clientName;
  final String cost;
  final String currentLat;
  final String currentLng;
  final String distanceLat;
  final String distanceLng;
  final String phone;
  final String photo;
  final String ride;
  final String rideType;

  TripDetails({
    required this.startTrip,
    required this.endTrip,
    required this.startTime,
    required this.phone,
    required this.endTime,
    required this.clientName,
    required this.cost,
    required this.currentLat,
    required this.currentLng,
    required this.distanceLat,
    required this.distanceLng,
    required this.photo,
    required this.ride,
    required this.rideType,
  });
  //بشيل كود الدولة  الى هو اول 3 ارقام فخلى بالك لو زوتواكزد الدول فى المستقبل غير ده
  String callphone() {
    String modifiedString = phone.substring(4);

    return 'tel://${modifiedString}';
  }
}
