import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/services/user/current_user.dart';

import '../models/rewardpoints_response.dart';
import '../models/transection_response.dart';
import '../utils/string_utils.dart';
import 'basic_api.dart';

class LoyaltyPointsAPI {
  static Future<RewardResponse> getRewardPoint() async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriber/rewardPoints");
    StringUtils.debugPrintMode(url);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    if (response.statusCode == 200) {
      StringUtils.debugPrintMode(response.body);
      RewardResponse rewardResponse = RewardResponse.fromJson(jsonDecode(response.body));
      return rewardResponse;
    } else {
      return RewardResponse();
    }
  }

  static Future<List<TransectionResponse>> getRewardPointTransection() async {
    var url = Uri.parse("${BasicAPI.baseURL}loyalty-transactions");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    if (response.statusCode == 200) {
      StringUtils.debugPrintMode(response.body);
      List<TransectionResponse> transectionRes = transectionResponseFromJson(response.body);
      return transectionRes;
    } else {
      return <TransectionResponse>[];
    }
  }

  static Future<http.Response> applyRedeem_and_Coupon(
      String stripeProductId, String redeemPoints, String couponCode, bool isRedeemApply, bool isCouponApply) async {
    var url = Uri.parse("${BasicAPI.baseURL}redeem-points-coupon/$stripeProductId");
    var points = 0;
    if (redeemPoints != "") {
      points = int.parse(redeemPoints);
    }
    var params = {
      "redeemPoints": points,
      "rewardPointsApplied": isRedeemApply,
      "coupon": couponCode,
      "couponCodeApplied": isCouponApply
    };
    StringUtils.debugPrintMode(url);
    StringUtils.debugPrintMode(jsonEncode(params));
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
          },
          body: jsonEncode(params));
      StringUtils.debugPrintMode(jsonDecode(response.body));
      return response;
    } on SocketException {
      var errorBody = {"message": "socket exception"};
      return http.Response(jsonEncode(errorBody), 400);
    }
  }
}
