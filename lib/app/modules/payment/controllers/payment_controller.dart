import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/modules/payment/views/activate_plan_now_view.dart';
import 'package:ride_mobile/app/modules/payment/views/important_information_view.dart';
import 'package:ride_mobile/app/modules/payment/views/installation_options_view.dart';
import 'package:ride_mobile/app/services/account_api.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/services/loyaltypoints_api.dart';
import 'package:ride_mobile/app/services/mix_panel/events.dart';
import 'package:ride_mobile/app/services/payments_api.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:ride_mobile/app/widgets/payment_widgets/stripe_web_view.dart';

import '../../../models/reddem_response.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/account_widgets/esim_error_dialog.dart';
import '../views/important_confirmation_view.dart';

class PaymentController extends GetxController {
  var isApplyReward = false.obs;
  var isApplyCoupon = false.obs;
  var isApplyedForReward = false.obs;
  var isApplyedForCoupon = false.obs;
  var isByNowLoading = false.obs;
  var isActivateLoading = false.obs;
  var isManual = false.obs;
  var transactionId = "".obs;
  var activationString = "".obs;
  var iccid = "".obs;
  var isContinueLoading = false.obs;
  var isFirstTimeUser = true.obs;
  var couponDiscount = 0.obs;
  var remainingRedeemCashValue = "".obs;
  var isRewardPointApply = false.obs;
  var isRewardPointApplyError = "".obs;
  var isCouponCodeApplyError = "".obs;

  DateTime? selectedDate = DateTime.now();
  var newPlan = PlanModel().obs;
  var redeemResponse = RedeemResponse().obs;

  TextEditingController rewardpointController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  @override
  void onInit() {
    getFirstTimeUser();
    rewardpointController.text = "";
    couponController.text = "";
    super.onInit();
  }

  void getFirstTimeUser() async {
    isFirstTimeUser.value = CurrentUser().currentUser.isFirstTimeBuyer!;
    StringUtils.debugPrintMode("isFirstTimeUser: ${isFirstTimeUser.value}");
  }

  RxString getActivationString(bool isFromHome, int index) {
    var activationURL = activationString.value.isEmpty ? "Null" : activationString.value.split("\$")[index];
    return RxString(activationURL);
  }

  void changeActivationOption(bool val) {
    isManual.value = val;
  }

  void continueAhead(PlanModel plan, String transactionId) {
    if (!isFirstTimeUser.value) {
      Get.to(() => ImportantConfirmationView(
            transactionId: transactionId,
            plan: plan,
          ));
    } else {
      Get.to(() => const ImportantInformationView());
    }
  }

