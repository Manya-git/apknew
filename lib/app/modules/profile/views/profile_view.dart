import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/profile/views/edit_profile_view.dart';
import 'package:ride_mobile/app/services/user/current_user.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/status_bar_utils.dart';

import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/buttons/primary_action_button.dart';
import '../../../widgets/loader_view.dart';
import '../../currency/controllers/currency_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController controller = Get.put(ProfileController());
  CurrencyController currencyController = Get.put(CurrencyController());

  @override
  void dispose() {
    StatusBarUtils.resetStatusBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ArrowedBackButton(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppString().account_settings(context),
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
                Expanded(
                  child: Obx(
                    () => controller.isLoading.value || currencyController.isLoadingCurrency.value
                        ? const Center(child: SizedBox(height: 200, child: LoaderView()))
                        : Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppSizingUtils.kCommonSpacing, vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileInfoCard(
                                  title: AppString().name(context),
                                  value:
                                      CurrentUser().currentUser.firstName! + " " + CurrentUser().currentUser.lastName!,
                                ),
                                ProfileInfoCard(
                                  title: AppString().email(context),
                                  value: CurrentUser().currentUser.email!,
                                ),
                                ProfileInfoCard(
                                  title: AppString().mobile_number(context),
                                  value:
                                      CurrentUser().currentUser.countryCode! + " " + CurrentUser().currentUser.mobile!,
                                ),
                                CurrentUser().configResponse.data!.currencyConversionMasterEnabled!
                                    ? ProfileInfoCard(
                                        title: AppString().currency(context),
                                        value: StringUtils.getCurrencySymbol(
                                                currencyController.currency.value.subscriberCurrency!.currency!) +
                                            " " +
                                            currencyController.currency.value.subscriberCurrency!.currencyName!,
                                      )
                                    : const SizedBox.shrink(),
                                ProfileInfoCard(
                                  title: AppString().password(context),
                                  value: "************",
                                ),
                                const SizedBox(height: 15),
                                // const SavedPaymentMethodCard(),
                              ],
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 50, left: AppSizingUtils.kCommonSpacing, right: AppSizingUtils.kCommonSpacing),
                  child: PrimaryActionButton(
                      label: AppString().edit(context),
                      onTap: () => CurrentUser().configResponse.data!.currencyConversionMasterEnabled!
                          ? Get.to(() => EditProfileView(
                                currencyName: currencyController.currency.value.subscriberCurrency!.currencyName!,
                                currencySymbol: currencyController.currency.value.subscriberCurrency!.currency!,
                              ))
                          : Get.to(() => const EditProfileView()),
                      isLoading: false),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        Container(
          width: Dimens.width(100, context),
          height: Dimens.currentSize(context, 40, 45, 60),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kBorderColor, width: 0.5)),
          child: Text(
            value,
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
