import 'dart:convert';

RewardResponse rewardResponseFromJson(String str) => RewardResponse.fromJson(json.decode(str));

String rewardResponseToJson(RewardResponse data) => json.encode(data.toJson());

class RewardResponse {
  int? rewardPoints;
  String? cashValue;
  String? referralCode;
  String? currency;

  RewardResponse({
    this.rewardPoints,
    this.cashValue,
    this.referralCode,
    this.currency,
  });

  factory RewardResponse.fromJson(Map<String, dynamic> json) => RewardResponse(
        rewardPoints: json["rewardPoints"] ?? 0,
        cashValue: json["cashValue"] != null ? json["cashValue"].toString() : "0",
        referralCode: json["referralCode"] ?? "",
        currency: json["currency"] ?? "USD",
      );

  Map<String, dynamic> toJson() => {
        "rewardPoints": rewardPoints,
        "cashValue": cashValue,
        "referralCode": referralCode,
        "currency": currency,
      };
}
