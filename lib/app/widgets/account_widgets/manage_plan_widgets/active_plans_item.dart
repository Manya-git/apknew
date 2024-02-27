import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/widgets/account_widgets/data_usage_card.dart';

import '../../../models/plan_model.dart';
import '../../../modules/account/views/plan_details.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/padding_utils.dart';

class ActivePlansItem extends StatefulWidget {
  const ActivePlansItem({Key? key}) : super(key: key);

  @override
  State<ActivePlansItem> createState() => _ActivePlansItemState();
}

class _ActivePlansItemState extends State<ActivePlansItem> {
  AccountController controller = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => SizedBox(
            child: controller.activePlans.isEmpty
                ? Center(
                    child: Text(
                      AppString().no_active_plans(context),
                      style: FontUtils.SF
                          .copyWith(color: AppColors.kSubText2, fontSize: Dimens.currentSize(context, 12, 14, 16)),
                    ),
                  )
                : MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: AppSizingUtils.kCommonSpacing),
                      itemCount: controller.activePlans.length,
                      itemBuilder: (context, indexR) {
                        return _activePlanItemView(indexR);
                        Column(
                          children: [
                            DataUsageCardAccount(
                              flag: 1,
                              index: indexR,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                    ),
                  )),
      ),
    );
  }

  Widget _activePlanItemView(int indexR) {
    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: AppColors.kBGPlanItem,
            shape: BoxShape.rectangle,
            image: const DecorationImage(image: AssetImage(Assets.bg_img_plna_item), fit: BoxFit.fill)),
        child: _activePlanDetails(controller.activePlans[indexR]));
  }

  Widget _activePlanDetails(PlanModel activePlan) {
    var usedDATA = controller.getCalulatedData(activePlan, 0);
    var totalDATA = controller.getCalulatedData(activePlan, 1);
    print(usedDATA);
    print(totalDATA);
    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppString().plan_details(context),
                  style: FontUtils.TTFirsNeueTrial.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () => Get.to(PlanDetails(
                          flag: 0,
                          planModel: activePlan,
                        )),
                    child: SvgPicture.asset(Assets.plan_info, width: 16, height: 16)),
              ],
            ),
            Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    activePlan.name!.toUpperCase() + " :",
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    activePlan.data! +
                        " " +
                        AppString().fordays(context) +
                        " " +
                        activePlan.validity!.toString() +
                        " " +
                        AppString().days(context),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: AppColors.kIconColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ICCID :",
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  activePlan.iccid!,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppString().plan_status(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppString().active(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(AppString().data_balance(context),
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 16, 16, 20),
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: Obx(
                () => LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 70,
                  lineHeight: 15.0,
                  animationDuration: 1000,
                  percent: controller.dataUsagePercent.value,
                  animateFromLastPercent: true,
                  center: Text((controller.dataUsagePercent.value * 100).toString() + "%",
                      style: FontUtils.SF.copyWith(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
                  barRadius: const Radius.circular(10),
                  linearGradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[AppColors.lnProgress2, AppColors.lnProgress1],
                  ),
                  backgroundColor: AppColors.primaryBlackColor,
                  animation: true,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(child: _textCard("${usedDATA} / ${totalDATA} " + AppString().used(context), AppColors.kSubText)),
            const SizedBox(
              height: 10,
            ),
            Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppString().validity(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              controller.dateFormate(activePlan.expiredDate!),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 14, 18),
                  color: AppColors.kIconColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )),
      ],
    );
  }

  Widget _textCard(String label, Color color) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: FontUtils.SF
          .copyWith(fontSize: Dimens.currentSize(context, 10, 12, 14), color: color, fontWeight: FontWeight.w500),
    );
  }
}
