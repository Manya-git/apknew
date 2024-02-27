import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_mobile/app/utils/snackbar_utils.dart';

import '../../../models/transection_response.dart';
import '../../../services/loyaltypoints_api.dart';

class RewardPointController extends GetxController {
  var referalCode = "".obs;
  var rewardPoints = "0".obs;
  var getrewardPoints = "100".obs;
  var rewardMony = "\$0".obs;

  var isLoading = false.obs;

  var transectionData = <TransectionResponse>[].obs;

  TextEditingController rewardpointController = TextEditingController();
  TextEditingController cuponController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void getRewardTransection() async {
    isLoading.value = true;
    var rewardPointRes = await LoyaltyPointsAPI.getRewardPointTransection();
    if (rewardPointRes.isNotEmpty) {
      transectionData.assignAll(rewardPointRes);
    } else {
      SnackBarUtils.showSnackBar("No any transection found!", 2);
    }
    isLoading.value = false;
  }

  String dateFormate(DateTime dateTime) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
