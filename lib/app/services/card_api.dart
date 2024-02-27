import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/saved_card_model.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';

import '../utils/string_utils.dart';
import 'basic_api.dart';

class CardAPI {
  static Future<http.Response> addCard(var body) async {
    var url = Uri.parse("${BasicAPI.baseURL}add-card");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
        },
        body: body);
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      AccountController controller = Get.put(AccountController());
      controller.getDefaultCard();
    }
    return response;
  }

  // update card
  static Future<http.Response> updateCard(var body) async {
    var url = Uri.parse("${BasicAPI.baseURL}update-card");
    StringUtils.debugPrintMode(url.toString());
    // print body...
    StringUtils.debugPrintMode(jsonEncode(body));
    final response = await http.put(url,
        headers: {
          'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
        },
        body: body);
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  // fetch all cards
  static Future<List<CardModel>> fetchSavedCards(int limit) async {
    var url = Uri.parse("${BasicAPI.baseURL}get-stripe-resources/${CurrentUser().currentUser.customerId!}/card/$limit");
    StringUtils.debugPrintMode(url);
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    try {
      if (response.statusCode == 200) {
        List<CardModel> savedCards = savedCardModelFromJson(response.body);
        return savedCards;
      } else {
        StringUtils.debugPrintMode(response.body);
        return <CardModel>[];
      }
    } catch (e) {
      StringUtils.debugPrintMode(e);
      return <CardModel>[];
    }
  }

  // delete card
  static Future<http.Response> deleteCard(var body) async {
    var url = Uri.parse("${BasicAPI.baseURL}remove-card");
    StringUtils.debugPrintMode(url);
    var response = await http.put(url, body: body, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  // make card default
  static Future<http.Response> makeCardDefault(var body) async {
    var url = Uri.parse("${BasicAPI.baseURL}update-default-card");
    StringUtils.debugPrintMode(url);
    var response = await http.put(url, body: body, headers: {
      'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
    });
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      AccountController controller = Get.put(AccountController());
      controller.getDefaultCard();
    }
    return response;
  }
}
