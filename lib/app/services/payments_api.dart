import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import 'basic_api.dart';

class PaymentsAPI {
  static Future<http.Response> launchStripeURL(String productId, String? points, String coupon) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions/checkout/$productId");
    StringUtils.debugPrintMode(url.toString());

    var response;
    var param;
    if (points != "" && coupon != "") {
      param = {"redeemPoints": points, "coupon": coupon};
    } else if (points != "") {
      param = {"redeemPoints": points};
    } else if (coupon != "") {
      param = {"coupon": coupon};
    }

    StringUtils.debugPrintMode(param);

    if (points != "" || coupon != "") {
      response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
          },
          body: jsonEncode(param));
    } else {
      response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
        },
      );
    }

    if (response.statusCode != 200) {
      StringUtils.debugPrintMode(response.body);
    }
    return response;
  }

  static Future<http.Response> confirmTransaction(String id, PlanModel plan) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions");
    StringUtils.debugPrintMode(url.toString());
    var body = {
      "stripeProductId": plan.stripeProductId,
      "country": plan.country,
      "transactionId": id,
    };
    StringUtils.debugPrintMode(body.toString());
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer ${CurrentUser().currentUser.token.toString()}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> fetchICCID() async {
    var url = Uri.parse("${BasicAPI.baseURL}activation/iccid");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    }).timeout(const Duration(seconds: 8), onTimeout: () {
      return http.Response('Something went wrong', 400);
    });
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> fetchActivationCode(String iccid) async {
    var url = Uri.parse("${BasicAPI.baseURL}activation/activation-code/$iccid");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    }).timeout(const Duration(seconds: 8), onTimeout: () {
      return http.Response('Something went wrong', 400);
    });
    StringUtils.debugPrintMode(response.body);
    return response;
  }
}
