// To parse this JSON data, do
//
//     final reviewHistoryModel = reviewHistoryModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewHistoryModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewHistoryModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  String status;
  String message;
  List<ReviewData> data;

  ReviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        status: json["status"],
        message: json["message"],
        data: List<ReviewData>.from(
            json["data"].map((x) => ReviewData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ReviewData {
  Client client;
  dynamic rating;
  String? message;

  ReviewData({
    required this.client,
    required this.rating,
    this.message,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        client: Client.fromJson(json["client"]),
        rating: json["rating"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "client": client.toJson(),
        "rating": rating,
        "message": message,
      };
}

class Client {
  String name;
  String photo;

  Client({
    required this.name,
    required this.photo,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "photo": photo,
      };
}
