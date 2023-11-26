// To parse this JSON data, do
//
// final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

DataEditModel driverModelFromJson(String str) =>
    DataEditModel.fromJson(json.decode(str));

String driverModelToJson(DataEditModel data) => json.encode(data.toJson());

class DataEditModel {
  DataEditModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  DataEdit data;

  factory DataEditModel.fromJson(Map<String, dynamic> json) => DataEditModel(
        status: json["status"],
        message: json["message"],
        data: DataEdit.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class DataEdit {
  DataEdit({
    required this.id,
    required this.name,
    this.userName,
    required this.email,
    required this.language,
    required this.phone,
    required this.photo,
  });

  int id;
  String name;
  dynamic userName;
  String email;
  String language;
  String phone;
  String photo;

  factory DataEdit.fromJson(Map<String, dynamic> json) => DataEdit(
        id: json["id"],
        name: json["name"],
        userName: json["userName"],
        email: json["email"],
        language: json["language"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userName": userName,
        "email": email,
        "language": language,
        "phone": phone,
        "photo": photo,
      };
}
