import 'dart:convert';

import 'package:get/get.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/config_response.dart';
import '../../../services/account_api.dart';
import '../../../utils/status_bar_utils.dart';

class HomeController extends GetxController {
  final selectedTab = 0.obs;

  @override
  void onClose() {}

  void switchTab(int index) {
    selectedTab.value = index;
    if (index == 1) {}
    if (selectedTab.value != 3) {
      StatusBarUtils.resetStatusBar();
    }
  }

  void getConfig() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var modelData = pref.getString('userData');
    String cacheID = "";
    if (modelData != null && modelData != "") {
      Map<String, dynamic> json = jsonDecode(modelData);
      var config = ConfigResponse.fromJson(json);
      CurrentUser().configResponse = config;
      cacheID = config.data!.cacheId.toString();
    }
    var res = await AccountAPI.fetchAppConfig(cacheID);
  }
}
