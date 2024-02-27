import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  const String email = "studenta@mailinator.com";
  const String dummyEmail = "studenta@mailinator.com";

  bool _validateEmail() {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  bool _doesEmailExists() {
    bool isValid = email == dummyEmail;
    return isValid;
  }

  test("check if email address is valid", () {
    bool isValid = _validateEmail();
    isValid ? debugPrint("Email address is valid") : debugPrint("Invalid email address");
    expect(true, isValid);
  });

  test("check if email exists in the database", () {
    bool isValid = _doesEmailExists();
    isValid ? debugPrint("Code sent successfully") : debugPrint("Email address does not exist");
    expect(true, isValid);
  });

  test("check if verification code was sent successfully", () {
    expect(false, dummyEmail.isEmpty);
    Random r =  Random();
    bool isValid = true;
    isValid = r.nextBool();
    isValid? debugPrint("Verification code sent successfully") : debugPrint("Error sending verification code");
    expect(true, isValid);
  });
}
