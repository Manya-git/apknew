import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/assets.dart';

import '../utils/string_utils.dart';
import 'basic_api.dart';

class SupportAPI {
  static Future<http.Response> sendContactUsRequest(String email, String name, String message) async {
    var url = Uri.parse("${BasicAPI.baseURL}support-request");
    StringUtils.debugPrintMode(url.toString());
    var body = {"email": email, "name": name, "message": message, "customerId": Assets.GB_ID};
    StringUtils.debugPrintMode(body.toString());
    final response =
        await http.post(url, headers: {'Authorization': 'Bearer ${CurrentUser().currentUser.token}'}, body: body);
    StringUtils.debugPrintMode(response.body.toString());
    return response;
  }

  static Future<http.Response> sendSupportForm(
      String email, String name, String message, String number, String deviceInfo, String code) async {
    var url = Uri.parse("${BasicAPI.baseURL}create-request");
    StringUtils.debugPrintMode(url.toString());
    var body = {
      "email": email,
      "name": name,
      "message": message,
      "deviceInfo": deviceInfo,
      "number": number,
      "countryCode": code
    };
    StringUtils.debugPrintMode(body.toString());
    final response =
        await http.post(url, headers: {'Authorization': 'Bearer ${CurrentUser().currentUser.token}'}, body: body);
    StringUtils.debugPrintMode(response.body.toString());
    return response;
  }
}
