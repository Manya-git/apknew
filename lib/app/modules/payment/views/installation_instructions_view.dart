import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';

import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/buttons/primary_action_button.dart';

class QRCodeInstallation extends GetView<PaymentController> {
  final bool isFromHome;
  final GlobalKey _globalKey = GlobalKey();

  QRCodeInstallation({Key? key, required this.isFromHome}) : super(key: key);

  static Widget _spacer() {
    return const SizedBox(height: 20);
  }

  var platform = const MethodChannel('gb.flutter.dev');

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: Dimens.width(100, context),
            child: Text(
              AppString().qRCodeInstallation(context),
              textAlign: TextAlign.center,
              style: FontUtils.TTFirsNeueTrial.copyWith(
                  fontSize: Dimens.currentSize(context, 18, 20, 22), color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: Dimens.width(100, context),
            child: Text(
              AppString().qRCodeInstallationTag(context),
              textAlign: TextAlign.start,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InstructionsWarningCard(leftLabel: AppString().qRCodeInstallationWarning(context), rightLabel: ""),
          _spacer(),
          Obx(
            () => RepaintBoundary(
              key: _globalKey,
              child: QrImageView(
                backgroundColor: Colors.white,
                data: controller.activationString.value,
                // data: isFromHome
                //     ? "LPA:${CurrentUser().currentUser.activationCode!}"
                //     : (controller.activationString.value.isEmpty ? "" : 'LPA:${controller.activationString.value}'),
                version: QrVersions.auto,
                size: 125.0,
              ),
            ),
          ),
          _spacer(),
          SizedBox(
            width: 200,
            child: PrimaryActionButton(
              label: AppString().downloadQRCode(context),
              onTap: () => saveImage(),
              isLoading: false,
            ),
          ),
          _spacer(),
          Text(
            AppString().detailedInstallationInstructions(context),
            style: FontUtils.TTFirsNeueTrial.copyWith(
                fontSize: Dimens.currentSize(context, 14, 16, 18),
                color: AppColors.bgButtonColor,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 15,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InstructionsLightTextCard(number: "1", text: "Scan the QR code using the camera function\non the device"),
              InstructionsLightTextCard(
                  number: "2",
                  text:
                      "Follow the on-screen installation instructions on the device screen and\n  •Select a name for your eSIM\n  •Select GlowingBud to be your primary\n    service of data.\n    (can be changed in settings later)\n  •For international use, disable cellular data\n    switching"),
              InstructionsLightTextCard(number: "3", text: "Enable data roaming in your settings menu"),
              InstructionsLightTextCard(number: "4", text: "Activate your plan,in your plans page"),
            ],
          ),
        ],
      ),
    );
  }

  void saveImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      if (result["isSuccess"].toString() == "true") {
        // Get.to(() => const HomeView());
        SnackBarUtils.showSnackBar("Image Saved", 0);
      } else {
        SnackBarUtils.showSnackBar("Image not saved! Please try again", 2);
      }
    }
  }
}

class ManualInstallation extends GetView<PaymentController> {
  final bool isFromHome;

  const ManualInstallation({Key? key, required this.isFromHome}) : super(key: key);

  Widget _customTextCard(
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => controller.copyString(subtitle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: AppColors.kSubText,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    subtitle,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              Assets.file_copy,
              color: AppColors.bgButtonColor,
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _spacer() {
    return const SizedBox(height: AppSizingUtils.kCommonSpacing);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: Dimens.width(100, context),
            child: Text(
              AppString().manualInstallation(context),
              textAlign: TextAlign.center,
              style: FontUtils.TTFirsNeueTrial.copyWith(
                  fontSize: Dimens.currentSize(context, 18, 20, 22), color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: Dimens.width(100, context),
            child: Text(
              AppString().manualInstallationTag(context),
              textAlign: TextAlign.start,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InstructionsWarningCard(leftLabel: AppString().qRCodeInstallationWarning(context), rightLabel: ""),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Platform.isAndroid ? 100 : 140,
                width: Dimens.width(100, context),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: AppColors.kBorderColor,
                    width: 1,
                  ),
                ),
                child: Visibility(
                  visible: Platform.isIOS,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => _customTextCard(
                          "SM-DP-ADDRESS", controller.getActivationString(isFromHome, 1).value, context)),
                      Divider(
                        thickness: 1,
                        color: AppColors.kBorderColor,
                        height: 0,
                      ),
                      Obx(() => _customTextCard(
                          "ACTIVATION CODE", controller.getActivationString(isFromHome, 2).value, context)),
                    ],
                  ),
                  replacement: const ActivationStringCard(),
                ),
              ),
              _spacer(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppString().detailedInstallationInstructions(context),
            style: FontUtils.TTFirsNeueTrial.copyWith(
                fontSize: Dimens.currentSize(context, 14, 16, 18),
                color: AppColors.bgButtonColor,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 15,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InstructionsLightTextCard(number: "1", text: "Settings - Cellular/Mobile Data - Add Data Plan"),
              InstructionsLightTextCard(
                  number: "2",
                  text: "Manually enter, or copy and paste the SM-DP-\nAddress and Activation code provided above"),
              InstructionsLightTextCard(
                  number: "3",
                  text:
                      "Follow the on-screen installation instructions on the device and\n  •Select a name for your eSIM\n  •Select GlowingBud to be your primary\n    service of data.\n    (can be changed in settings later)\n  •For international use, disable cellular data\n    switching"),
              InstructionsLightTextCard(number: "4", text: "Enable data roaming in your settings menu"),
              InstructionsLightTextCard(number: "5", text: "Activate your plan,in your plans page"),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivationStringCard extends GetView<PaymentController> {
  const ActivationStringCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => controller.copyString(controller.activationString.value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Activation String".toUpperCase(),
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                        color: AppColors.kSubText,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Obx(
                    () => Text(
                      controller.activationString.value,
                      style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              Assets.file_copy,
              color: AppColors.bgButtonColor,
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class InstructionsLightTextCard extends StatelessWidget {
  final String number;
  final String text;
  final Color? color;
  // final double? fontSize;

  const InstructionsLightTextCard({
    Key? key,
    required this.text,
    required this.number,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.bgButtonColor, shape: BoxShape.circle),
            child: Text(
              number,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              text,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                  color: Colors.white,
                  height: Dimens.lineHeight(),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionsWarningCard extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;

  const InstructionsWarningCard({Key? key, required this.leftLabel, required this.rightLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: FontUtils.SF.copyWith(
            fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
        children: [
          TextSpan(
              text: leftLabel,
              style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16),
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
          TextSpan(
            text: rightLabel,
          ),
        ],
      ),
    );
  }
}
