import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/home/views/home_view.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/modules/payment/views/installation_instructions_view.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/font_utils.dart';
import '../../../utils/keys.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';
import 'activate_plan_now_view.dart';

class InstallationOptionsView extends StatefulWidget {
  final bool isFromHome;
  final String? iccid;

  const InstallationOptionsView({Key? key, required this.isFromHome, this.iccid}) : super(key: key);

  static Widget _spacer() {
    return const SizedBox(height: AppSizingUtils.kCommonSpacing);
  }

  @override
  State<InstallationOptionsView> createState() => _InstallationOptionsViewState();
}

class _InstallationOptionsViewState extends State<InstallationOptionsView> {
  PaymentController controller = Get.put(PaymentController());
  int currentView = 0;
  String status = "NA";
  int selection = 0;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    initESim();
    super.initState();
  }

  void initESim() async {
    if (Platform.isAndroid) {
      const platform = MethodChannel('gb.flutter.dev');
      var result = await platform.invokeMethod('initcall');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onWillPop: _onWillPop,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              key: CommonKeys.goBackButtonKey,
                              onTap: () => currentView == 0
                                  ? Get.back()
                                  : setState(() {
                                      currentView = 0;
                                    }),
                              child: SvgPicture.asset(
                                Assets.back_arrow,
                                color: Colors.white,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          AppString().installation(context),
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
                  height: 15,
                ),
                Expanded(
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: BlurredContainer(
                        height: Dimens.height(100, context),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              currentView != 0 ? containView() : eSimIntallOption()
                            ],
                          ),
                        )),
                  ),
                ),
                currentView != 0
                    ? Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 20, top: 0, right: 20),
                        child: Column(
                          children: [
                            PrimaryActionButton(
                                label: AppString().continue_key(context),
                                // onTap: () => widget.isFromHome ? Get.back() : Get.to(() => const HomeView()),
                                onTap: () => Get.offAll(() => const HomeView()),
                                isLoading: false),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () => Get.offAll(() => const HomeView()),
                              child: Text(
                                AppString().skip(context),
                                textAlign: TextAlign.center,
                                style: FontUtils.SF.copyWith(
                                    fontSize: Dimens.currentSize(context, 14, 16, 18),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    height: Dimens.lineHeight(),
                                    shadows: [FontUtils.lightGreyShadow]),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget containView() {
    return selection == 0
        ? QRCodeInstallation(isFromHome: widget.isFromHome)
        : selection == 1
            ? ManualInstallation(isFromHome: widget.isFromHome)
            : const SizedBox.shrink();
  }

  Widget eSimIntallOption() {
    return Column(
      children: [
        Text(
          AppString().install_option_details(context),
          textAlign: TextAlign.left,
          style: FontUtils.TTFirsNeueTrial.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16),
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: Dimens.lineHeight(),
              shadows: [FontUtils.lightGreyShadow]),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 150,
          width: Dimens.width(100, context),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: AppColors.kBorderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              eSimViewOptionItem(
                  isSelected: selection == 0 ? true : false,
                  label: AppString().qr_code_installation(context),
                  onTap: () => {
                        setState(() {
                          selection = 0;
                        })
                      }),
              Divider(
                thickness: 1,
                color: AppColors.kBorderColor,
                height: 0,
              ),
              eSimViewOptionItem(
                  isSelected: selection == 1 ? true : false,
                  label: AppString().manual_installation(context),
                  onTap: () => {
                        setState(() {
                          selection = 1;
                        })
                      }),
              Divider(
                thickness: 1,
                color: AppColors.kBorderColor,
                height: 0,
              ),
              eSimViewOptionItem(
                  isSelected: selection == 2 ? true : false,
                  label: AppString().one_click_installation(context),
                  onTap: () => {
                        setState(() {
                          selection = 2;
                        })
                      }),
            ],
          ),
        ),
        InstallationOptionsView._spacer(),
        Obx(() => PrimaryActionButton(
            label: AppString().continue_key(context),
            onTap: () async {
              if (selection == 2) {
                // one click code...
                if (widget.isFromHome) {
                  await controller.getICCID(false, widget.iccid ?? "");
                  if (controller.iccid.value.isNotEmpty) {
                    // one click code call here...
                    installeSIM();
                  }
                } else {
                  // one click code call here...
                  installeSIM();
                }
              } else {
                if (widget.isFromHome) {
                  await controller.getICCID(false, widget.iccid ?? "");
                  if (controller.iccid.value.isNotEmpty) {
                    setState(() {
                      currentView = 1;
                    });
                  }
                } else {
                  setState(() {
                    currentView = 1;
                  });
                }
              }
            },
            isLoading: controller.isActivateLoading.value))
      ],
    );
  }

  void installeSIM() async {
    print(controller.activationString.value);
    if (Platform.isAndroid) {
      controller.isActivateLoading.value = true;
      const platform = MethodChannel('gb.flutter.dev');
      var result = await platform.invokeMethod('download', <String, String>{'LPA': controller.activationString.value});
      if (result == "SUCCESS") {
        controller.isActivateLoading.value = false;
        SnackBarUtils.showSnackBar("Successful installation & activation of eSIM", 0);
        Get.offAll(() => const HomeView());
      } else if (result == "FAIL") {
        controller.isActivateLoading.value = false;
        SnackBarUtils.showSnackBar("Failed to install & activate eSIM", 1);
        Get.back();
      }
    } else if (Platform.isIOS) {
      var LPA = controller.activationString.value;
      var x1 = LPA.split("\$")[1];
      var x2 = LPA.split("\$")[2];

      const platformChannel = MethodChannel('gb.flutter.dev/iOS');

      final bool result = await platformChannel.invokeMethod('eSimSupported');
      debugPrint('eSimSupported iOS ' + result.toString());

      if (result) {
        String z = await platformChannel.invokeMethod('installeSIM', {"address": x1, "matchingID": x2});
        debugPrint('iOS installeSIM ' + z.toString());
        if (z == "0") {
          SnackBarUtils.showSnackBar("Yay! eSIM installed successfully", 0);
          Get.offAll(() => const HomeView());
        } else if (z == "1") {
          SnackBarUtils.showSnackBar("Opps! eSIM installed fail", 1);
        } else if (z == "2") {
          SnackBarUtils.showSnackBar("Sorry unknown error", 1);
        } else if (z == "3") {
          SnackBarUtils.showSnackBar("Oops! something went wrong", 1);
        }
      } else {
        SnackBarUtils.showSnackBar("Unfortunately, your device does not support eSIM technology", 2);
      }
    }
  }
}
