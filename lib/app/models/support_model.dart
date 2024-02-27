import 'dart:convert';

SupportResponse supportResponseFromJson(String str) => SupportResponse.fromJson(json.decode(str));

String supportResponseToJson(SupportResponse data) => json.encode(data.toJson());

class SupportResponse {
  SupportResponse({
    required this.support,
    required this.message,
  });

  Support support;
  String message;

  factory SupportResponse.fromJson(Map<String, dynamic> json) => SupportResponse(
    support: Support.fromJson(json["support"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "support": support.toJson(),
    "message": message,
  };
}

class Support {
  Support({
    required this.message,
    required this.email,
    required this.number,
    required this.deviceInfo,
    required this.name,
    required this.ticket,
    required this.subscriberId,
    required this.id,
    required this.created,
    required this.v,
  });

  String message;
  String email;
  int number;
  String deviceInfo;
  String name;
  String ticket;
  String subscriberId;
  String id;
  DateTime created;
  int v;

  factory Support.fromJson(Map<String, dynamic> json) => Support(
    message: json["message"],
    email: json["email"],
    number: json["number"],
    deviceInfo: json["deviceInfo"],
    name: json["name"],
    ticket: json["ticket"],
    subscriberId: json["subscriberId"],
    id: json["_id"],
    created: DateTime.parse(json["created"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "email": email,
    "number": number,
    "deviceInfo": deviceInfo,
    "name": name,
    "ticket": ticket,
    "subscriberId": subscriberId,
    "_id": id,
    "created": created.toIso8601String(),
    "__v": v,
  };
}
