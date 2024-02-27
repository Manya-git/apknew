import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_mobile/app/services/auth_api.dart';

void main() {
  const String email = "trupti@gmail.com";
  const String verification_code = "123456";

  void verifyEmail() async {
    var response = await AuthAPI.verifyCode(verification_code, email);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["tokenResponse"];
      var token = res['token'];
      await AuthAPI.fetchUserInfo(token);
    }
  }
}
