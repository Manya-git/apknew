import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_mobile/app/models/data_usage_model.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ride_mobile/app/services/auth_api.dart';
import 'package:ride_mobile/app/services/loyaltypoints_api.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../models/rewardpoints_response.dart';
import '../../../models/saved_card_model.dart';
import '../../../models/user_model.dart';
import '../../../services/account_api.dart';
import '../../../services/card_api.dart';
import '../../../services/destination_api.dart';
import '../../../services/mix_panel/events.dart';
import '../../../services/user/local preferences.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/account_widgets/esim_error_dialog.dart';
import '../../../widgets/account_widgets/plan_expire_dialog.dart';
import '../../landing/views/landing_view.dart';
import '../../login/views/login_view.dart';
import '../../payment/views/payment_details_view.dart';

class AccountController extends GetxController {
  var autoRefill = false.obs;
  var isActive = true.obs;
  var isGettingUsage = false.obs;
  var isReloading = false.obs;
  var isActivating = false.obs;
  var currentTab = 0.obs;
  var isUpcomingLoading = false.obs;
  var isExpiredLoading = false.obs;
  var isTrendingLoading = false.obs;
  var isLoading = false.obs;
  var activePlans = <PlanModel>[].obs;
  var orderedPlans = <PlanModel>[].obs;
  var expiredPlans = <PlanModel>[].obs;
  var trendingPlans = <PlanModel>[].obs;
  var dataUseModelAll = <DataUsageModelAll>[].obs;
  var isGettingPlans = false.obs;
  var currentPlans = <PlanModel>[].obs;
  var defaultCard = "".obs;
  var isWarned = false;
  var savedCards = <CardModel>[].obs;
  var totalData = "".obs;
  var usedData = "".obs;
  var validTill = "".obs;
  var dataUsagePercent = 0.0.obs;
  var activePlanCount = 0.obs;
  var upcomingPlanCount = 0.obs;
  var expirePlanCount = 0.obs;
  var rewardPointResponse = RewardResponse().obs;

  @override
  void onInit() {
    getAllData(false, 0);
    // getDefaultCard();
    getRewardPoints();
    super.onInit();
  }

  void getRewardPoints() async {
    var rewardPointRes = await LoyaltyPointsAPI.getRewardPoint();
    rewardPointResponse.value = rewardPointRes;
  }

  Future<void> getAllData(bool isReload, int i) async {
    isGettingPlans.value = true;
    // if (CurrentUser().currentUser.activeProducts!.isNotEmpty && !isReload) {
    //   var plans = await AccountAPI.fetchActivePlans();
    //   currentPlans.assignAll(plans);
    //   activePlans.assignAll(plans);
    //   isGettingPlans.value = false;
    // }
    isReload ? reloadDataUsage(i) : null;
    var user = await AuthAPI.fetchUserInfo(CurrentUser().currentUser.token!);
    if (user.id!.isNotEmpty) {
      if (user.activeProducts!.isNotEmpty) {
        isActive.value = true;
        autoRefill.value = user.activeProducts![0].isAutoRefillOn!;
      }
      CurrentUser().currentUser = user;
      await getCurrentPlan(user, isReload, i);
      getUpcomingPlans(true);
      getExpiredPlans();
      getTrendingPlans();
    } else {
      logout();
    }
  }

  @override
  void onClose() {}

  String getTotalData(DataUsageModel dataUsage) {
    StringUtils.debugPrintMode(dataUsage.totalData.toString());
    if (dataUsage.totalData == 0) {
      totalData.value = "0 GB";
    } else {
      var tData = dataUsage.totalData! / 1024;
      // if totalGb is less than 1, then return in MB...
      if (tData < 1) {
        totalData.value = "${dataUsage.totalData} MB";
      } else {
        var gb = "";
        dataUsage.totalData! > 999 || dataUsage.totalData! == 1
            ? gb = tData.toInt().toString()
            : gb = tData.toDouble().toStringAsFixed(2);
        totalData.value = "$gb GB";
      }
    }
    getPercentage(dataUsage);
    getExpiryDate(dataUsage);
    getUsedData(dataUsage);
    return totalData.value;
  }

  String getTotalData2(DataUsageModel dataUsage) {
    StringUtils.debugPrintMode(dataUsage.totalData.toString());
    if (dataUsage.totalData == 0) {
      return "0 GB";
    } else {
      var tData = dataUsage.totalData! / 1024;
      // if totalGb is less than 1, then return in MB...
      if (tData < 1) {
        return "${dataUsage.totalData} MB";
      } else {
        var gb = "";
        dataUsage.totalData! > 999 || dataUsage.totalData! == 1
            ? gb = tData.toInt().toString()
            : gb = tData.toDouble().toStringAsFixed(2);
        return "$gb GB";
      }
    }
    // getPercentage(dataUsage);
    // getExpiryDate(dataUsage);
    // getUsedData(dataUsage);
    // return totalData.value;
  }

