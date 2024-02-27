import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) => CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  Currency? defaultCurrency;
  List<CurrencyList>? currencyList;
  Currency? subscriberCurrency;

  CurrencyModel({
    this.defaultCurrency,
    this.currencyList,
    this.subscriberCurrency,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        defaultCurrency: json["defaultCurrency"] == null ? null : Currency.fromJson(json["defaultCurrency"]),
        currencyList: json["currencyList"] == null
            ? []
            : List<CurrencyList>.from(json["currencyList"]!.map((x) => CurrencyList.fromJson(x))),
        subscriberCurrency: json["subscriberCurrency"] == null ? null : Currency.fromJson(json["subscriberCurrency"]),
      );

  Map<String, dynamic> toJson() => {
        "defaultCurrency": defaultCurrency?.toJson(),
        "currencyList": currencyList == null ? [] : List<dynamic>.from(currencyList!.map((x) => x.toJson())),
        "subscriberCurrency": subscriberCurrency?.toJson(),
      };
}

class CurrencyList {
  String? currency;
  String? currencyName;
  String? id;

  CurrencyList({
    this.currency,
    this.currencyName,
    this.id,
  });

  factory CurrencyList.fromJson(Map<String, dynamic> json) => CurrencyList(
        currency: json["currency"],
        currencyName: json["currency_name"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "currency_name": currencyName,
        "_id": id,
      };
}

class Currency {
  String? currency;
  String? currencyName;

  Currency({
    this.currency,
    this.currencyName,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        currency: json["currency"],
        currencyName: json["currency_name"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "currency_name": currencyName,
      };
}
