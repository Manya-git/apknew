import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';

import '../../../utils/appString.dart';
import '../../../utils/colors.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/loading_indicators.dart';
import '../../../utils/padding_utils.dart';
import '../plan_activation_status_card.dart';

class PendingPlansItem extends StatefulWidget {
  const PendingPlansItem({Key? key}) : super(key: key);

  @override
  State<PendingPlansItem> createState() => _PendingPlansItemState();
}

class _PendingPlansItemState extends State<PendingPlansItem> {
  AccountController controller = Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => SizedBox(
          child: controller.isUpcomingLoading.value
              ? LoadingIndicators.circularIndicator(20, 2.5, AppColors.bgButtonColor)
              : SizedBox(
                  child: controller.orderedPlans.isEmpty
                      ? Center(
                          child: Text(
                            AppString().no_upcoming_plans(context),
                            style: FontUtils.SF.copyWith(color: AppColors.kSubText2, fontSize: 16),
                          ),
                        )
                      : Obx(
                          () => MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.separated(
                                padding: const EdgeInsets.only(
                                    bottom: AppSizingUtils.kCommonSpacing, top: AppSizingUtils.kCommonSpacing),
                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                                itemCount: controller.orderedPlans.length,
                                itemBuilder: (context, index) {
                                  return PlanActivationStatusCard(
                                      plan: controller.orderedPlans[index], page: "upcoming");
                                }),
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
