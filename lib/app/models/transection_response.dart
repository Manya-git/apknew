import 'dart:convert';

List<TransectionResponse> transectionResponseFromJson(String str) =>
    List<TransectionResponse>.from(json.decode(str).map((x) => TransectionResponse.fromJson(x)));

String transectionResponseToJson(List<TransectionResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransectionResponse {
  String? id;
  String? subscriptionId;
  String? subscriberId;
  String? type;
  int? rewardPointsEarned;
  int? rewardPointsRedeemed;
  String? currency;
  double? cashValueEarned;
  double? cashValueRedeemed;
  String? customerId;
  DateTime? createdAt;
  int? v;

  TransectionResponse({
    this.id,
    this.subscriptionId,
    this.subscriberId,
    this.type,
    this.rewardPointsEarned,
    this.rewardPointsRedeemed,
    this.currency,
    this.cashValueEarned,
    this.cashValueRedeemed,
    this.customerId,
    this.createdAt,
    this.v,
  });

  factory TransectionResponse.fromJson(Map<String, dynamic> json) => TransectionResponse(
        id: json["_id"],
        subscriptionId: json["subscriptionId"],
        subscriberId: json["subscriberId"],
        type: json["type"],
        rewardPointsEarned: json["rewardPointsEarned"] ?? 0,
        rewardPointsRedeemed: json["rewardPointsRedeemed"] ?? 0,
        currency: json["currency"] ?? "USD",
        cashValueEarned: json["cashValueEarned"] != null ? json["cashValueEarned"].toDouble() : 0.0,
        cashValueRedeemed: json["cashValueRedeemed"] != null ? json["cashValueRedeemed"].toDouble() : 0.0,
        customerId: json["customerId"],
        createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now()),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subscriptionId": subscriptionId,
        "subscriberId": subscriberId,
        "type": type,
        "rewardPointsEarned": rewardPointsEarned,
        "rewardPointsRedeemed": rewardPointsRedeemed,
        "currency": currency,
        "cashValueEarned": cashValueEarned,
        "cashValueRedeemed": cashValueRedeemed,
        "customerId": customerId,
        "createdAt": createdAt!.toIso8601String(),
        "__v": v,
      };
}