  String getUsedData2(DataUsageModel dataUsage) {
    var data = dataUsage.usedData!;
    var tData = dataUsage.totalData! / 1024;
    // convert mb to gb...
    var gb = (data / 1024);
    var gbString = "";
    // if data is less than 100 mb, then return in mb else return in gb...
    data < 100 || tData < 1 ? gbString = data.toString() + " MB" : gbString = gb.toDouble().toStringAsFixed(2) + " GB";
    // set usedData to gb...
    // usedData.value = gbString;
    return gbString;
  }

  String getUsedData(DataUsageModel dataUsage) {
    var data = dataUsage.usedData!;
    var tData = dataUsage.totalData! / 1024;
    // convert mb to gb...
    var gb = (data / 1024);
    var gbString = "";
    // if data is less than 100 mb, then return in mb else return in gb...
    data < 100 || tData < 1 ? gbString = data.toString() + " MB" : gbString = gb.toDouble().toStringAsFixed(2) + " GB";
    // set usedData to gb...
    usedData.value = gbString;
    return gbString;
  }

  String getCalulatedData(PlanModel activePlans, int flag) {
    var contain = dataUseModelAll.where((element) => element.subscriptionId == activePlans.id);
    if (contain.isNotEmpty) {
      int index = dataUseModelAll.indexWhere((item) => item.subscriptionId == activePlans.id);
      var usageAll = dataUseModelAll[index];
      var usage = DataUsageModel(
        totalData: usageAll.totalDataSizeInMb,
        remainData: usageAll.remainingDataInMb,
        usedData: usageAll.usedDataSizeInMb,
        endDate: usageAll.endDate,
      );
      if (flag == 0) {
        return getUsedData2(usage);
      } else {
        return getTotalData2(usage);
      }
      // controller.activePlans[indexR].dataUsageModel = usage;
      // totalData = controller.getTotalData(usage);
      // dataUsed = controller.getUsedData(usage);
    } else {
      print("No DaTA Found");
      return "NaN";
    }
  }

  double getPercentage(DataUsageModel dataUsage) {
    if (dataUsage.totalData == null || dataUsage.totalData == 0) {
      dataUsagePercent.value = 0.0;
    } else {
      var percentage = (dataUsage.usedData! / dataUsage.totalData!) * 100;
      var intPercentage = percentage.toInt();
      var finalPercentage = intPercentage / 100;
      dataUsagePercent.value = finalPercentage;
    }
    return dataUsagePercent.value;
  }

  void getExpiryDate(DataUsageModel dataUsage) {
    if (dataUsage.endDate == null) {
      validTill.value = "Unknown";
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(dataUsage.endDate! * 1000).toLocal();
      if (date.difference(DateTime.now()).inDays < 1 && dataUsage.totalData! < 1024) {
        var hours = date.difference(DateTime.now()).inMinutes / 60;
        var roundedHours = hours.floor();
        if (roundedHours < 1) {
          validTill.value = "${date.difference(DateTime.now()).inMinutes} mins";
        } else {
          var minutes = date.difference(DateTime.now()).inMinutes % 60;
          validTill.value = "$roundedHours hrs $minutes mins";
        }
      } else {
        validTill.value = DateFormat('dd MMM yyyy').format(date);
      }
    }
  }

