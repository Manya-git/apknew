import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/no_result_found_card.dart';
import 'package:ride_mobile/app/widgets/loader_view.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../account/controllers/account_controller.dart';
import '../controllers/reward_point_controller.dart';

class TransactionHistoryview extends StatefulWidget {
  const TransactionHistoryview({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryview> createState() => _TransactionHistoryviewState();
}

class _TransactionHistoryviewState extends State<TransactionHistoryview> {
  RewardPointController controller = Get.put(RewardPointController());
  AccountController accountController = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
    controller.getRewardTransection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: EdgeInsets.only(top: Dimens.getStatusBarHeight(context)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ArrowedBackButton(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppString().transactionHistory(context),
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlurredContainer(
                  height: Dimens.height(100, context),
                  child: Entry.scale(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              color: AppColors.kBGPlanItem,
                              shape: BoxShape.rectangle,
                              image:
                                  const DecorationImage(image: AssetImage(Assets.bg_img_plna_item), fit: BoxFit.fill)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppString().myRewardPoints(context),
                                  textAlign: TextAlign.left,
                                  style: FontUtils.TTFirsNeueTrial.copyWith(
                                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(Assets.reward_icon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${accountController.rewardPointResponse.value.rewardPoints.toString()} (${StringUtils.getCurrencySymbol(accountController.rewardPointResponse.value.currency!)}${accountController.rewardPointResponse.value.cashValue})",
                                      style: FontUtils.SF.copyWith(
                                          fontSize: Dimens.currentSize(context, 14, 16, 18),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppString().allTransactions(context),
                            style: FontUtils.SF.copyWith(
                                fontSize: Dimens.currentSize(context, 12, 14, 16),
                                color: AppColors.transectionFont,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => controller.isLoading.value
                              ? const LoaderView()
                              : controller.transectionData.isEmpty
                                  ? const NoResultFoundCard(message: "Transection not found!")
                                  : Flexible(
                                      child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: controller.transectionData.length,
                                          itemBuilder: (context, index) {
                                            return _itemView(index);
                                          },
                                          separatorBuilder: (BuildContext context, int index) {
                                            return const SizedBox(
                                              height: 10,
                                            );
                                          }),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemView(int index) {
    var data = controller.transectionData[index];
    String pointsValue = "";
    String TType = "Reward points on purchase";
    bool isPlus = true;
    switch (data.type) {
      case "referral":
        isPlus = true;
        TType = "Referral";
        pointsValue =
            "+${data.rewardPointsEarned.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueEarned})";
        break;
      case "purchase":
        isPlus = true;
        TType = "Reward points on purchase";
        pointsValue =
            "+${data.rewardPointsEarned.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueEarned})";
        break;
      case "redeem":
        isPlus = false;
        TType = "Purchase using reward points";
        pointsValue =
            "-${data.rewardPointsRedeemed.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueRedeemed})";
        break;
      case "refund":
        isPlus = false;
        TType = "Refund reward points";
        pointsValue =
            "-${data.rewardPointsRedeemed.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueRedeemed})";
        break;
      case "refundRedeemed":
        isPlus = true;
        TType = "Refund Redeemed reward points";
        pointsValue =
            "+${data.rewardPointsRedeemed.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueRedeemed})";
        break;
      default:
        isPlus = true;
        TType = "Unknown";
        pointsValue =
            "+${data.rewardPointsEarned.toString()} (${StringUtils.getCurrencySymbol(data.currency!)}${data.cashValueEarned})";
    }
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kBorderColor, width: 0.5)),
      width: Dimens.width(100, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TType,
                    maxLines: 2,
                    style: FontUtils.TTFirsNeueTrial.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimens.currentSize(context, 12, 14, 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.dateFormate(data.createdAt!),
                    style: FontUtils.SF.copyWith(
                        color: AppColors.dateFont,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimens.currentSize(context, 10, 12, 14)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              pointsValue,
              style: FontUtils.TTFirsNeueTrial.copyWith(
                  color: isPlus ? AppColors.rewardTransectionFont : Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.currentSize(context, 13, 15, 17)),
            ),
          ],
        ),
      ),
    );
  }
}
