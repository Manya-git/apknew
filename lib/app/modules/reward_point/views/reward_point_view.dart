import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/modules/reward_point/views/transaction_history_view.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/snackbar_utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/buttons/back_button.dart';
import '../controllers/reward_point_controller.dart';

class RewardPointView extends StatefulWidget {
  const RewardPointView({Key? key}) : super(key: key);

  @override
  State<RewardPointView> createState() => _RewardPointViewState();
}

class _RewardPointViewState extends State<RewardPointView> {
  RewardPointController controller = Get.put(RewardPointController());
  AccountController accountController = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBGColor,
      body: SizedBox(
        height: Dimens.height(100, context),
        width: Dimens.width(100, context),
        child: Stack(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          AppString().rewardPoints2(context),
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
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppString().myRewardPoints(context),
                            textAlign: TextAlign.left,
                            style: FontUtils.TTFirsNeueTrial.copyWith(
                                fontSize: Dimens.currentSize(context, 14, 16, 18),
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          SvgPicture.asset(Assets.reward_icon),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(
                            () => Text(
                              "${accountController.rewardPointResponse.value.rewardPoints.toString()} (${StringUtils.getCurrencySymbol(accountController.rewardPointResponse.value.currency!)}${accountController.rewardPointResponse.value.cashValue})",
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 14, 16, 18),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(color: Color.fromRGBO(245, 245, 245, 1), thickness: 0.1),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => accountController.rewardPointResponse.value.referralCode == ""
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppString().notes(context),
                                    style: FontUtils.SF.copyWith(
                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(AppString().notesDetails(context),
                                      style: FontUtils.SF.copyWith(
                                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppString().myReferralCode(context),
                        style: FontUtils.SF.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                            color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Dimens.width(100, context),
                        height: Dimens.currentSize(context, 40, 50, 55),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.kBorderColor, width: 0.5)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                "${accountController.rewardPointResponse.value.referralCode}",
                                style: FontUtils.TTFirsNeueTrial.copyWith(
                                    fontSize: Dimens.currentSize(context, 12, 16, 16),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () => accountController.rewardPointResponse.value.referralCode != ""
                                  ? _shareReferralCode(accountController.rewardPointResponse.value.referralCode!)
                                  : null,
                              child: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Text(
                          "${AppString().shareNotes1(context)} ${controller.getrewardPoints} ${AppString().shareNotes2(context)}",
                          style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 12, 14, 16),
                            wordSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      transectionButton(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget transectionButton() {
    return SizedBox(
      height: Dimens.currentSize(context, 40, 50, 60),
      child: Container(
        decoration: BoxDecoration(
            color:
                accountController.rewardPointResponse.value.referralCode != "" ? Colors.black : AppColors.transectionBG,
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => accountController.rewardPointResponse.value.referralCode != ""
              ? Get.to(() => const TransactionHistoryview())
              : SnackBarUtils.showSnackBar("No any transaction! Please purchase plan first", 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppString().transactionHistory(context),
                    textAlign: TextAlign.center,
                    style: FontUtils.TTFirsNeueTrial.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: controller.referalCode != "" ? Colors.white : AppColors.transectionFont,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 24,
                  color: controller.referalCode != "" ? Colors.white : AppColors.transectionFont,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _shareReferralCode(String referralCode) {
    Share.share('Please download GB Mobile and use this $referralCode referral code and earn reward points',
        subject: 'Referral Code');
  }
}
