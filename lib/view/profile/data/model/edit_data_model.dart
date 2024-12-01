// To parse this JSON data, do
//
//     final editDataModel = editDataModelFromJson(jsonString);

import 'dart:convert';

EditDataModel editDataModelFromJson(String str) =>
    EditDataModel.fromJson(json.decode(str));

String editDataModelToJson(EditDataModel data) => json.encode(data.toJson());

class EditDataModel {
  String status;
  String message;
  EditData data;

  EditDataModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EditDataModel.fromJson(Map<String, dynamic> json) => EditDataModel(
        status: json["status"],
        message: json["message"],
        data: EditData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class EditData {
  int id;
  String name;
  dynamic userName;
  String language;
  String phone;
  String photo;

  EditData({
    required this.id,
    required this.name,
    this.userName,
    required this.language,
    required this.phone,
    required this.photo,
  });

  factory EditData.fromJson(Map<String, dynamic> json) => EditData(
        id: json["id"],
        name: json["name"],
        userName: json["userName"],
        language: json["language"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userName": userName,
        "language": language,
        "phone": phone,
        "photo": photo,
      };
}