  String dateFormate(DateTime dateTime) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    return formattedDate;
  }

  String dateTimeFormate(DateTime dateTime) {
    String formattedDate = DateFormat('dd MMM, yyyy kk:mm:a').format(dateTime);
    return formattedDate;
  }

  Future<void> reloadDataUsage(int i) async {
    isReloading.value = true;

    var usageAll = await AccountAPI.fetchDataUsageAll(CurrentUser().currentUser.iccid!);
    if (usageAll.isNotEmpty) {
      dataUseModelAll.assignAll(usageAll);
      var usage = DataUsageModel(
        totalData: usageAll[0].totalDataSizeInMb,
        remainData: usageAll[0].remainingDataInMb,
        usedData: usageAll[0].usedDataSizeInMb,
        endDate: usageAll[0].endDate,
      );
      getTotalData(usage);
    } else {
      StringUtils.debugPrintMode("Data Not Found");
      // SnackBarUtils.showSnackBar("Not able to get Data uses!", 2);
    }
    // var usage = await AccountAPI.fetchDataUsage(CurrentUser().currentUser.iccid!, currentPlans[i].id!);
    // if (usage.totalData! == 0) {
    //   isReloading.value = false;
    // } else {
    //   CurrentUser().currentUser.dataUsage = usage;
    //   getTotalData(usage);
    //   isReloading.value = false;
    // }
  }

  Future<void> getDataUsage(int i) async {
    isGettingUsage.value = true;
    // var usage = await AccountAPI.fetchDataUsage(CurrentUser().currentUser.iccid!, currentPlans[i].id!);
    var usageAll = await AccountAPI.fetchDataUsageAll(CurrentUser().currentUser.iccid!);
    if (usageAll.isNotEmpty) {
      dataUseModelAll.assignAll(usageAll);
      var usage = DataUsageModel(
        totalData: usageAll[0].totalDataSizeInMb,
        remainData: usageAll[0].remainingDataInMb,
        usedData: usageAll[0].usedDataSizeInMb,
        endDate: usageAll[0].endDate,
      );
      getTotalData(usage);
    } else {
      StringUtils.debugPrintMode("Data Not Found");
      // SnackBarUtils.showSnackBar("Not able to get Data uses!", 2);
    }
    isGettingUsage.value = false;
  }

  Future<void> getCurrentPlan(UserModel user, bool isReload, int i) async {
    if (user.activeProducts!.isNotEmpty) {
      currentPlans.clear();
      activePlans.clear();
      var plans = await AccountAPI.fetchActivePlans();
      currentPlans.assignAll(plans);
      activePlans.assignAll(plans);
      isReload ? null : await getDataUsage(i);
      isActive.value = true;
      autoRefill.value = activePlans[0].isAutoRefillOn!;
    } else {
      activePlans.clear();
      isGettingUsage.value = true;
      totalData.value = "0 GB";
      validTill.value = "Unknown";
      dataUsagePercent.value = 0.0;
      usedData.value = "0 MB";
      if (orderedPlans.isNotEmpty) {
        currentPlans.clear();
      }
      isWarned = true;
    }
    isGettingPlans.value = false;
  }

  void getUpcomingPlans(bool load) async {
    isUpcomingLoading.value = load;
    isGettingPlans.value = CurrentUser().currentUser.activeProducts!.isEmpty ? true : false;
    var plans = await AccountAPI.fetchUpcomingPlans();
    orderedPlans.assignAll(plans);
    if (orderedPlans.isNotEmpty) {
      currentTab.value = 1;
    }
    if (CurrentUser().currentUser.activeProducts!.isEmpty) {
      currentPlans.assignAll(plans);
    }
    isGettingPlans.value = false;
    isUpcomingLoading.value = false;
  }

  void getExpiredPlans() async {
    isExpiredLoading.value = true;
    var plans = await AccountAPI.fetchExpiredPlans();
    expiredPlans.assignAll(plans);
    isExpiredLoading.value = false;
  }

  void getTrendingPlans() async {
    isTrendingLoading.value = true;
    var plans = await AccountAPI.fetchTrendingPlans();
    trendingPlans.assignAll(plans);
    isTrendingLoading.value = false;
  }

  void changeTab(var index) {
    currentTab.value = index;
  }

  Future<void> activateNow(PlanModel plan) async {
    plan.isActivating!.value = true;
    var res = await AccountAPI.activatePlan(plan.iccid!, plan.transactionId!, plan, true);
    if (res.statusCode == 200) {
      isActive.value = true;
      plan.isActivating!.value = false;
      SnackBarUtils.showSnackBar("Plan activated successfully", 0);
      if (plan.status! == "upcoming") {
        orderedPlans.remove(plan);
        currentTab.value = 0;
      }
      getAllData(true, 0);
    } else if (res.statusCode == 464) {
      Get.dialog(ESimErrorDialog(
        plan: plan,
      ));
      plan.isActivating!.value = false;
    } else {
      SnackBarUtils.showSnackBar(StringUtils.getResponseMessage(res.body), 2);
      plan.isActivating!.value = false;
    }
  }

  void openESIMErrorDialog(PlanModel plan, String page) async {
    if (!isWarned && page == "upcoming" && activePlans.isNotEmpty) {
      Get.dialog(PlanExpireDialog(
        page: page,
        plan: plan,
      ));
    } else {
      plan.isActivating!.value = true;
      await activateNow(plan);
      isWarned = false;
    }
  }

  void goToManagePlans() {
    Get.back();
    HomeController controller = Get.put(HomeController());
    controller.switchTab(1);
  }

  void logout() {
    MixPanelEvents.logoutEvent();
    LocalPreferences.clearUserData();
    Get.offAll(() => const LandingView());
    Get.to(() => LoginView());
  }

  void getDefaultCard() async {
    var cards = await CardAPI.fetchSavedCards(20);
    savedCards.assignAll(cards);
    // if saved cards is not empty, make the first card default...
    if (savedCards.isNotEmpty) {
      // check if any card default is true if yes then exit the function...
      for (var card in savedCards) {
        if (card.isDefault!.value) {
          var defaultC = card;
          defaultCard.value =
              "${defaultC.card!.brand!} - **** ${defaultC.card!.last4!.replaceAll("*", "").replaceAll(" ", "")}";
          StringUtils.debugPrintMode(defaultCard + " is default card");
          return;
        } else {
          defaultCard.value = "";
        }
      }
    } else {
      defaultCard.value = "";
    }
  }

  void getLatestplan(PlanModel planModel) async {
    isLoading.value = true;
    var products = await DestinationAPI.fetchSinglePlans(planModel.productId!, planModel.country!);
    isLoading.value = false;
    if (products.isNotEmpty) {
      // LocationModel locationModel = LocationModel();
      // locationModel.name = planModel.country;
      // locationModel.logo = planModel.flag;
      Get.to(() => PaymentDetailsView(
            isFromDrawer: false,
            isFromHome: true,
            plan: products[0],
            // location: locationModel,
          ));
    }
  }
}
