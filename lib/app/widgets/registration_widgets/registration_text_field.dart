import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../utils/dimensions.dart';

class RegistrationTextField extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? showSuffix;
  final bool showPassword;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final double? height;
  final bool? readOnly;
  final String? Function(String? value)? validation;
  final Function()? onTap;

  const RegistrationTextField(
      {Key? key,
      required this.hintText,
      this.prefixIcon,
      required this.suffixIcon,
      this.showSuffix,
      required this.showPassword,
      required this.controller,
      required this.textCapitalization,
      required this.inputFormatters,
      this.textInputType,
      this.validation,
      this.height,
      this.onTap,
      this.readOnly = false})
      : super(key: key);

  @override
  State<RegistrationTextField> createState() => _RegistrationTextFieldState();
}

class _RegistrationTextFieldState extends State<RegistrationTextField> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        textCapitalization: widget.textCapitalization,
        cursorHeight: 16,
        maxLines: 1,
        readOnly: widget.readOnly!,
        validator: widget.validation,
        obscureText: widget.showPassword,
        cursorColor: FontColors.white71,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        onTap: widget.onTap,
        style: FontUtils.SF.copyWith(
            fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          counterText: "",
          constraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
          hintText: widget.hintText,
          errorStyle: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 11, 12, 13), color: Colors.red),
          errorMaxLines: 3,
          hintStyle: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16),
              color: FontColors.white71,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
