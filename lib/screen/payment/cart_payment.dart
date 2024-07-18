import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/cart_response.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';

import 'package:nb_utils/nb_utils.dart';

class CartPayment {
  // StripeServices stripeServices = StripeServices();
  late NavigationController controller;
  bool isDisabled = false;

  Future<void> placeOrder({required String paymentMode, required List<CartModel> cartItemList, BuildContext? context}) async {
    if (paymentMode.isNotEmpty) {
      if (paymentMode == RAZOR_PAY) {
        appStore.setLoading(true);
        // RazorPayPayment.init(appData: APP_NAME, totalAmount: appStore.payableAmount, cartData: cartItemList);

        await 1.seconds.delay;
        appStore.setLoading(false);
        // RazorPayPayment.razorPayCheckout(appStore.payableAmount);
      }
      /*else if (paymentMode == PAYTM) {
        PaytmPayment().checkSumApi(total: appStore.payableAmount);
      } */
      else if (paymentMode == STRIPE) {
        // stripeServices.init(
        //   stripePaymentPublishKey: STRIPE_PAYMENT_KEY,
        //   data: cartItemList,
        //   totalAmount: appStore.payableAmount,
        //   stripeURL: STRIPE_URL,
        //   stripePaymentKey: STRIPE_PAYMENT_KEY,
        //   isTest: true,
        // );
        // await 1.seconds.delay;
        // stripeServices.stripePay();
      }
    } else {
      toast("Payment option are not selected");
    }
  }

  ///FlutterWave Payment

  final style = FlutterwaveStyle(
      appBarText: "My Standard Blue",
      buttonColor: Color(0xffd0ebff),
      appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
      buttonTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      appBarColor: Color(0xffd0ebff),
      dialogCancelTextStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
      dialogContinueTextStyle: TextStyle(color: Colors.blue, fontSize: 18));

  void _showConfirmDialog(BuildContext context) {
    FlutterwaveViewUtils.showConfirmPaymentModal(
      context,
      "USD",
      appStore.payableAmount.toString(),
      style.getMainTextStyle(),
      style.getDialogBackgroundColor(),
      style.getDialogCancelTextStyle(),
      style.getDialogContinueTextStyle(),
      _handlePayment,
    );
  }

  void _handlePayment() async {
    final Customer customer = Customer(
      name: appStore.userName,
      phoneNumber: appStore.userContactNumber,
      email: appStore.userEmail,
    );

    final request = StandardRequest(
      txRef: DateTime.now().millisecond.toString(),
      amount: appStore.payableAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
      publicKey: FLUTTER_WAVE_PUBLIC_KEY,
      currency: "USD",
      redirectUrl: "https://www.google.com",
    );

    try {
      /* Navigator.of(context).pop(); */ // to remove confirmation dialog
      _toggleButtonActive(false);
      controller.startTransaction(request);
      _toggleButtonActive(true);
    } catch (error) {
      _toggleButtonActive(true);
      _showErrorAndClose(error.toString());
    }
  }

  void _toggleButtonActive(final bool shouldEnable) {
/*    setState(() {
      isDisabled = !shouldEnable;
    });*/
  }

  void _showErrorAndClose(final String errorMessage) {
    //  FlutterwaveViewUtils.showToast(context, errorMessage);
    toast(errorMessage);
  }
}
