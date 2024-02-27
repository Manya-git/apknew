import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<CardModel> savedCardModelFromJson(String str) =>
    List<CardModel>.from(json.decode(str).map((x) => CardModel.fromJson(x)));

class CardModel {
  CardModel(
      {this.id,
      this.object,
      this.billingDetails,
      this.card,
      this.created,
      this.customer,
      this.liveMode,
      this.metadata,
      this.type,
      this.isDefault,
      this.isUpdating});

  String? id;
  String? object;
  BillingDetails? billingDetails;
  Card? card;
  int? created;
  String? customer;
  bool? liveMode;
  Metadata? metadata;
  String? type;
  RxBool? isUpdating;
  RxBool? isDefault;

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json["id"],
        object: json["object"],
        billingDetails: BillingDetails.fromJson(json["billing_details"]),
        card: Card.fromJson(json["card"]),
        created: json["created"],
        customer: json["customer"],
        liveMode: json["livemode"],
        metadata: Metadata.fromJson(json["metadata"]),
        type: json["type"],
        isDefault: RxBool(json["default_source"] ?? false),
        isUpdating: false.obs,
      );
}

class BillingDetails {
  BillingDetails({
    this.address,
    this.email,
    this.name,
    this.phone,
  });

  Address? address;
  String? email;
  String? name;
  dynamic phone;

  factory BillingDetails.fromJson(Map<String, dynamic> json) => BillingDetails(
        address: Address.fromJson(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );
}

class Address {
  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  dynamic city;
  String? country;
  dynamic line1;
  dynamic line2;
  dynamic postalCode;
  dynamic state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class Card {
  Card({
    this.brand,
    this.checks,
    this.country,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.generatedFrom,
    this.last4,
    this.networks,
    this.threeDSecureUsage,
    this.wallet,
  });

  String? brand;
  Checks? checks;
  String? country;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  dynamic? generatedFrom;
  String? last4;
  Networks? networks;
  ThreeDSecureUsage? threeDSecureUsage;
  dynamic wallet;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        brand: toBeginningOfSentenceCase(json["brand"]),
        checks: Checks.fromJson(json["checks"]),
        country: json["country"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        generatedFrom: json["generated_from"],
        last4: "**** **** **** " + json["last4"],
        networks: Networks.fromJson(json["networks"]),
        threeDSecureUsage: ThreeDSecureUsage.fromJson(json["three_d_secure_usage"]),
        wallet: json["wallet"],
      );
}

class Checks {
  Checks({
    this.addressLine1Check,
    this.addressPostalCodeCheck,
    this.cvcCheck,
  });

  dynamic addressLine1Check;
  dynamic addressPostalCodeCheck;
  String? cvcCheck;

  factory Checks.fromJson(Map<String, dynamic> json) => Checks(
        addressLine1Check: json["address_line1_check"],
        addressPostalCodeCheck: json["address_postal_code_check"],
        cvcCheck: json["cvc_check"],
      );

  Map<String, dynamic> toJson() => {
        "address_line1_check": addressLine1Check,
        "address_postal_code_check": addressPostalCodeCheck,
        "cvc_check": cvcCheck,
      };
}

class Networks {
  Networks({
    this.available,
    this.preferred,
  });

  List<String>? available;
  dynamic preferred;

  factory Networks.fromJson(Map<String, dynamic> json) => Networks(
        available: List<String>.from(json["available"].map((x) => x)),
        preferred: json["preferred"],
      );
}

class ThreeDSecureUsage {
  ThreeDSecureUsage({
    this.supported,
  });

  bool? supported;

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) => ThreeDSecureUsage(
        supported: json["supported"],
      );

  Map<String, dynamic> toJson() => {
        "supported": supported,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
