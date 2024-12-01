// To parse this JSON data, do
//
//     final faqsModel = faqsModelFromJson(jsonString);

import 'dart:convert';

import 'package:venus_driver/appStorage/local_cache_helper.dart';

FaqsModel faqsModelFromJson(String str) => FaqsModel.fromJson(json.decode(str));

String faqsModelToJson(FaqsModel data) => json.encode(data.toJson());

class FaqsModel {
  FaqsModel({
    required this.status,
    required this.data,
  });

  String status;
  List<FaqsData> data;

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
        status: json["status"],
        data:
            List<FaqsData>.from(json["data"].map((x) => FaqsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FaqsData {
  FaqsData({
    required this.question,
    required this.answer,
  });

  String question;
  String answer;

  factory FaqsData.fromJson(Map<String, dynamic> json) => FaqsData(
        question: CacheHelper.getData(key: 'lang') == "ar"
            ? json["question_ar"]
            : json["question_en"],
        answer: CacheHelper.getData(key: 'lang') == "ar"
            ? json["answer_ar"]
            : json["answer_en"],
      );

  Map<String, dynamic> toJson() => {
        CacheHelper.getData(key: 'lang') == "ar"
            ? "question_ar"
            : "question_en": question,
        CacheHelper.getData(key: 'lang') == "ar" ? "answer_ar" : "answer_en":
            answer,
      };
}
