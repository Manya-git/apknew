import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool showSuffix;
  final bool showPassword;
  final TextEditingController controller;
  final double? hMargin;
  final String? Function(String? value)? validation;

  const AuthTextField(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.suffixIcon,
      required this.showSuffix,
      required this.showPassword,
      required this.controller,
      this.validation,
      this.hMargin})
      : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        obscuringCharacter: "*",
        obscureText: widget.showPassword,
        cursorColor: AppColors.bgButtonColor,
        controller: widget.controller,
        style: FontUtils.SF.copyWith(
            fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w400),
        inputFormatters: widget.hintText == "name@company.com"
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
              ]
            : [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
        textAlign: TextAlign.start,
        maxLines: 1,
        validator: widget.validation,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          // suffixIconConstraints: const BoxConstraints(),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red)),
          errorStyle: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 11, 12, 13), color: Colors.red),
          errorMaxLines: 3,
          disabledBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 14, 16),
              color: FontColors.white71,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.symmetric(horizontal: 25),
      height: Dimens.currentSize(context, 50, 55, 70),
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      //   shape: BoxShape.rectangle,
      //   border: Border.all(
      //     color:widget.isError?Colors.red:AppColors.kBorderColor,
      //     width: 1,
      //   ),
      // ),
      child: TextFormField(
        obscureText: widget.showPassword,
        cursorColor: AppColors.bgButtonColor,
        controller: widget.controller,
        style: FontUtils.SF.copyWith(fontSize: Dimens.currentSize(context, 14, 16, 16), color: Colors.white),
        // inputFormatters: [
        //   FilteringTextInputFormatter.deny(RegExp(r'\s')),
        // ],
        textAlign: TextAlign.start,
        maxLines: 1,
        validator: widget.validation,
        decoration: InputDecoration(
          // prefixIconConstraints: const BoxConstraints(),
          suffixIcon: widget.suffixIcon,
          // prefixIcon: widget.prefixIcon,
          // isCollapsed: true,
          // isDense: true,
          // constraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          // suffixIconConstraints: const BoxConstraints(),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: AppColors.kBorderColor)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red)),
          errorStyle: const TextStyle(height: 0),
          disabledBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: FontUtils.SF
              .copyWith(fontSize: Dimens.currentSize(context, 14, 16, 16), color: Colors.white.withOpacity(0.48)),
        ),
      ),
    );
  }
}
