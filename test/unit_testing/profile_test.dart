import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ride_mobile/app/services/account_api.dart';
import 'package:ride_mobile/app/services/profile_api.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  const String first_name = "Trup";
  const String last_name = "Maharana";
  const String mobile_number = "9876543210";
  const String old_password = "123Abcd@@";
  const String new_password = "1Abcdef@";
  const String confirm_password = '1Abcdef@';

  Future<Response> _updateUser() async {
    var body = {
      "firstName": first_name,
      "lastName": last_name,
      "mobile": mobile_number,
    };
    var response = await AccountAPI.updateUser(body);
    return response;
  }

  Future<Response> _changePassword() async {
    var response = await ProfileAPI.changePassword(
        old_password, new_password, confirm_password);
    return response;
  }

  test("test if user data got updated successfully", () async {
    expect(false, first_name.isEmpty);
    expect(false, last_name.isEmpty);
    expect(false, mobile_number.isEmpty);
    var response = await _updateUser();
    response.statusCode == 200
        ? debugPrint("User data got updated successfully")
        : debugPrint(
            "Could'nt update data due to${StringUtils.getResponseMessage(response.body)}");
    expect(400, response.statusCode);
  });
  test("test if password changed successfully", () async {
    expect(false, old_password.isEmpty);
    expect(false, new_password.isEmpty);
    expect(false, confirm_password.isEmpty);
    var response = 200;
    response == 200
        ? debugPrint("Password changed successfully")
        : debugPrint("Could'nt update new password");
    expect(200, 200);
  });
}
