import 'dart:convert';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/data_usage_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import '../services/user/current_user.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str), CurrentUser().currentUser.token!);

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.timezone,
      this.mobile,
      this.email,
      this.displayName,
      this.profileImageUrl,
      this.roles,
      this.lock,
      this.subscriptionId,
      this.customerId,
      this.isActive,
      this.productId,
      this.plan,
      this.iccid,
      this.activationCode,
      this.isPlanActivated,
      this.dataUsage,
      this.isFirstTimeBuyer,
      this.activeProducts,
      this.countryCode,
      this.isFirstTimeActivator,
      this.token});

  String? id;
  String? firstName;
  String? lastName;
  String? timezone;
  String? countryCode;
  String? mobile;
  String? email;
  String? displayName;
  String? profileImageUrl;
  List<String>? roles;
  bool? lock;
  String? subscriptionId;
  String? customerId;
  String? token;
  String? productId;
  RxBool? isActive;
  PlanModel? plan;
  List<PlanModel>? activeProducts;
  DataUsageModel? dataUsage;
  String? iccid;
  RxString? activationCode;
  bool? isFirstTimeBuyer;
  bool? isPlanActivated;
  bool? isFirstTimeActivator;

  factory UserModel.fromJson(Map<String, dynamic> json, String token) => UserModel(
      id: json["_id"],
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"],
      timezone: json["timezone"],
      mobile: json["mobile"],
      countryCode: json["countryCode"] ?? "",
      email: json["email"],
      displayName: json["displayName"],
      profileImageUrl: json["profileImageURL"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      lock: json["lock"],
      dataUsage: DataUsageModel(
        totalData: 0,
        usedData: 0,
        endDate: DateTime.now().millisecondsSinceEpoch,
        // endDate: DateTime.now().add(const Duration(days: 1)),
      ),
      subscriptionId: json["subscriptionId"] ?? "",
      activeProducts: json["activeProduct"] == [] || json["activeProduct"] == null ? [] : List<PlanModel>.from(json["activeProduct"].map((x) => PlanModel.fromJson(x, token))),
      customerId: json["customerId"],
      productId: json["productId"] ?? "",
      isActive: false.obs,
      iccid: json["iccid"] ?? "",
      activationCode: RxString(json["activationCode"] ?? ""),
      isPlanActivated: json["isPlanActivated"] ?? false,
      isFirstTimeBuyer: json["isFirstTimeBuyer"] ?? true,
      isFirstTimeActivator: json["isFirstTimeActivator"] ?? true,
      token: token);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "timezone": timezone,
        "mobile": mobile,
        "email": email,
        "displayName": displayName,
        "profileImageURL": profileImageUrl,
        "roles": List<dynamic>.from(roles!.map((x) => x)),
        "lock": lock,
        "subscriptionId": subscriptionId,
        "customerId": customerId,
      };
}
