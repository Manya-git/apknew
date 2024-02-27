import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';

import '../../../services/user/local preferences.dart';
import '../../../utils/assets.dart';
import 'landing_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLoading = false.obs;

  HomeController homeController = Get.put(HomeController());

  void attemptLogin() async {
    String email = await LocalPreferences.getUserEmail();
    String password = await LocalPreferences.getUserPassword();
    if (email.isNotEmpty && password.isNotEmpty) {
      autoLogin(email, password);
    } else {
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const LandingView());
    }
  }

  void autoLogin(String email, String password) async {
    var res = await AuthAPI.loginUser(email, password);
    if (res.statusCode == 200) {
      Get.offAll(() => const HomeView());
    } else {
      LocalPreferences.clearUserData();
      Get.offAll(() => const LandingView());
    }
  }

  @override
  void initState() {
    homeController.getConfig();
    attemptLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                Assets.appLogo,
                height: Dimens.height(25, context),
                width: Dimens.height(25, context),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
