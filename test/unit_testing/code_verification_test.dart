import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

main() {
  String receivedCode = "";
  const String enteredCode = "365897";

  void sendCode() {
    // either the correct code will be returned or the incorrect code will be returned
    List<String> code = ["365897", "556866"];
    receivedCode = code[Random().nextInt(code.length)];
  }

  setUpAll(() => sendCode());

  bool _doesVerificationCodeMatch() {
    bool isValid = receivedCode == enteredCode;
    return isValid;
  }

  bool _isSixDigits() {
    bool isValid = enteredCode.length == 6;
    return isValid;
  }

  test("check if entered code is of 6 digits", () {
    bool isValid = _isSixDigits();
    expect(true, isValid);
  });

  // check if entered code matches received code
  test("check if entered code matches received code without resending", () {
    bool isValid = _doesVerificationCodeMatch();
    expect(true, isValid);
  });

  // resend code and check if entered code matches received code
  test("resend code and check if entered code matches received code", () {
    sendCode();
    bool isValid = _doesVerificationCodeMatch();
    expect(true, isValid);
  });

  // test("submit verification code and check if password was reset successfully", () {
  //   expect(false, receivedCode.isEmpty);
  //   expect(false, enteredCode.isEmpty);
  //   bool isValid = _doesVerificationCodeMatch();
  //   isValid ? debugPrint("Code verification successful") : debugPrint("Invalid code");
  //   expect(true, isValid);
  // });
}
