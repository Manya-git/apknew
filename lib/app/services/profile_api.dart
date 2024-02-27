import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/services/user/current_user.dart';

import '../utils/string_utils.dart';
import 'basic_api.dart';

class ProfileAPI {
  static Future<http.Response> changePassword(String currentPassword, String newPassword, String verifyPassword) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/changePassword");
    StringUtils.debugPrintMode(url.toString());
    var body = {"currentPassword": currentPassword, "newPassword": newPassword, "verifyPassword": verifyPassword};
    final response = await http.put(url,
        headers: {
          'Authorization': 'Bearer ${CurrentUser().currentUser.token}',
        },
        body: body);
    StringUtils.debugPrintMode(response.body);
    return response;
  }
}
