import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

main() {
  const String newPassword = "abc@1234";
  String confirmPassword = "";

  bool _arePasswordsSame() {
    bool isValid = newPassword == confirmPassword;
    return isValid;
  }

  void setConfirmedPassword() {
    // either the correct password will be returned or the incorrect password will be returned
    List<String> code = ["abc@1234", "xyz@1234"];
    confirmPassword = code[Random().nextInt(code.length)];
  }

  setUpAll(() => setConfirmedPassword());

  test("check if new password and confirm password are not empty", () {
    expect(false, newPassword.isEmpty);
    expect(false, confirmPassword.isEmpty);
  });

  test("check if new password and confirm password are the same", () {
    expect(true, _arePasswordsSame());
  });

  // check if new password and confirm password contain at least 8 characters
  test("check if new password and confirm password contain at least 8 characters", () {
    expect(true, newPassword.length >= 8);
    expect(true, confirmPassword.length >= 8);
  });

  test("check if password reset was successful", () {
    expect(false, newPassword.isEmpty);
    expect(false, confirmPassword.isEmpty);
    expect(true, _arePasswordsSame());
  });
}
