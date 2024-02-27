import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/loading_indicators.dart';
import 'package:ride_mobile/app/utils/padding_utils.dart';
import 'package:ride_mobile/app/widgets/loader_view.dart';

import '../../../utils/appString.dart';
import '../plan_activation_status_card.dart';

class ExpiredPlansItem extends StatefulWidget {
  const ExpiredPlansItem({Key? key}) : super(key: key);

  @override
  State<ExpiredPlansItem> createState() => _ExpiredPlansItemState();
}

class _ExpiredPlansItemState extends State<ExpiredPlansItem> {
  AccountController controller = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => Stack(
          children: [
            Container(
              child: controller.isExpiredLoading.value
                  ? LoadingIndicators.circularIndicator(20, 2.5, AppColors.kOrangeColor)
                  : SizedBox(
                      child: controller.expiredPlans.isEmpty
                          ? Center(
                              child: Text(
                                AppString().no_expired_plans(context),
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
                                    itemCount: controller.expiredPlans.length,
                                    itemBuilder: (context, index) {
                                      return PlanActivationStatusCard(
                                          plan: controller.expiredPlans[index], page: "expired");
                                    }),
                              ),
                            ),
                    ),
            ),
            controller.isLoading.value ? const LoaderView() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
