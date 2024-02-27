import 'package:flutter/cupertino.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/keys.dart';

class AuthBackgroundImage extends StatelessWidget {

  final String? image;
  final double height;
  final double width;

  const AuthBackgroundImage({Key? key,this.image,required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(
        image!,
        height: height,
        width: width,
        fit: BoxFit.cover,
        key: CommonKeys.authBgImageKey,
      ),
    );
  }

}
