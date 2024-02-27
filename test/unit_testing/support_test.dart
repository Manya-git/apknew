import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ride_mobile/app/services/support_api.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  const String email = "trupti@gmail.com";
  const String name = "Trupti Maharana";
  const String message = "demo message";

  bool _validateEmail() {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  Future<Response> _sendSupportMessage() async {
    var response = await SupportAPI.sendContactUsRequest(email, name, message);
    return response;
  }

  test("check if email is valid", () {
    bool isValid = _validateEmail();
    expect(true, isValid);
  });
  test("check if support message sent to server", () async {
    expect(false, email.isEmpty);
    expect(false, name.isEmpty);
    expect(false, message.isEmpty);
    var response = await _sendSupportMessage();
    response.statusCode == 200
        ? debugPrint("Support message sent successfully")
        : debugPrint("Could'nt send support message due to${StringUtils.getResponseMessage(response.body)}");
    expect(200, response.statusCode);
  });
}
