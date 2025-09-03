// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

DriverModel driverModelFromJson(String str) =>
    DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  String status;
  String message;
  DriverData data;

  DriverModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        status: json["status"],
        message: json["message"],
        data: DriverData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class DriverData {
  dynamic id;
  dynamic user;
  dynamic name;
  dynamic userName;
  dynamic email;
  dynamic language;
  dynamic phone;
  dynamic avabile;
  dynamic identityCardNumber;
  dynamic license;
  dynamic deviceToken;
  dynamic photo;
  dynamic carType;
  dynamic carBoard;
  dynamic wallets;
  dynamic rides;
  dynamic rates;
  dynamic rating;
  dynamic lastWallet;

  DriverData({
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
    this.deviceToken,
    required this.photo,
    required this.carType,
    required this.carBoard,
    required this.wallets,
    required this.rides,
    required this.rates,
    required this.rating,
    required this.lastWallet,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
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
        deviceToken: json["device_token"],
        photo: json["photo"],
        carType: json["carType"],
        carBoard: json["carBoard"],
        wallets: json["wallets"],
        rides: json["rides"],
        rates: json["rates"],
        rating: json["rating"],
        lastWallet: json["lastWallet"]?.toDouble(),
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
        "device_token": deviceToken,
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