  void copyString(String value) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      SnackBarUtils.showSnackBar("Copied to clipboard", 0);
    });
  }

  void onTapBuyNow(PlanModel plan, bool isFromHome, bool isFromDrawer) async {
    isByNowLoading.value = true;
    String points = "";
    String coupon = "";
    if (isApplyedForReward.value) {
      points = rewardpointController.text;
    }
    if (isApplyedForCoupon.value) {
      coupon = couponController.text;
    }
    var res = await PaymentsAPI.launchStripeURL(plan.stripeProductId!, points, coupon);
    if (res.statusCode == 200) {
      String url = jsonDecode(res.body)['url'];
      if (url.contains("transactionId")) {
        var transactionId = url.split("transactionId=")[1];
        onPaymentSuccess(transactionId, plan);
      } else {
        Get.to(() => StripeWebView(
              url: url,
              plan: plan,
            ));
      }
    } else {
      String msg = jsonDecode(res.body)['message'];
      SnackBarUtils.showSnackBar(msg, 2);
    }
    isByNowLoading.value = false;
  }

  void onPaymentSuccess(String id, PlanModel plan) async {
    isByNowLoading.value = true;
    var res = await PaymentsAPI.confirmTransaction(id, plan);
    if (res.statusCode == 200) {
      PlanModel products = productModelFromJsonSingle(res.body);
      plan.price = products.price;
      plan.rewardPointsRedeemed = products.rewardPointsRedeemed;
      plan.rewardCashValueRedeemed = products.rewardCashValueRedeemed;
      plan.earnedPoints = products.earnedPoints;
      plan.newEsim = products.newEsim!;
      plan.id = products.id;
      plan.couponCode = products.couponCode;
      plan.couponAmount = products.couponAmount;

      MixPanelEvents.paymentSuccessfulEvent(plan);
      Get.offAll(() => const HomeView());
      Get.to(() => ActivatePlanNowView(
            plan: plan,
            transactionId: id,
          ));
      CurrentUser().currentUser.iccid!.isEmpty ? autoGetICCID() : null;
    } else {
      String msg = jsonDecode(res.body)['message'];
      if (msg != "") {
        SnackBarUtils.showSnackBar(msg, 3);
      } else {
        SnackBarUtils.showSnackBar("Payment Failed", 3);
      }
    }
    isByNowLoading.value = false;
  }

  void autoGetICCID() async {
    var res = await PaymentsAPI.fetchICCID();
    if (res.statusCode == 200) {
      iccid.value = jsonDecode(res.body)['iccid'] ?? "";
      if (iccid.value.isNotEmpty) {
        StringUtils.debugPrintMode(iccid + " is the iccid");
        MixPanelEvents.iccidGeneratedEvent(iccid.value);
        var response = await PaymentsAPI.fetchActivationCode(iccid.value);
        activationString.value = jsonDecode(response.body)['activationCode'] ?? "";
        MixPanelEvents.activationStringGeneratedEvent(activationString.value);
        await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
        print("LPA:${activationString.value}");
      }
    }
  }

  Future<void> getICCID(bool autoNavigate, String planIccid) async {
    isActivateLoading.value = true;
    if (autoNavigate) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (planIccid.isEmpty) {
      var res = await PaymentsAPI.fetchICCID();
      StringUtils.debugPrintMode(res.statusCode);
      if (res.statusCode == 200) {
        try {
          iccid.value = jsonDecode(res.body)['iccid'];
          StringUtils.debugPrintMode(iccid + " is the iccid");
          await getActivationCode(iccid.value, autoNavigate);
          await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
          isActivateLoading.value = false;
        } on Error {
          isActivateLoading.value = false;
          MixPanelEvents.iccidGenerationFailedEvent(iccid.value);
          autoNavigate ? SnackBarUtils.showSnackBar('Sorry, something went wrong. Please try again.', 2) : null;
        }
      } else {
        autoNavigate ? SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2) : null;
        isActivateLoading.value = false;
        MixPanelEvents.iccidGenerationFailedEvent(iccid.value);
      }
    } else {
      iccid.value = planIccid;
      await getActivationCode(planIccid, autoNavigate);
      await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
      isActivateLoading.value = false;
    }
  }

  Future<void> getActivationCode(String iccid, bool autoNavigate) async {
    var res = await PaymentsAPI.fetchActivationCode(iccid);
    if (res.statusCode == 200) {
      activationString.value = jsonDecode(res.body)['activationCode'];
      MixPanelEvents.activationStringGeneratedEvent(activationString.value);
      autoNavigate ? Get.to(() => const InstallationOptionsView(isFromHome: false)) : null;
      print("LPA:${activationString.value}");
    } else {
      isActivateLoading.value = false;
      autoNavigate ? SnackBarUtils.showSnackBar('Sorry, something went wrong. Please try again.', 2) : null;
    }
  }

  // Future<void> getDataUsage() async {
  //   var dataUsage = await AccountAPI.fetchDataUsage(CurrentUser().currentUser.iccid!);
  //   CurrentUser().currentUser.dataUsage = dataUsage;
  // }

  Future<void> updateData(int accountTab, int selectedTab) async {
    // await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
    // Get.offAll(() => const HomeView(accountTab: 1));
    // HomeController controller = Get.put(HomeController());
    // controller.selectedTab.value = 1;

    await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
    Get.offAll(() => HomeView(
          accountTab: accountTab,
        ));
    HomeController controller = Get.put(HomeController());
    controller.selectedTab.value = selectedTab;
  }

  Future<void> openESIMErrorDialog(PlanModel plan, String transactionId) async {
    // isContinueLoading.value = true;
    // if (plan.newEsim!) {
    //   Get.dialog(ESimErrorDialog(plan: plan));
    //   isContinueLoading.value = false;
    // } else {
    //   var res = await AccountAPI.activatePlan(plan.iccid!, transactionId, plan, false);
    //   if (res.statusCode == 200) {
    //     await updateData(0, 0);
    //     Get.offAll(() => const HomeView(accountTab: 0));
    //   } else if (res.statusCode == 464) {
    //     Get.dialog(ESimErrorDialog(plan: plan));
    //   } else {
    //     SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2);
    //   }
    //   isContinueLoading.value = false;
    // }

    isContinueLoading.value = true;

    if (!plan.newEsim!) {
      var res = await AccountAPI.activatePlan(plan.iccid!, transactionId, plan, false);
      if (res.statusCode == 200) {
        await updateData(0, 0);
      } else if (res.statusCode == 464) {
        Get.dialog(ESimErrorDialog(plan: plan));
        isContinueLoading.value = false;
      } else {
        SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2);
      }
    } else {
      Get.dialog(ESimErrorDialog(plan: plan));
    }
    isContinueLoading.value = false;
  }

  void onTapContinue(PlanModel plan, String transactionId) async {
    isContinueLoading.value = true;
    if (!isManual.value) {
      await openESIMErrorDialog(plan, transactionId);
      isContinueLoading.value = false;
    } else {
      await updateData(1, 1);
      isContinueLoading.value = false;
    }
  }

  /// * Send reward Points to Server
  Future<void> applyRewardPoints(String productId, AccountController controller) async {
    Get.put(AccountController());
    isApplyReward(true);
    if (!isApplyedForCoupon.value) {
      couponController.text = "";
      isCouponCodeApplyError.value = "";
    }
    var response = await LoyaltyPointsAPI.applyRedeem_and_Coupon(
        productId, rewardpointController.text, couponController.text, true, isApplyedForCoupon.value);
    StringUtils.debugPrintMode(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        RedeemResponse redeemRes = redeemResponseFromJson(response.body);
        controller.rewardPointResponse.value.rewardPoints = redeemRes.remainingRewardPoints;
        redeemResponse.value = redeemRes;
        var discountValue = redeemResponse.value.rewardPointsValue!;
        var actualValue = double.parse(controller.rewardPointResponse.value.cashValue!);
        var remainingValue = actualValue - discountValue;
        remainingRedeemCashValue.value = remainingValue.toStringAsFixed(2);
        isApplyedForReward.value = true;
      }
    } else {
      var jsonStr = json.decode(response.body);
      var msg = jsonStr["rewardPointsError"];
      isRewardPointApplyError.value = msg;
      SnackBarUtils.showSnackBar(msg, 2);
    }
    isApplyReward(false);
  }

  /// * Send coupon code to Server
  Future<void> applyCouponCode(String productId) async {
    isApplyCoupon(true);
    if (!isApplyedForReward.value) {
      rewardpointController.text = "";
    }
    var response = await LoyaltyPointsAPI.applyRedeem_and_Coupon(
        productId, rewardpointController.text, couponController.text, isApplyedForReward.value, true);
    if (response.statusCode == 200) {
      RedeemResponse redeemRes = redeemResponseFromJson(response.body);
      if (redeemRes.couponCodeValue! > 0.0) {
        redeemResponse.value = redeemRes;
        isApplyedForCoupon.value = true;
        isCouponCodeApplyError.value =
            "Discount Availed : ${StringUtils.getCurrencySymbol(redeemRes.couponCodeValueCurrency!)} ${redeemRes.couponCodeValue} OFF";
      }
    } else {
      var jsonStr = json.decode(response.body);
      var msg = jsonStr["couponCodeError"];
      isCouponCodeApplyError.value = msg;
      SnackBarUtils.showSnackBar(msg, 2);
    }
    isApplyCoupon(false);
  }
}
