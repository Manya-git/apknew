import 'dart:convert';

ConfigResponse configResponseFromJson(String str) => ConfigResponse.fromJson(json.decode(str));

String configResponseToJson(ConfigResponse data) => json.encode(data.toJson());

class ConfigResponse {
  String? message;
  Data? data;

  ConfigResponse({
    this.message,
    this.data,
  });

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => ConfigResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  bool? stripeEnabled;
  bool? stripeEnableApplePay;
  String? stripeKey;
  bool? oneClickInstallMasterEnabled;
  bool? topupPlansMasterEnabled;
  bool? topupPlansEnabled;
  bool? multiLingualMasterEnabled;
  bool? currencyConversionMasterEnabled;
  bool? couponCodesMasterEnabled;
  bool? rewardPointsMasterEnabled;
  bool? rewardPointsEnabled;
  RewardPointsValue? rewardPointsValue;
  RewardPointsEarning? rewardPointsEarning;
  int? rewardPointsMinRedeem;
  int? rewardPointsMaxRedeem;
  int? rewardPointsReferral;
  DateTime? cacheId;

  Data({
    this.stripeEnabled,
    this.stripeEnableApplePay,
    this.stripeKey,
    this.oneClickInstallMasterEnabled,
    this.topupPlansMasterEnabled,
    this.topupPlansEnabled,
    this.multiLingualMasterEnabled,
    this.currencyConversionMasterEnabled,
    this.couponCodesMasterEnabled,
    this.rewardPointsMasterEnabled,
    this.rewardPointsEnabled,
    this.rewardPointsValue,
    this.rewardPointsEarning,
    this.rewardPointsMinRedeem,
    this.rewardPointsMaxRedeem,
    this.rewardPointsReferral,
    this.cacheId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stripeEnabled: json["stripeEnabled"] ?? false,
        stripeEnableApplePay: json["stripeEnableApplePay"] ?? false,
        stripeKey: json["stripeKey"] ?? "",
        oneClickInstallMasterEnabled: json["oneClickInstallMasterEnabled"] ?? false,
        topupPlansMasterEnabled: json["topupPlansMasterEnabled"] ?? false,
        topupPlansEnabled: json["topupPlansEnabled"] ?? false,
        multiLingualMasterEnabled: json["multiLingualMasterEnabled"] ?? false,
        currencyConversionMasterEnabled: json["currencyConversionMasterEnabled"] ?? false,
        couponCodesMasterEnabled: json["couponCodesMasterEnabled"] ?? false,
        rewardPointsMasterEnabled: json["rewardPointsMasterEnabled"] ?? false,
        rewardPointsEnabled: json["rewardPointsEnabled"] ?? false,
        rewardPointsValue: RewardPointsValue.fromJson(json["rewardPointsValue"]),
        rewardPointsEarning: RewardPointsEarning.fromJson(json["rewardPointsEarning"]),
        rewardPointsMinRedeem: json["rewardPointsMinRedeem"] ?? 100,
        rewardPointsMaxRedeem: json["rewardPointsMaxRedeem"] ?? 500,
        rewardPointsReferral: json["rewardPointsReferral"] ?? 0,
        cacheId: json["cacheId"] != null ? DateTime.parse(json["cacheId"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "stripeEnabled": stripeEnabled,
        "stripeEnableApplePay": stripeEnableApplePay,
        "stripeKey": stripeKey,
        "oneClickInstallMasterEnabled": oneClickInstallMasterEnabled,
        "topupPlansMasterEnabled": topupPlansMasterEnabled,
        "topupPlansEnabled": topupPlansEnabled,
        "multiLingualMasterEnabled": multiLingualMasterEnabled,
        "currencyConversionMasterEnabled": currencyConversionMasterEnabled,
        "couponCodesMasterEnabled": couponCodesMasterEnabled,
        "rewardPointsMasterEnabled": rewardPointsMasterEnabled,
        "rewardPointsEnabled": rewardPointsEnabled,
        "rewardPointsValue": rewardPointsValue!.toJson(),
        "rewardPointsEarning": rewardPointsEarning!.toJson(),
        "rewardPointsMinRedeem": rewardPointsMinRedeem,
        "rewardPointsMaxRedeem": rewardPointsMaxRedeem,
        "rewardPointsReferral": rewardPointsReferral,
        "cacheId": cacheId!.toIso8601String(),
      };
}

class RewardPointsEarning {
  double? purchaseValue;
  double? rewardPoints;

  RewardPointsEarning({
    this.purchaseValue,
    this.rewardPoints,
  });

  factory RewardPointsEarning.fromJson(Map<String, dynamic> json) => RewardPointsEarning(
        purchaseValue: json["purchaseValue"] != null ? json["purchaseValue"].toDouble() : 0.0,
        rewardPoints: json["rewardPoints"] != null ? json["rewardPoints"].toDouble() : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "purchaseValue": purchaseValue,
        "rewardPoints": rewardPoints,
      };
}

class RewardPointsValue {
  double? cashValue;
  double? rewardPoints;

  RewardPointsValue({
    this.cashValue,
    this.rewardPoints,
  });

  factory RewardPointsValue.fromJson(Map<String, dynamic> json) => RewardPointsValue(
        cashValue: json["cashValue"] != null ? json["cashValue"].toDouble() : 0.0,
        rewardPoints: json["rewardPoints"] != null ? json["rewardPoints"].toDouble() : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "cashValue": cashValue,
        "rewardPoints": rewardPoints,
      };
}
