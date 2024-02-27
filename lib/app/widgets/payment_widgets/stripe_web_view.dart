import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeWebView extends StatefulWidget {
  final String url;
  final PlanModel plan;

  const StripeWebView({Key? key, required this.url, required this.plan}) : super(key: key);

  @override
  State<StripeWebView> createState() => _StripeWebViewState();
}

class _StripeWebViewState extends State<StripeWebView> {
  PaymentController paymentController = Get.put(PaymentController());
  var controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("transactionId") && request.url.contains("success")) {
              var transactionId = request.url.split("transactionId=")[1];
              Get.back();
              Future.delayed(Duration(seconds: 1), () {
                paymentController.onPaymentSuccess(transactionId, widget.plan);
              });
              return NavigationDecision.navigate;
            } else if (request.url.contains("cancel")) {
              StringUtils.debugPrintMode("Navigation request: ${request.url}");
              Get.back();
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PaymentController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
