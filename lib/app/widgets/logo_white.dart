import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/assets.dart';
import '../utils/keys.dart';

class LogoWhite extends StatelessWidget {
  final double height;
  final double width;

  const LogoWhite({Key? key, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.appLogoWhite,
      height: height,
      width: width,
      fit: BoxFit.cover,
      key: CommonKeys.gbMobileLogoWhiteKey,
    );
  }
}
