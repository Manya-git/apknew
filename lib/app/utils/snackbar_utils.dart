import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {

  static void showSnackBar(String message, int val) {
    Get.showSnackbar(SnackBarUtils.customSnackBar(message, val));
  }

  static Color _bgColor(int val) {
    switch (val) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red.shade700;
      default:
        return Colors.red.shade700;
    }
  }

  static IconData _prefixIcon(int val) {
    switch (val) {
      case 0:
        return Icons.check_circle;
      case 1:
        return Icons.info;
      default:
        return Icons.warning;
    }
  }

  static GetSnackBar customSnackBar(String message, int val) {
    return GetSnackBar(
      mainButton: InkWell(
        onTap: () => Get.back(),
        child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 26,
            )),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 5,
      messageText: Row(
        children: [
          Icon(
            _prefixIcon(val),
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      backgroundColor: _bgColor(val),
      duration: const Duration(seconds: 3),
    );
  }

}
