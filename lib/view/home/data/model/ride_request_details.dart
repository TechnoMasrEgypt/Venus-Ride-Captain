// To parse this JSON data, do
//
//     final rideRequistDetails = rideRequistDetailsFromJson(jsonString);

import 'dart:convert';

RideRequistDetails rideRequistDetailsFromJson(String str) =>
    RideRequistDetails.fromJson(json.decode(str));

String rideRequistDetailsToJson(RideRequistDetails data) =>
    json.encode(data.toJson());

class RideRequistDetails {
  RideRequistDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  RideRequistDetailsData data;

  factory RideRequistDetails.fromJson(Map<String, dynamic> json) =>
      RideRequistDetails(
        status: json["status"],
        message: json["message"],
        data: RideRequistDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class RideRequistDetailsData {
  RideRequistDetailsData({
    required this.id,
    required this.date,
    required this.driverId,
    required this.clientId,
    required this.status,
    required this.startRide,
    required this.endRide,
    required this.costRide,
    required this.startTime,
    required this.endTime,
    required this.time,
    this.responsible,
    required this.valueRide,
    this.evaluteId,
    this.reasonCancelled,
    required this.createdAt,
    required this.updatedAt,
    required this.driver,
  });

  int? id;
  DateTime date;
  String? driverId;
  int? clientId;
  String? status;
  String? startRide;
  String? endRide;
  dynamic costRide;
  String? startTime;
  dynamic endTime;
  String? time;
  dynamic responsible;
  String? valueRide;
  dynamic evaluteId;
  dynamic reasonCancelled;
  DateTime createdAt;
  DateTime updatedAt;
  Driver driver;

  factory RideRequistDetailsData.fromJson(Map<String, dynamic> json) =>
      RideRequistDetailsData(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        driverId: json["driver_id"],
        clientId: json["client_id"],
        status: json["status"],
        startRide: json["start_ride"],
        endRide: json["end_ride"],
        costRide: json["cost_ride"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        time: json["time"],
        responsible: json["responsible"],
        valueRide: json["value_ride"],
        evaluteId: json["evalute_id"],
        reasonCancelled: json["reason_cancelled"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        driver: Driver.fromJson(json["driver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "driver_id": driverId,
        "client_id": clientId,
        "status": status,
        "start_ride": startRide,
        "end_ride": endRide,
        "cost_ride": costRide,
        "start_time": startTime,
        "end_time": endTime,
        "time": time,
        "responsible": responsible,
        "value_ride": valueRide,
        "evalute_id": evaluteId,
        "reason_cancelled": reasonCancelled,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "driver": driver.toJson(),
      };
}

class Driver {
  Driver({
    required this.id,
    required this.userId,
    required this.date,
    this.phone,
    required this.address,
    required this.numberId,
    required this.licenseNumber,
    this.notes,
    required this.status,
    required this.isAvalible,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.evalutes,
    required this.car,
  });

  int? id;
  int? userId;
  DateTime date;
  dynamic phone;
  String? address;
  String? numberId;
  String? licenseNumber;
  dynamic notes;
  String? status;
  int? isAvalible;
  String? lat;
  String? lng;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  List<dynamic> evalutes;
  Car car;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        userId: json["user_id"],
        date: DateTime.parse(json["date"]),
        phone: json["phone"],
        address: json["address"],
        numberId: json["number_id"],
        licenseNumber: json["license_number"],
        notes: json["notes"],
        status: json["status"],
        isAvalible: json["isAvalible"],
        lat: json["lat"],
        lng: json["lng"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        evalutes: List<dynamic>.from(json["evalutes"].map((x) => x)),
        car: Car.fromJson(json["car"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "address": address,
        "number_id": numberId,
        "license_number": licenseNumber,
        "notes": notes,
        "status": status,
        "isAvalible": isAvalible,
        "lat": lat,
        "lng": lng,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "evalutes": List<dynamic>.from(evalutes.map((x) => x)),
        "car": car.toJson(),
      };
}

class Car {
  Car({
    required this.id,
    required this.driverId,
    required this.type,
    required this.color,
    required this.modelYear,
    required this.boardNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int driverId;
  String type;
  String color;
  String modelYear;
  int boardNumber;
  DateTime createdAt;
  DateTime updatedAt;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"],
        driverId: json["driver_id"],
        type: json["type"],
        color: json["color"],
        modelYear: json["model_year"],
        boardNumber: json["board_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "type": type,
        "color": color,
        "model_year": modelYear,
        "board_number": boardNumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.username,
    this.title,
    required this.email,
    this.emailVerifiedAt,
    required this.phone,
    this.profilePhoto,
    required this.status,
    required this.role,
    required this.userType,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String username;
  dynamic title;
  String email;
  dynamic emailVerifiedAt;
  String phone;
  dynamic profilePhoto;
  String status;
  String role;
  String userType;
  String language;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        title: json["title"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        profilePhoto: json["profile_photo"],
        status: json["status"],
        role: json["role"],
        userType: json["user_type"],
        language: json["language"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "title": title,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "phone": phone,
        "profile_photo": profilePhoto,
        "status": status,
        "role": role,
        "user_type": userType,
        "language": language,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
