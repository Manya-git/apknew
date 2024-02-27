import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ride_mobile/app/modules/account/views/plan_details.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../models/plan_model.dart';
import '../../modules/account/controllers/account_controller.dart';
import '../../utils/dimensions.dart';

class DataUsageCardAccount extends StatefulWidget {
  final int? flag;
  final int? index;

  const DataUsageCardAccount({
    Key? key,
    this.flag,
    this.index = 0,
  }) : super(key: key);

  @override
  State<DataUsageCardAccount> createState() => _DataUsageCardAccountState();
}

class _DataUsageCardAccountState extends State<DataUsageCardAccount> {
  AccountController controller = Get.put(AccountController());
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return widget.flag == 0
        ? Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            decoration: BoxDecoration(
              color: AppColors.kRectangleColor,
              borderRadius: BorderRadius.circular(35),
            ),
            child: controller.activePlans.isNotEmpty
                ? Obx(() => _planDetails(controller.activePlans[widget.index!]))
                : const SizedBox.shrink(),
          )
        : controller.activePlans.isNotEmpty
            ? _activePlanItemView()
            : const SizedBox.shrink();
  }

  Widget _planDetails(PlanModel activePlan) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppString().plan_status(context),
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 18,
              width: 18,
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            ),
          ],
        ),
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
                // maxLines: 1,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
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
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ICCID :",
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 14, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                activePlan.iccid!,
                style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 14, 14, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.withOpacity(0.5), thickness: 0.5),
        Text(AppString().data_balance(context),
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 15, 17, 19), color: Colors.white, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 100,
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
        const SizedBox(
          height: 10,
        ),
        Obx(() => Center(
            child: _textCard(
                "${controller.usedData.value} / ${controller.totalData.value} " + AppString().used(context),
                AppColors.kSubText))),
        const SizedBox(
          height: 7,
        ),
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

  Widget _activePlanItemView() {
    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: AppColors.kBGPlanItem,
            shape: BoxShape.rectangle,
            image: const DecorationImage(image: AssetImage(Assets.bg_img_plna_item), fit: BoxFit.fill)),
        child: _activePlanDetails(controller.activePlans[widget.index!]));
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
}
