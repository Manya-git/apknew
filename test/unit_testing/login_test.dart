import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

@GenerateMocks([MockitoExample])
void main() {
  //setupFirebaseAuthMocks();

  const String email = "mark@mailinator.com";
  const String password = "Demo@12345";

  const String url = "https://dummy.restapiexample.com/api/v1/create";

  // setUp all
  setUp(() async {
    //HttpOverrides.global = null;
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
  });

  //check if email is valid
  bool _isEmailValid() {
    bool isValid = EmailValidator.validate(email) && email.isNotEmpty;
    return isValid;
  }

  // check if password is greater than or equal to 8 characters
  bool _isPasswordValid() {
    int digits = password.length;
    bool isValid = digits >= 8 && password.isNotEmpty;
    return isValid;
  }

  // test to check if email is valid
  test('Email is valid', () {
    expect(_isEmailValid(), true);
  });

  // test to check if password is valid
  test('Password is valid', () {
    expect(_isPasswordValid(), true);
  });

  Future loginApiCall(http.Client client) async {
    // create body of email and password
    final body = {
      "email": email,
      "password": password,
    };
    final response = await client.post(Uri.parse(url), body: body);
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // test login with MockitoExample class
  test('Login with MockitoExample', () async {
    http.Client mockitoExample = MockitoExample();
    StringUtils.debugPrintMode(Uri.parse(url).toString());
    when(mockitoExample.post(Uri.parse(url), body: {
      "email": email,
      "password": password,
    })).thenAnswer((_) async => Response('{"token": "123"}', 200));
    final body = {
      "email": email,
      "password": password,
    };
    when(mockitoExample.post(Uri.parse(url), body: body))
        .thenAnswer((_) async => http.Response(json.encode({"status": "success"}), 200));
    // expect the response to be successful

    // expect the status code to be 200
    expect(await loginApiCall(mockitoExample), {"status": "success"});
  });
}

class MockitoExample extends Mock implements http.Client {}
