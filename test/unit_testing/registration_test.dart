import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

main() {
  const String firstName = "Ali";
  const String lastName = "Memon";
  const String email = "ali262883@gmail.com";
  const String mobileNumber = "+919988998899";
  const String password = "Mahi@1234567";
  const String repeatPassword = "Mahi@1234567";

  Future<Response> validateRegistration() async {
    var params = {"firstName": firstName, "lastName": lastName, "email": email, "password": password, "mobile": mobileNumber};
    var response = await AuthAPI.registerUser(params);
    return response;
  }

  //check if firstName, lastName, email, mobileNumber, password, repeatPassword are not empty
  test("check if firstName, email, mobileNumber, password, repeatPassword are not empty", () {
    expect(false, firstName.isEmpty);
    expect(false, email.isEmpty);
    expect(false, mobileNumber.isEmpty);
    expect(false, password.isEmpty);
    expect(false, repeatPassword.isEmpty);
  });

  // check if password and repeatPassword are equal
  test("check if password and repeatPassword are equal", () {
    expect(password, repeatPassword);
  });

  test("check if email is valid", () {
    bool isValid = EmailValidator.validate(email);
    expect(true, isValid);
  });

  //check if password contains at least 8 digits
  test("check if password is contains at least 8 digits", () {
    int digits = password.length;
    bool isValid = digits >= 8;
    expect(true, isValid);
  });

  // //check if password contains one uppercase letter, one lowercase letter and one number and one special character (e.g. !@#$%^&*)
  // test("check if password contains one uppercase letter, one lowercase letter and one number and one special character", () {
  //   bool isValid = password.contains(RegExp(r'[A-Z]'));
  //   expect(true, isValid);
  //   isValid = password.contains(RegExp(r'[a-z]'));
  //   expect(true, isValid);
  //   isValid = password.contains(RegExp(r'[0-9]'));
  //   expect(true, isValid);
  //   isValid = password.contains(RegExp(r'[!@#$%^&*]'));
  //   expect(true, isValid);
  // });



  test("check if user is able to sign-up from the Registration API", () async {
    var response = await validateRegistration();
    response.statusCode == 200
        ? debugPrint("Registration successful")
        : debugPrint("Registration failed due to ${StringUtils.getResponseMessage(response.body)}");
    expect(200, response.statusCode);
  });
}
