
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/font_utils.dart';

class RoundedBorderButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  const RoundedBorderButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 175,
        decoration: BoxDecoration(
          color: AppColors.kButtonColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Text(
            text,
            style: FontUtils.SF.copyWith(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),
          )),
      ),
    );
  }

}
