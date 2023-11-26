// To parse this JSON data, do
//
//     final walletHistoryModel = walletHistoryModelFromJson(jsonString);

import 'dart:convert';

WalletHistoryModel walletHistoryModelFromJson(String str) =>
    WalletHistoryModel.fromJson(json.decode(str));

String walletHistoryModelToJson(WalletHistoryModel data) =>
    json.encode(data.toJson());

class WalletHistoryModel {
  String status;
  String message;
  List<WalletHistoryData> data;

  WalletHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) =>
      WalletHistoryModel(
        status: json["status"],
        message: json["message"],
        data: List<WalletHistoryData>.from(
            json["data"].map((x) => WalletHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class WalletHistoryData {
  int id;
  String date;
  int cardId;
  int driverId;
  dynamic balance;
  String totalBalance;
  Card card;

  WalletHistoryData({
    required this.id,
    required this.date,
    required this.cardId,
    required this.driverId,
    required this.balance,
    required this.totalBalance,
    required this.card,
  });

  factory WalletHistoryData.fromJson(Map<String, dynamic> json) =>
      WalletHistoryData(
        id: json["id"],
        date: json["date"],
        cardId: json["card_id"],
        driverId: json["driver_id"],
        balance: json["balance"],
        totalBalance: json["totalBalance"],
        card: Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "card_id": cardId,
        "driver_id": driverId,
        "balance": balance,
        "totalBalance": totalBalance,
        "card": card.toJson(),
      };
}

class Card {
  int id;
  String name;
  dynamic value;

  Card({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
