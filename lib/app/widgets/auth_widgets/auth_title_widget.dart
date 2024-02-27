import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';

class AuthTitleWidget extends StatelessWidget {
  final String title;
  const AuthTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: FontUtils.TTFirsNeueTrial.copyWith(
          fontSize: Dimens.currentSize(context, 18, 20, 22),
          color: Colors.white,
          height: 1.5,
          fontWeight: FontWeight.w600),
      textAlign: TextAlign.left,
    );
  }
}
