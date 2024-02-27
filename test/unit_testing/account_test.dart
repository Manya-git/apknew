import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ride_mobile/app/services/account_api.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  var isGettingUsage = false;

  Future getDataUsage() async {
    isGettingUsage = true;
    var dataUsage = await AccountAPI.fetchDataUsage("");
    return dataUsage;
  }

  test("check if data usage getting from server", () async {
    var response = await getDataUsage();
    response.statusCode == 200
        ? debugPrint("data usage data fetched successfully")
        : debugPrint(
            "Could'nt get data usage data due to${StringUtils.getResponseMessage(response.body)}");
    expect(200, response.statusCode);
  });
}
