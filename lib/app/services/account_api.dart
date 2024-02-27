import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/config_response.dart';
import '../models/data_usage_model.dart';
import 'basic_api.dart';

class AccountAPI {
  static Future<ConfigResponse> fetchAppConfig(String cacheID) async {
    var url =
        Uri.parse("${BasicAPI.baseURL}customers/setting/configuration?customerId=${Assets.GB_ID}&cacheId=${cacheID}");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url);
    StringUtils.debugPrintMode(response.body.toString());
    if (response.statusCode == 200) {
      ConfigResponse configResponse = ConfigResponse.fromJson(jsonDecode(response.body));
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> json = jsonDecode(response.body);
      String user = jsonEncode(ConfigResponse.fromJson(json));
      pref.setString('userData', user);
      CurrentUser().configResponse = configResponse;
      return configResponse;
    } else {
      StringUtils.debugPrintMode(response.body.toString() + "\ndata usage error");
      return ConfigResponse();
    }
  }

  // static Future<http.Response> activatePlan(PlanModel plan) async {
  //   var url = Uri.parse("${BasicAPI.baseURL}subscriptions/${plan.id!}/subscribe");
  //   StringUtils.debugPrintMode(url.toString());
  //   var body = {
  //     "planId": plan.productId!,
  //   };
  //   // print body...
  //   StringUtils.debugPrintMode(body.toString());
  //   final response = await http.post(url,
  //       headers: {'Authorization': 'Bearer ${CurrentUser().currentUser.token}', 'Content-type': 'application/json'},
  //       body: jsonEncode(body));
  //   StringUtils.debugPrintMode(response.body);
  //   return response;
  // }

  static Future<http.Response> activatePlan(String iccid, String transactionId, PlanModel plan, bool upcoming) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions/${plan.id!}/subscribe");
    StringUtils.debugPrintMode(url.toString());

    var body = {
      "planId": plan.productId!,
      "upcoming": upcoming,
      "country": plan.country!,
      "transactionId": transactionId
    };

    StringUtils.debugPrintMode(body.toString());
    final response = await http.post(url,
        headers: {'Authorization': 'Bearer ${CurrentUser().currentUser.token}', 'Content-type': 'application/json'},
        body: jsonEncode(body));
    StringUtils.debugPrintMode("activate plan response:");
    StringUtils.debugPrintMode(response.body);

    return response;
  }

  static Future<DataUsageModel> fetchDataUsage(String iccid, String subscriptionId) async {
    var url = Uri.parse("${BasicAPI.baseURL}activation/data-usage/$subscriptionId");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Something went wrong', 400);
    });
    StringUtils.debugPrintMode(response.body.toString());
    if (response.statusCode == 200) {
      DataUsageModel dataUsage = DataUsageModel.fromJson(jsonDecode(response.body));
      return dataUsage;
    } else {
      StringUtils.debugPrintMode(response.body.toString() + "\ndata usage error");
      return DataUsageModel(
        totalData: 0,
        usedData: 0,
        endDate: null,
      );
    }
  }

  static Future<List<DataUsageModelAll>> fetchDataUsageAll(String iccid) async {
    var url = Uri.parse("${BasicAPI.baseURL}activation/active-data-usage");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Something went wrong', 400);
    });
    StringUtils.debugPrintMode(response.body.toString());
    if (response.statusCode == 200) {
      List<DataUsageModelAll> dataUsageData = dataUsageModelAllFromJson(response.body);
      return dataUsageData;
    } else {
      StringUtils.debugPrintMode(response.body.toString() + "\ndata usage error");
      return [];
    }
  }

  static Future<http.Response> updateUser(var body) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers");
    StringUtils.debugPrintMode(url.toString());
    // print body...
    StringUtils.debugPrintMode(body.toString());
    final response = await http.put(url,
        headers: {
          'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
        },
        body: body);
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> fetchESimStatus() async {
    var url = Uri.parse("${BasicAPI.baseURL}activation/esim-status");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Something went wrong', 400);
    });
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<List<PlanModel>> fetchUpcomingPlans() async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions?status=upcoming");
    StringUtils.debugPrintMode(url.toString());
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // if body is not null...
      List<PlanModel> plans = productModelFromJson(response.body);
      return plans;
    } else {
      return <PlanModel>[];
    }
  }

  static Future<List<PlanModel>> fetchActivePlans() async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions?status=active");
    StringUtils.debugPrintMode(url.toString());
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // if body is not null...
      List<PlanModel> plans = productModelFromJson(response.body);
      return plans;
    } else {
      return <PlanModel>[];
    }
  }

  static Future<List<PlanModel>> fetchExpiredPlans() async {
    var url = Uri.parse("${BasicAPI.baseURL}subscriptions?status=refunded,expired");
    StringUtils.debugPrintMode(url.toString());
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<PlanModel> plans = productModelFromJson(response.body);
      return plans;
    } else {
      return <PlanModel>[];
    }
  }

  static Future<List<PlanModel>> fetchTrendingPlans() async {
    var url = Uri.parse("${BasicAPI.baseURL}trending?isCountry=true");
    StringUtils.debugPrintMode(url.toString());
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<PlanModel> plans = productModelFromJson(response.body);
      return plans;
    } else {
      return <PlanModel>[];
    }
  }
}
