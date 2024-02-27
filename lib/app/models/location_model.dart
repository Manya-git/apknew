import 'dart:convert';

List<LocationModel> locationModelFromJson(String str, bool fromDestination) => List<LocationModel>.from(json.decode(str).map((x) => LocationModel.fromJson(x, fromDestination)));

class LocationModel {

  LocationModel({this.name, this.logo, this.isPopular, this.dialCode, this.fromDestination, this.code});

  String? name;
  String? logo;
  bool? isPopular;
  String? dialCode;
  bool? fromDestination;
  String? code;

  factory LocationModel.fromJson(Map<String, dynamic> json, bool fromDestination) => LocationModel(
        name: json["name"] ?? json["zone"],
        logo: json["flag"] ?? json["logo"],
        dialCode: json["dial_code"] ?? "",
        isPopular: json["isPopular"] ?? true,
        code: json["code"],
        fromDestination: fromDestination);

  Map<String, dynamic> toJson() => {
    "name": name,
    "dial_code": dialCode,
    "logo": logo!,
    "isPopular": isPopular,
    "shortcode" : code
  };

}
