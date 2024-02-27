import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';

class LoaderView extends StatefulWidget {
  const LoaderView({Key? key}) : super(key: key);

  @override
  _LoaderViewState createState() => _LoaderViewState();
}

class _LoaderViewState extends State<LoaderView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(Assets.loader_view),
    );
  }
}
