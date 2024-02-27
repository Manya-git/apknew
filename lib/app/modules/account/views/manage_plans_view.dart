import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/widgets/account_widgets/manage_plan_widgets/active_plans_item.dart';
import 'package:ride_mobile/app/widgets/account_widgets/manage_plan_widgets/expired_plans_item.dart';
import 'package:ride_mobile/app/widgets/account_widgets/manage_plan_widgets/pending_plans_item.dart';

import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';

class ManagePlansView extends StatefulWidget {
  const ManagePlansView({Key? key}) : super(key: key);

  @override
  State<ManagePlansView> createState() => _ManagePlansViewState();
}

class _ManagePlansViewState extends State<ManagePlansView> {
  AccountController controller = Get.put(AccountController());
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
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
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Dimens.getStatusBarHeight(context),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppString().myplans(context),
                          textAlign: TextAlign.left,
                          style: FontUtils.TTFirsNeueTrial.copyWith(
                              fontSize: Dimens.currentSize(context, 18, 20, 22),
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: BlurredContainer(
                      height: Dimens.height(100, context),
                      child: Column(
                        children: [
                          const ManagePlansSegment(),
                          const SizedBox(height: 5),
                          Obx(
                            () => controller.currentTab.value == 0
                                ? const ActivePlansItem()
                                : controller.currentTab.value == 1
                                    ? const PendingPlansItem()
                                    : const ExpiredPlansItem(),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ));
  }
}

class ManagePlansSegment extends StatefulWidget {
  const ManagePlansSegment({
    Key? key,
  }) : super(key: key);

  @override
  State<ManagePlansSegment> createState() => _ManagePlansSegmentState();
}

class _ManagePlansSegmentState extends State<ManagePlansSegment> {
  AccountController controller = Get.put(AccountController());

  Widget _tabWidget(String label, var val, var dataValue) {
    return Obx(
      () => Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
          padding: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            color: controller.currentTab.value == val ? AppColors.bgButtonColor : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Text(
            label + " ($dataValue)",
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16),
                color: controller.currentTab.value == val ? Colors.white : AppColors.kSubText2,
                fontWeight: FontWeight.w600),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.width(100, context) - AppSizingUtils.kCommonSpacing,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: AppColors.kRectangleColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Obx(
          () => CupertinoSegmentedControl(
            pressedColor: Colors.transparent,
            groupValue: controller.currentTab.value,
            padding: EdgeInsets.zero,
            selectedColor: Colors.transparent,
            unselectedColor: Colors.transparent,
            borderColor: Colors.transparent,
            onValueChanged: (value) => controller.changeTab(value),
            children: {
              0: _tabWidget(AppString().active(context), 0,
                  controller.activePlans.isNotEmpty ? controller.activePlans.length : 0),
              // 0: _tabWidget(AppString().active(context), 0, controller.activePlans.isNotEmpty ? 1 : 0),
              1: _tabWidget(AppString().upcoming(context), 1,
                  controller.orderedPlans.isNotEmpty ? controller.orderedPlans.length : 0),
              2: _tabWidget(AppString().expired(context), 2,
                  controller.expiredPlans.isNotEmpty ? controller.expiredPlans.length : 0),
            },
          ),
        ),
      ),
    );
  }
}
