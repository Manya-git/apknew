import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloseButtonDialog extends StatelessWidget {
  const CloseButtonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
        // child: IconButton(
        //   constraints: const BoxConstraints(),
        //   splashColor: Colors.transparent,
        //   highlightColor: Colors.transparent,
        //   icon: Icon(
        //     Icons.close,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => Get.back(),
        // ),
      ),
    );
  }
}
