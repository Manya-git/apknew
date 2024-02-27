import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ride_mobile/app/models/location_model.dart';
import 'package:ride_mobile/app/services/basic_api.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/services/user/local%20preferences.dart';
import 'package:ride_mobile/app/utils/assets.dart';

import '../models/user_model.dart';
import '../utils/string_utils.dart';

class AuthAPI {
  static Future<http.Response> registerUser(Map<String, dynamic> params) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/signup");
    var errorBody = {"message": "socket exception"};
    StringUtils.debugPrintMode(url);
    StringUtils.debugPrintMode(params);
    try {
      final response = await http.post(url, body: params);
      StringUtils.debugPrintMode(response.body);
      return response;
    } on SocketException {
      return http.Response(jsonEncode(errorBody), 400);
    }
  }

  static Future<http.Response> loginUser(String email, String password) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/signin");
    var body = {"email": email.toLowerCase(), "password": password, "customerId": Assets.GB_ID};
    StringUtils.debugPrintMode(url);
    StringUtils.debugPrintMode(body);
    var errorBody = {"message": "Socket Exception"};
    try {
      final response = await http.post(url, body: body);
      StringUtils.debugPrintMode(response.body.toString());
      if (response.statusCode == 200) {
        var token = jsonDecode(response.body)['token'];
        await fetchUserInfo(token);
        await LocalPreferences.setUserEmail(email);
        await LocalPreferences.setUserPassword(password);
      }
      return response;
    } on Exception {
      return http.Response(jsonEncode(errorBody), 400);
    }
  }

  static Future<UserModel> fetchUserInfo(String token) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/me");
    StringUtils.debugPrintMode(url);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      StringUtils.debugPrintMode(response.body);
      UserModel user = UserModel.fromJson(jsonDecode(response.body), token);
      CurrentUser().currentUser = user;
      CurrentUser().currentUser.token = token;
      return user;
    } else {
      return UserModel();
    }
  }

  static Future<List<LocationModel>> fetchCountryCodes() async {
    var url = Uri.parse("${BasicAPI.baseURL}countries?customerId=${Assets.GB_ID}");
    StringUtils.debugPrintMode(url);
    var response = await http.get(url);
    StringUtils.debugPrintMode(response.body);
    if (response.statusCode == 200) {
      List<LocationModel> codes = locationModelFromJson(response.body, true);
      return codes;
    } else {
      return <LocationModel>[];
    }
  }

  static Future<http.Response> verifyCode(String code, String email) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/verify/$code/$email");
    StringUtils.debugPrintMode(url.toString());
    final response = await http.get(url);
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> resendVerificationCode(String email) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/resendOTP");
    StringUtils.debugPrintMode(url);
    var body = {"email": email, "customerId": Assets.GB_ID};
    StringUtils.debugPrintMode(body);
    final response = await http.post(url, body: body);
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> forgotPassword(String email) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/forgot");
    StringUtils.debugPrintMode(url);
    var body = {"email": email, "customerId": Assets.GB_ID};
    var errorBody = {"message": "Socket Exception"};
    StringUtils.debugPrintMode(body);
    try {
      final response = await http.post(url, body: body);
      StringUtils.debugPrintMode(response.body);
      return response;
    } on SocketException {
      return http.Response(jsonEncode(errorBody), 400);
    } on FormatException {
      return http.Response("Something went wrong", 400);
    }
  }

  static Future<http.Response> verifyCodeToResetPassword(String code, String email) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/reset/$code/$email");
    StringUtils.debugPrintMode(url);
    final response = await http.get(url);
    StringUtils.debugPrintMode(response.body);
    return response;
  }

  static Future<http.Response> resetPassword(String code, String newPassword, String confirmedPassword) async {
    var url = Uri.parse("${BasicAPI.baseURL}subscribers/reset");
    StringUtils.debugPrintMode(url.toString());
    var body = {"otp": code, "newPassword": newPassword, "oldPassword": confirmedPassword};
    var errorBody = {"message": "Socket Exception"};
    StringUtils.debugPrintMode(body);
    try {
      final response = await http.post(url, body: body);
      StringUtils.debugPrintMode(response.body);
      return response;
    } on SocketException {
      return http.Response(jsonEncode(errorBody), 400);
    }
  }
}
