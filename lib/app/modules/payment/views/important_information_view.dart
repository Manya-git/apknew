import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import '../../../widgets/buttons/back_button.dart';
import '../../../widgets/loader_view.dart';

class ImportantInformationView extends StatefulWidget {
  const ImportantInformationView({Key? key}) : super(key: key);

  @override
  State<ImportantInformationView> createState() => _ImportantInformationViewState();
}

class _ImportantInformationViewState extends State<ImportantInformationView> {
  Widget _staticTextCard(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 25,
          width: 25,
          margin: const EdgeInsets.only(top: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.bgButtonColor, shape: BoxShape.circle),
          child: Text(number,
              style: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white)),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text,
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 14, 16, 18),
                color: Colors.white,
                height: Dimens.lineHeight(),
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  PaymentController controller = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
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
                        AppString().important_information(context),
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
              Expanded(
                child: Stack(
                  children: [
                    BlurredContainer(
                        height: Dimens.height(100, context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppString().note(context),
                                textAlign: TextAlign.left,
                                style: FontUtils.TTFirsNeueTrial.copyWith(
                                    fontSize: Dimens.currentSize(context, 18, 20, 22),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                AppString().note_details(context),
                                textAlign: TextAlign.center,
                                style: FontUtils.TTFirsNeueTrial.copyWith(
                                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                                    height: 1.8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _staticTextCard("1", AppString().install_your_esim(context)),
                            const SizedBox(
                              height: 8,
                            ),
                            _staticTextCard("2", AppString().active_your_plan(context)),
                            const SizedBox(
                              height: 8,
                            ),
                            _staticTextCard("3", AppString().not_delete_esim(context)),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        child: Obx(
                          () => PrimaryActionButton(
                              label: AppString().install_esim(context),
                              onTap: () {
                                StringUtils.debugPrintMode(controller.iccid.value);
                                controller.getICCID(true, "");
                              },
                              isLoading: controller.isActivateLoading.value),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      child: Image.asset(
                        Assets.img_desgin,
                        fit: BoxFit.fill,
                        height: 100,
                        width: Dimens.width(100, context),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => controller.isActivateLoading.value ? const LoaderView() : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
