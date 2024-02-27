import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/currency_model.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import 'basic_api.dart';

class CurrencyAPI {
  // get default currency and currency list
  static Future<CurrencyModel> fetchCurrency(String token) async {
    var url = Uri.parse(
        "${BasicAPI.baseURL}subscribers/settings/currency?customerId=${CurrentUser().currentUser.customerId!}&email=${CurrentUser().currentUser.email!}");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(
      url,
    );
    StringUtils.debugPrintMode(response.body.toString());
    if (response.statusCode == 200) {
      CurrencyModel currencyList = CurrencyModel.fromJson(jsonDecode(response.body));
      StringUtils.debugPrintMode("[ " + jsonDecode(response.body).toString());
      return currencyList;
    } else {
      StringUtils.debugPrintMode(response.body.toString() + "\ncurrency list error");
      return CurrencyModel();
    }
  }

  static Future<http.Response> updateCurrency(var body) async {
    var token = CurrentUser().currentUser.token;
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/settings/currency");
    StringUtils.debugPrintMode(url);
    final response = await http.put(url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: body);
    StringUtils.debugPrintMode(response.body);
    return response;
  }
}
