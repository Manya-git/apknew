import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/status_bar_utils.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../../models/data_usage_model.dart';
import '../../../services/user/current_user.dart';
import '../../../utils/colors.dart';
import '../../../utils/keys.dart';
import '../../../utils/loading_indicators.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/plan_utils.dart';
import '../../../widgets/account_widgets/data_usage_card.dart';
import '../../../widgets/account_widgets/no_any_plan_puchanged.dart';
import '../../../widgets/account_widgets/plan_puchages_but_notactivated.dart';
import '../../payment/views/payment_details_view.dart';
import '../controllers/account_controller.dart';

class AccountView extends StatefulWidget {
  final bool? isActive;
  final int? accountTab;
  final GlobalKey<ScaffoldState> account_key;
  final StringCallback callback;

  const AccountView({Key? key, this.isActive, this.accountTab, required this.account_key, required this.callback})
      : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> with WidgetsBindingObserver {
  Widget _spacer() {
    return const SizedBox(height: 20);
  }

  final AccountController _controller = Get.put(AccountController());
  final HomeController _homeController = Get.put(HomeController());

  void setTab() {
    if (widget.accountTab != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.currentTab.value = widget.accountTab!;
      });
      // StringUtils.debugPrintMode("yes change tab");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setTab();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    StatusBarUtils.resetStatusBar();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    StringUtils.debugPrintMode("AppLifecycleState: $state");
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _controller.getAllData(true, activePage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          key: widget.account_key,
          backgroundColor: AppColors.homeBGColor,
          body: Stack(
            children: [
              Image.asset(
                Assets.shop_bg,
                fit: BoxFit.fill,
                height: Dimens.height(100, context),
                width: Dimens.width(100, context),
                alignment: Alignment.topLeft,
                key: DestinationPageKeys.destinationHeaderImageKey,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Dimens.width(100, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: AppSizingUtils.kCommonSpacing,
                            right: AppSizingUtils.kCommonSpacing,
                            top: Dimens.getStatusBarHeight(context),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                Assets.small_logo,
                                height: 50,
                                width: 50,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    widget.callback("open");
                                  },
                                  child: SvgPicture.asset(Assets.drawer_iocn,
                                      height: 32,
                                      width: 32,
                                      theme: const SvgTheme(currentColor: Colors.white),
                                      fit: BoxFit.contain)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizingUtils.kCommonSpacing),
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => Text(
                              _controller.activePlans.isNotEmpty
                                  ? AppString().hi(context) +
                                      " ${CurrentUser().currentUser.firstName},\n" +
                                      AppString().welcome_back(context)
                                  : AppString().welcome_mybuddy(context) + "\n${CurrentUser().currentUser.firstName}!",
                              style: FontUtils.TTFirsNeueTrial.copyWith(
                                  fontSize: Dimens.currentSize(context, 22, 24, 26),
                                  color: Colors.white,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      width: Dimens.width(100, context),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                RefreshIndicator(
                                    color: AppColors.bgButtonColor,
                                    onRefresh: () async {
                                      await _controller.getAllData(true, activePage);
                                      StringUtils.debugPrintMode("Refreshed");
                                    },
                                    child: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        height: Dimens.height(100, context),
                                        child: SingleChildScrollView(
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics: const ClampingScrollPhysics(),
                                            children: [
                                              Obx(() => Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                    child: _controller.isGettingPlans.value
                                                        ? LoadingIndicators.circularIndicator(24, 2.5, Colors.white)
                                                        : Obx(() => Visibility(
                                                            visible: _controller.currentPlans.isEmpty &&
                                                                _controller.activePlans.isEmpty,
                                                            child: const NoAnyPlanPuchanged())),
                                                  )),
                                              _spacer(),
                                              Obx(() => Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                  child: _controller.activePlans.isNotEmpty
                                                      ? activePlanListView()
                                                      // ? const DataUsageCardAccount(
                                                      //     flag: 0,
                                                      //     index: 0,
                                                      //   )
                                                      : const SizedBox.shrink())),
                                              Obx(() => Visibility(
                                                    visible: _controller.activePlans.isEmpty &&
                                                        _controller.currentPlans.isNotEmpty,
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                        child: const ActivatePlanAfterIntallation()),
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Obx(
                                                () => _trendingListView(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  int activePage = 0;

  Widget activePlanListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          // height: 270,
          child: ExpandablePageView.builder(
            itemCount: _controller.activePlans.length,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            onPageChanged: (page) {
              var contain = _controller.dataUseModelAll
                  .where((element) => element.subscriptionId == _controller.activePlans[page].id);
              if (contain.isNotEmpty) {
                int index = _controller.dataUseModelAll
                    .indexWhere((item) => item.subscriptionId == _controller.activePlans[page].id);
                var usageAll = _controller.dataUseModelAll[index];
                var usage = DataUsageModel(
                  totalData: usageAll.totalDataSizeInMb,
                  remainData: usageAll.remainingDataInMb,
                  usedData: usageAll.usedDataSizeInMb,
                  endDate: usageAll.endDate,
                );
                _controller.getTotalData(usage);
              } else {
                print("No DaTA Found");
              }
              setState(() {
                activePage = page;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DataUsageCardAccount(
                  flag: 0,
                  index: index,
                ),
              );
            },
          ),
          // child: PageView.builder(
          //     itemCount: _controller.activePlans.length,
          //     pageSnapping: true,
          //     onPageChanged: (page) {
          //       print(page);
          //       var contain = _controller.dataUseModelAll
          //           .where((element) => element.subscriptionId == _controller.activePlans[page].id);
          //       if (contain.isNotEmpty) {
          //         int index = _controller.dataUseModelAll
          //             .indexWhere((item) => item.subscriptionId == _controller.activePlans[page].id);
          //         var usageAll = _controller.dataUseModelAll[index];
          //         var usage = DataUsageModel(
          //           totalData: usageAll.totalDataSizeInMb,
          //           remainData: usageAll.remainingDataInMb,
          //           usedData: usageAll.usedDataSizeInMb,
          //           endDate: usageAll.endDate,
          //         );
          //         _controller.getTotalData(usage);
          //       } else {
          //         print("No DaTA Found");
          //       }
          //       setState(() {
          //         activePage = page;
          //       });
          //     },
          //     itemBuilder: (context, pagePosition) {
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 5),
          //         child: DataUsageCardAccount(
          //           flag: 0,
          //           index: pagePosition,
          //         ),
          //       );
          //     }),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(_controller.activePlans.length, activePage)),
      ],
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? AppColors.kButtonColor : AppColors.kButtonColor.withOpacity(0.5),
            shape: BoxShape.circle),
      );
    });
  }

  Widget _trendingListView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString().trending_plan(context),
                style: FontUtils.TTFirsNeueTrial.copyWith(
                    fontSize: Dimens.currentSize(context, 18, 20, 22),
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              InkWell(
                  onTap: () => _homeController.switchTab(2),
                  child: Text(
                    AppString().browsePlans(context),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: AppColors.bgButtonColor,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 170,
          padding: const EdgeInsets.only(left: 20),
          child: ListView.separated(
              itemCount: _controller.trendingPlans.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _listItemHorozontal(_controller.trendingPlans[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 10,
                );
              }),
        ),
      ],
    );
  }

  Widget _listItemHorozontal(PlanModel plan) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          shape: BoxShape.rectangle,
          image: DecorationImage(image: AssetImage(Assets.bg_rect), fit: BoxFit.fill)),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                plan.name!.toUpperCase(),
                maxLines: 1,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 10, 12, 16),
                    color: AppColors.kPlanName,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${PlanUtils.totalData(plan)} for ${PlanUtils.getValidity(plan.validity!)}",
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringUtils.getCurrencySymbol(plan.currency!),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 26, 28, 30),
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "${plan.priceBundle!}",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 26, 28, 30),
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 120,
                child: _actionButton(
                    AppString().buy_now(context),
                    Colors.white,
                    AppColors.kButtonColor,
                    false,
                    () => Get.to(() => PaymentDetailsView(
                          isFromDrawer: false,
                          isFromHome: true,
                          plan: plan,
                        )),
                    // Get.to(OrderSummary(plan: plan)),
                    context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _actionButton(
      String label, Color fontColor, Color bgColor, bool hasBorder, VoidCallback onTap, BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Text(
            label,
            style: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 12, 14, 16), color: fontColor),
          ),
        ),
      ),
    );
  }
}
