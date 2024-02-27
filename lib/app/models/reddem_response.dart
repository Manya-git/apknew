import 'dart:convert';

RedeemResponse redeemResponseFromJson(String str) => RedeemResponse.fromJson(json.decode(str));
String redeemResponseToJson(RedeemResponse data) => json.encode(data.toJson());

class RedeemResponse {
  int? remainingRewardPoints;
  double? updatedPlanPrice;
  int? rewardPointsToRedeem;
  double? rewardPointsValue;
  double? planActualPrice;
  String? rewardPointsValueCurrency;
  bool? couponCodeApplied;
  String? currency;
  double? finalPayableAmount;
  double? couponDiscountedPrice;
  double? couponCodeValue;
  String? couponCodeValueCurrency;
  String? couponCodeToRedeem;
  double? planPricePassedForCoupon;
  bool? rewardPointsApplied;

  RedeemResponse({
    this.remainingRewardPoints,
    this.updatedPlanPrice,
    this.rewardPointsToRedeem,
    this.rewardPointsValue,
    this.planActualPrice,
    this.rewardPointsValueCurrency,
    this.couponCodeApplied,
    this.currency,
    this.finalPayableAmount,
    this.couponDiscountedPrice,
    this.couponCodeValue,
    this.couponCodeValueCurrency,
    this.couponCodeToRedeem,
    this.planPricePassedForCoupon,
    this.rewardPointsApplied,
  });

  factory RedeemResponse.fromJson(Map<String, dynamic> json) => RedeemResponse(
        remainingRewardPoints: json["remainingRewardPoints"],
        updatedPlanPrice: json["updatedPlanPrice"] != null ? json["updatedPlanPrice"].toDouble() : 0.0,
        rewardPointsToRedeem: json["rewardPointsToRedeem"],
        rewardPointsValue: json["rewardPointsValue"] != null ? json["rewardPointsValue"].toDouble() : 0.0,
        planActualPrice: json["planActualPrice"] != null ? json["planActualPrice"].toDouble() : 0.0,
        rewardPointsValueCurrency: json["rewardPointsValueCurrency"],
        couponCodeApplied: json["couponCodeApplied"],
        currency: json["currency"],
        finalPayableAmount: json["finalPayableAmount"] != null ? json["finalPayableAmount"].toDouble() : 0.0,
        couponDiscountedPrice: json["couponDiscountedPrice"] != null ? json["couponDiscountedPrice"].toDouble() : 0.0,
        couponCodeValue: json["couponCodeValue"] != null ? json["couponCodeValue"].toDouble() : 0.0,
        couponCodeValueCurrency: json["couponCodeValueCurrency"],
        couponCodeToRedeem: json["couponCodeToRedeem"],
        planPricePassedForCoupon:
            json["planPricePassedForCoupon"] != null ? json["planPricePassedForCoupon"].toDouble() : 0.0,
        rewardPointsApplied: json["rewardPointsApplied"],
      );

  Map<String, dynamic> toJson() => {
        "remainingRewardPoints": remainingRewardPoints,
        "updatedPlanPrice": updatedPlanPrice,
        "rewardPointsToRedeem": rewardPointsToRedeem,
        "rewardPointsValue": rewardPointsValue,
        "planActualPrice": planActualPrice,
        "rewardPointsValueCurrency": rewardPointsValueCurrency,
        "couponCodeApplied": couponCodeApplied,
        "currency": currency,
        "finalPayableAmount": finalPayableAmount,
        "couponDiscountedPrice": couponDiscountedPrice,
        "couponCodeValue": couponCodeValue,
        "couponCodeValueCurrency": couponCodeValueCurrency,
        "couponCodeToRedeem": couponCodeToRedeem,
        "planPricePassedForCoupon": planPricePassedForCoupon,
        "rewardPointsApplied": rewardPointsApplied,
      };
}
