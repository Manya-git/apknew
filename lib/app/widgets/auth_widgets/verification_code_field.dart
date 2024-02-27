import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../modules/forgot_password/controllers/forgot_password_controller.dart';
import '../../utils/dimensions.dart';

class VerificationCodeField extends StatelessWidget {
  final TextEditingController controller;
  final Color textColor;
  final double width;

  const VerificationCodeField({Key? key, required this.controller, required this.textColor, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());
    return PinCodeTextField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      textStyle: FontUtils.SF
          .copyWith(fontSize: Dimens.currentSize(context, 14, 16, 18), color: textColor, fontWeight: FontWeight.bold),
      pinTheme: PinTheme(
        disabledColor: AppColors.kBorderColor,
        activeColor: AppColors.kBorderColor,
        inactiveColor: AppColors.kBorderColor,
        inactiveFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        selectedColor: AppColors.kBorderColor,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        borderWidth: 1,
        fieldHeight: 55,
        fieldWidth: width,
        activeFillColor: Colors.transparent,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      controller: controller,
      enableActiveFill: true,
      onCompleted: (v) {},
      onChanged: (value) {},
      appContext: context,
    );
  }
}
