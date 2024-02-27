import 'package:get/get.dart';

class LandingController extends GetxController {
  var token = "".obs;

  @override
  void onInit() {
    //AuthAPI.getDeviceToken();
    //setToken();
    //LocalPreferences.clearUserData();
    super.onInit();
  }

  @override
  void onClose() {}

  // Future<void> setToken() async {
  //   String? t = await AuthAPI.getDeviceToken();
  //   token.value = t!;
  // }

  // void copyToken(BuildContext context) {
  //   Clipboard.setData(ClipboardData(text: token.value)).then((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Device token copied to clipboard")));
  //   });
  // }
}
