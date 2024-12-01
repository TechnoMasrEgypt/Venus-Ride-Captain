// To parse this JSON data, do
//
//     final rideHistoryModel = rideHistoryModelFromJson(jsonString);

import 'dart:convert';

RideHistoryModel rideHistoryModelFromJson(String str) =>
    RideHistoryModel.fromJson(json.decode(str));

String rideHistoryModelToJson(RideHistoryModel data) =>
    json.encode(data.toJson());

class RideHistoryModel {
  String status;
  String message;
  List<RideHistoryData> data;

  RideHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) =>
      RideHistoryModel(
        status: json["status"],
        message: json["message"],
        data: List<RideHistoryData>.from(
            json["data"].map((x) => RideHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RideHistoryData {
  int id;
  DateTime date;
  int driverId;
  int clientId;
  String status;
  String startRide;
  String endRide;
  dynamic costRide;
  String startTime;
  String endTime;
  String time;
  dynamic responsible;
  String? valueRide;
  dynamic evaluteId;
  dynamic coupunId;
  dynamic reasonCancelled;
  DateTime createdAt;
  DateTime updatedAt;

  RideHistoryData({
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
    this.valueRide,
    this.evaluteId,
    this.coupunId,
    this.reasonCancelled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideHistoryData.fromJson(Map<String, dynamic> json) =>
      RideHistoryData(
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
        coupunId: json["coupun_id"],
        reasonCancelled: json["reason_cancelled"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "coupun_id": coupunId,
        "reason_cancelled": reasonCancelled,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
