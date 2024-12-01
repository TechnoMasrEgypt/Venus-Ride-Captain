// To parse this JSON data, do
//
//     final rideModel = rideModelFromJson(jsonString);

import 'dart:convert';

RideModel rideModelFromJson(String str) => RideModel.fromJson(json.decode(str));

String rideModelToJson(RideModel data) => json.encode(data.toJson());

class RideModel {
  String status;
  String message;
  RideData data;

  RideModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        status: json["status"],
        message: json["message"],
        data: RideData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class RideData {
  int id;
  int driverId;
  int fee;
  String startRide;
  String endRide;
  int cost;
  int late;
  String startTime;
  String endTime;
  String distance;
  String time;
  int total;
  Driver driver;

  RideData({
    required this.id,
    required this.driverId,
    required this.fee,
    required this.startRide,
    required this.endRide,
    required this.cost,
    required this.late,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.time,
    required this.total,
    required this.driver,
  });

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
        id: json["id"],
        driverId: json["driverId"],
        fee: json["fee"],
        startRide: json["startRide"],
        endRide: json["endRide"],
        cost: json["cost"],
        late: json["late"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        distance: json["distance"],
        time: json["Time"],
        total: json["Total"],
        driver: Driver.fromJson(json["driver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driverId": driverId,
        "fee": fee,
        "startRide": startRide,
        "endRide": endRide,
        "cost": cost,
        "late": late,
        "startTime": startTime,
        "endTime": endTime,
        "distance": distance,
        "Time": time,
        "Total": total,
        "driver": driver.toJson(),
      };
}

class Driver {
  int id;
  int user;
  String name;
  String userName;
  String email;
  String language;
  String phone;
  String avabile;
  String identityCardNumber;
  String license;
  String photo;
  String carType;
  int carBoard;
  int wallets;
  int rides;
  int rates;
  double rating;
  int lastWallet;

  Driver({
    required this.id,
    required this.user,
    required this.name,
    required this.userName,
    required this.email,
    required this.language,
    required this.phone,
    required this.avabile,
    required this.identityCardNumber,
    required this.license,
    required this.photo,
    required this.carType,
    required this.carBoard,
    required this.wallets,
    required this.rides,
    required this.rates,
    required this.rating,
    required this.lastWallet,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        user: json["user"],
        name: json["name"],
        userName: json["userName"],
        email: json["email"],
        language: json["language"],
        phone: json["phone"],
        avabile: json["avabile"],
        identityCardNumber: json["identityCardNumber"],
        license: json["License"],
        photo: json["photo"],
        carType: json["carType"],
        carBoard: json["carBoard"],
        wallets: json["wallets"],
        rides: json["rides"],
        rates: json["rates"],
        rating: json["rating"]?.toDouble(),
        lastWallet: json["lastWallet"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "userName": userName,
        "email": email,
        "language": language,
        "phone": phone,
        "avabile": avabile,
        "identityCardNumber": identityCardNumber,
        "License": license,
        "photo": photo,
        "carType": carType,
        "carBoard": carBoard,
        "wallets": wallets,
        "rides": rides,
        "rates": rates,
        "rating": rating,
        "lastWallet": lastWallet,
      };
}
