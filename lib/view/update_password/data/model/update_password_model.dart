// To parse this JSON data, do
//
//     final updatePasswordModel = updatePasswordModelFromJson(jsonString);

import 'dart:convert';

UpdatePasswordModel updatePasswordModelFromJson(String str) =>
    UpdatePasswordModel.fromJson(json.decode(str));

String updatePasswordModelToJson(UpdatePasswordModel data) =>
    json.encode(data.toJson());

class UpdatePasswordModel {
  UpdatePasswordModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  bool data;

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
