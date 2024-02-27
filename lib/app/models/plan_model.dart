import 'dart:convert';

import 'package:get/get.dart';

import 'data_usage_model.dart';

List<PlanModel> productModelFromJson(String str) =>
    List<PlanModel>.from(json.decode(str).map((x) => PlanModel.fromJson(x, "")));
PlanModel productModelFromJsonSingle(String str) => PlanModel.fromJson(json.decode(str), "");

String productModelToJson(List<PlanModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanModel {
  PlanModel({
    this.id,
    this.data,
    this.productCategory,
    this.validity,
    this.iccid,
    this.zone,
    this.country,
    this.allowOveruse,
    this.priceOverUseInMb,
    this.priceBundle,
    this.mbIncludedInBundle,
    this.productType,
    this.cycleUnits,
    this.cycle,
    this.currency,
    this.stripeProductId,
    this.eventType,
    this.productDescription,
    this.name,
    this.isActivating,
    this.v,
    this.transactionId,
    this.isActive,
    this.status,
    this.purchaseDate,
    this.expiredDate,
    this.activationDate,
    this.isAutoRefillOn,
    this.info,
    this.price,
    this.flag,
    this.productId,
    this.earnedPoints,
    this.rewardPointsRedeemed,
    this.rewardCashValueRedeemed,
    this.newEsim,
    this.couponAmount,
    this.couponCode,
    this.defaultPrice,
    this.convertedPrice,
    this.paymentMethod,
    this.dataUsageModel,
  });

  String? id;
  String? data;
  String? productCategory;
  int? validity;
  String? iccid;
  String? zone;
  String? country;
  bool? allowOveruse;
  dynamic priceOverUseInMb;
  double? priceBundle;
  int? mbIncludedInBundle;
  String? productType;
  String? cycleUnits;
  int? cycle;
  List<String>? info;
  String? currency;
  String? stripeProductId;
  String? eventType;
  dynamic productDescription;
  String? name;
  int? v;
  double? price;
  String? productId;
  String? transactionId;
  RxBool? isActive;
  String? status;
  String? flag;
  RxBool? isActivating;
  DateTime? purchaseDate;
  DateTime? expiredDate;
  DateTime? activationDate;
  bool? isAutoRefillOn;
  int? earnedPoints;
  int? rewardPointsRedeemed;
  double? rewardCashValueRedeemed;
  bool? newEsim;
  double? couponAmount;
  String? couponCode;
  Price? defaultPrice;
  Price? convertedPrice;
  String? paymentMethod;
  DataUsageModel? dataUsageModel;

  factory PlanModel.fromJson(Map<String, dynamic> json, String? transactionId) => PlanModel(
        id: json["_id"],
        data: json["data"],
        productCategory: json["productCategory"],
        validity: json["validity"],
        iccid: json["iccid"] ?? "",
        zone: json["zone"],
        info: json['info'] == null ? [] : List<String>.from(json["info"].map((x) => x)),
        country: json["country"] ?? json["zone"] ?? "",
        allowOveruse: json["allowOveruse"],
        priceOverUseInMb: json["priceOverUseInMB"],
        priceBundle: json["priceBundle"] != null ? json["priceBundle"].toDouble() : 0.0,
        mbIncludedInBundle: json["mbIncludedInBundle"],
        productType: json["productType"],
        cycleUnits: json["cycleUnits"] ?? "",
        cycle: json["cycle"] ?? 1,
        currency: json["currency"],
        stripeProductId: json["stripeProductId"] ?? "",
        eventType: json["eventType"],
        productDescription: json["productDescription"],
        name: json["name"],
        flag: json["flag"] ?? "",
        productId: json["productId"],
        isActive: RxBool(json["isActive"] ?? false),
        transactionId: json["transactionId"] ?? transactionId,
        status: json["status"] ?? "upcoming",
        isActivating: RxBool(false),
        purchaseDate: json["purchaseDate"] != null ? DateTime.parse(json["purchaseDate"]) : DateTime.now(),
        expiredDate: json["expiryDate"] != null ? DateTime.parse(json["expiryDate"]) : DateTime.now(),
        activationDate: json["activationDate"] != null ? DateTime.parse(json["activationDate"]) : DateTime.now(),
        isAutoRefillOn: json["isAutoRefillOn"] ?? false,
        v: json["__v"],
        price: json["price"] != null ? json["price"].toDouble() : 0.0,
        newEsim: json["newEsim"] ?? false,
        earnedPoints: json["earnedPoints"] ?? 0,
        rewardPointsRedeemed: json["rewardPointsRedeemed"] ?? 0,
        rewardCashValueRedeemed:
            json["rewardCashValueRedeemed"] != null ? json["rewardCashValueRedeemed"].toDouble() : 0.0,
        couponAmount: json["couponAmount"] != null ? json["couponAmount"].toDouble() : 0.0,
        couponCode: json["couponCode"] ?? "",
        defaultPrice: json["defaultPrice"] != null ? Price.fromJson(json["defaultPrice"]) : Price(),
        convertedPrice: json["convertedPrice"] != null ? Price.fromJson(json["convertedPrice"]) : Price(),
        paymentMethod: json["paymentMethod"] ?? "Stripe",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "data": data,
        "productCategory": productCategory,
        "validity": validity,
        "country": country,
        "productId": productId ?? "not found",
        "priceBundle": priceBundle,
        "currency": currency,
        "stripeProductId": stripeProductId,
        "name": name,
        "transactionId": transactionId,
        "isActive": isActive!.value,
        "status": status,
        "flag": flag,
        "isAutoRefillOn": isAutoRefillOn,
        "cycleUnits": cycleUnits,
        "cycle": cycle,
        "price": price,
        "iccid": iccid,
        "newEsim": newEsim,
        "earnedPoints": earnedPoints,
        "rewardPointsRedeemed": rewardPointsRedeemed,
        "rewardCashValueRedeemed": rewardCashValueRedeemed,
        "activationDate": activationDate!.toIso8601String(),
        "couponAmount": couponAmount,
        "couponCode": couponCode,
        "defaultPrice": defaultPrice!.toJson(),
        "convertedPrice": convertedPrice!.toJson(),
        "paymentMethod": paymentMethod,
      };
}

class Price {
  double? price;
  String? currency;

  Price({
    this.price,
    this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        price: json["price"].toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "currency": currency,
      };
}

class SupportedCountryClass {
  String name;
  String? flag;
  String cca3;
  String id;

  SupportedCountryClass({
    required this.name,
    this.flag,
    required this.cca3,
    required this.id,
  });

  factory SupportedCountryClass.fromJson(Map<String, dynamic> json) => SupportedCountryClass(
        name: json["name"],
        flag: json["flag"],
        cca3: json["cca3"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "flag": flag,
        "cca3": cca3,
        "_id": id,
      };
}
