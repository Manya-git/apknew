import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';

class BlurredContainer extends StatelessWidget {
  final double height;
  final Widget child;

  const BlurredContainer({Key? key, required this.height, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: Dimens.width(100, context),
          decoration: const BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            shape: BoxShape.rectangle,
          ),
          margin: const EdgeInsets.only(left: 20, top: 18, right: 20),
        ),
        Container(
          height: height,
          width: Dimens.width(100, context),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            shape: BoxShape.rectangle,
          ),
          margin: const EdgeInsets.only(top: 30),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class BlurredAnimatedContainer extends StatelessWidget {
  final double height;
  final Widget child;

  const BlurredAnimatedContainer({Key? key, required this.height, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      width: Dimens.width(100, context),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        shape: BoxShape.rectangle,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 30),
      duration: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: child,
        ),
      ),
    );
  }
}
