import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../mobile_number_icon.dart';

class MobileNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String? value)? validation;
  const MobileNumberTextField({
    required this.controller,
    required this.validation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        keyboardType: TextInputType.number,
        cursorHeight: 17,
        cursorColor: AppColors.bgButtonColor,
        controller: controller,
        validator: validation,
        style: FontUtils.SF.copyWith(
            fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: const MobileNumberIcon(),
          constraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.only(top: 17, right: 20),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red)),
          hintText: AppString().mobile_number(context),
          hintStyle: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white70, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
