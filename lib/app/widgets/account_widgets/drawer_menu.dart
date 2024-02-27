import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/modules/account/views/faq_view.dart';
import 'package:ride_mobile/app/modules/profile/views/profile_view.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../modules/account/views/privacy_policy_view.dart';
import '../../modules/reward_point/views/reward_point_view.dart';
import '../../modules/support/views/support_view_new.dart';
import '../../utils/assets.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_utils.dart';

class DrawerMenu extends GetView<AccountController> {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColors.mainBGColor,
            image: const DecorationImage(image: AssetImage(Assets.shop_bg), fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => {
                          Navigator.pop(context),
                        },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ],
            ),
            Center(
              child: Column(
                children: [
                  CurrentUser().currentUser.profileImageUrl != null && CurrentUser().currentUser.profileImageUrl != ""
                      ? Image.network(
                          CurrentUser().currentUser.profileImageUrl!,
                          height: 50,
                          width: 50,
                        )
                      : Image.asset(
                          Assets.profile_placeholder,
                          height: 50,
                          width: 50,
                        ),
                  const SizedBox(height: 15),
                  Text(
                    "${CurrentUser().currentUser.firstName!} ${CurrentUser().currentUser.lastName!}",
                    style: FontUtils.TTFirsNeueTrial.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            rewardPointView(context),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              color: AppColors.kRectangleColor.withOpacity(0.6),
              margin: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuActionCard(
                      title: AppString().my_account(context),
                      onTap: () => {Get.back(), Get.to(() => const ProfileView())},
                      showBorder: true,
                    ),
                    MenuActionCard(
                      title: AppString().support(context),
                      onTap: () => {
                        Get.back(),
                        Get.to(() => SupportViewNew(
                              isFromHome: false,
                            ))
                      },
                      showBorder: true,
                    ),
                    MenuActionCard(
                      title: AppString().privacy_policy(context),
                      onTap: () => {
                        Get.back(),
                        Get.to(() => const PrivacyPolicyView(
                              flag: 0,
                            ))
                      },
                      showBorder: true,
                    ),
                    MenuActionCard(
                      title: AppString().terms_and_condition(context),
                      onTap: () => {
                        Get.back(),
                        Get.to(() => const PrivacyPolicyView(
                              flag: 1,
                            ))
                      },
                      showBorder: true,
                    ),
                    MenuActionCard(
                      title: AppString().faq(context),
                      onTap: () => {Get.back(), Get.to(() => FAQView())},
                      showBorder: true,
                    ),
                    MenuActionCard(
                      title: AppString().logout(context),
                      onTap: () => controller.logout(),
                      showBorder: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rewardPointView(BuildContext context) {
    return CurrentUser().configResponse.data!.rewardPointsEnabled!
        ? InkWell(
            onTap: () => {
              Get.back(),
              Get.to(() => const RewardPointView()),
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              color: AppColors.kRectangleColor.withOpacity(0.6),
              margin: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppString().my_reward_points(context),
                            style: FontUtils.SF.copyWith(
                                fontSize: Dimens.currentSize(context, 14, 16, 18),
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(Assets.reward_icon),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(
                            () => Text(
                              "${controller.rewardPointResponse.value.rewardPoints.toString()} (${StringUtils.getCurrencySymbol(controller.rewardPointResponse.value.currency!)}${controller.rewardPointResponse.value.cashValue})",
                              style: FontUtils.SF.copyWith(
                                  fontSize: Dimens.currentSize(context, 14, 16, 18),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class MenuActionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showBorder;

  const MenuActionCard({Key? key, required this.title, required this.onTap, required this.showBorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          title,
                          style: FontUtils.SF.copyWith(
                              fontSize: Dimens.currentSize(context, 14, 16, 18),
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
            ),
            showBorder
                ? Divider(color: showBorder ? Colors.grey.shade100 : Colors.transparent, thickness: 0.1)
                : Container(),
          ],
        ),
      ),
    );
  }
}
