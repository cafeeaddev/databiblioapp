import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/no_data_found_widget.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/cart_response.dart';
import 'package:granth_flutter/models/payment_method_list_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/dashboard/component/cart_component.dart';
import 'package:granth_flutter/screen/payment/cart_payment.dart';
import 'package:granth_flutter/screen/payment/price_calulation_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class WebCartFragmentScreen extends StatefulWidget {
  final bool? isShowBack;

  WebCartFragmentScreen({this.isShowBack});

  @override
  _WebCartFragmentScreenState createState() => _WebCartFragmentScreenState();
}

class _WebCartFragmentScreenState extends State<WebCartFragmentScreen> implements TransactionCallBack {
  late NavigationController controller;

  CartPayment cartPayment = CartPayment();
  List<PaymentMethodListModel> paymentModeList = paymentModeListData();
  List<CartModel> cartItemList = [];

  @override
  void initState() {
    super.initState();
    controller = NavigationController(Client(), style, this);
    getCart();
    afterBuildCreated(() {
      init();
      LiveStream().on(CART_DATA_CHANGED, (p0) {
        init();
        finish(context, true);
      });
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    await getCart().then((value) {
      cartItemList = value.data.validate();
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  /// RemoveCart Api
  Future<void> removeCartApi(BuildContext context, {int? itemId, int? bookId}) async {
    Map request = {
      UserKeys.id: itemId,
    };
    appStore.setLoading(true);
    removeFromCart(request).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      appStore.setCartCount(appStore.cartCount - 1);
      init();
      cartItemListBookId.remove(bookId);
      /* cartItemListBookId.forEach((element) {
        if (element == bookId) {
          appStore.setAddToCart(false);
        }
      });*/
      LiveStream().emit(CART_DATA_CHANGED);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
  }

  ///FlutterWave Payment
  void flutterWaveCheckout() {
    _showConfirmDialog();
  }

  final style = FlutterwaveStyle(
      appBarText: "My Standard Blue",
      buttonColor: Color(0xffd0ebff),
      appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
      buttonTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      appBarColor: Color(0xffd0ebff),
      dialogCancelTextStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
      dialogContinueTextStyle: TextStyle(color: Colors.blue, fontSize: 18));

  void _showConfirmDialog() {
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
      email: appStore.userEmail.validate(),
    );

    final request = StandardRequest(
      txRef: DateTime.now().millisecond.toString(),
      amount: appStore.payableAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
      publicKey: FLUTTER_WAVE_PUBLIC_KEY,
      currency: 'USD',
      redirectUrl: "https://www.google.com",
    );

    try {
      Navigator.of(context).pop(); // to remove confirmation dialog
      _toggleButtonActive(false);
      controller.startTransaction(request);
      _toggleButtonActive(true);
    } catch (error) {
      _toggleButtonActive(true);
      _showErrorAndClose(error.toString());
    }
  }

  void _toggleButtonActive(final bool shouldEnable) {
    setState(() {
      //  isDisabled = !shouldEnable;
    });
  }

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
    snackBar(context, title: errorMessage);
  }

  @override
  onCancelled() {
    snackBar(context, title: "Transaction Cancelled");
  }

  ///
  @override
  onTransactionSuccess(String id, String txRef) {
    final ChargeResponse chargeResponse = ChargeResponse(status: "success", success: true, transactionId: id, txRef: txRef);
    var request = <String, String?>{
      "STATUS": "TXN_SUCCESS",
      "TXNID": chargeResponse.transactionId,
      "TXNSTATUS": chargeResponse.status,
      "TXNSREFF": chargeResponse.txRef,
      "TXNSUCCESS": chargeResponse.success.toString(),
    };
    var data = jsonEncode(cartItemList);
    saveTransaction(request, data, FLUTTER_WAVE_STATUS, 'TXN_SUCCESS', appStore.payableAmount);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(CART_DATA_CHANGED);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', elevation: 0, showBack: widget.isShowBack ?? false, color: context.dividerColor.withOpacity(0.1)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WebBreadCrumbWidget(context, title: language!.cart, subTitle1: 'Home', subTitle2: language!.myCart, bottomSpace: 40),
            Stack(
              children: [
                cartItemList.length != 0 || appStore.cartCount != 0
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 30, right: 25, left: 50),
                            decoration: BoxDecoration(color: defaultPrimaryColor.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product', style: boldTextStyle()),
                                10.height,
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: cartItemList.length,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return CartComponent(
                                      cartModel: cartItemList[index],
                                      onRemoveTap: () {
                                        removeCartApi(context, itemId: cartItemList[index].cartMappingId, bookId: cartItemList[index].bookId);
                                        cartItemList.removeAt(index);
                                        setState(() {});
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ).expand(flex: 6),
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 30, left: 25, right: 50),
                            decoration: BoxDecoration(color: defaultPrimaryColor.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(language!.paymentMethod, style: boldTextStyle()),
                                16.height,
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: List.generate(
                                    paymentModeList.length,
                                    (index) {
                                      return Container(
                                        width: context.width() / 6 - 80,
                                        padding: EdgeInsets.all(8),
                                        decoration: boxDecorationWithRoundedCorners(
                                          backgroundColor: context.cardColor,
                                          border: paymentMode == paymentModeList[index].title ? Border.all(color: defaultPrimaryColor) : Border.all(color: transparentColor),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(paymentModeList[index].image.validate(), height: 35, width: 35).expand(flex: 2),
                                            8.width,
                                            Transform.scale(
                                              scale: 0.9,
                                              child: Checkbox(
                                                value: paymentMode == paymentModeList[index].title ? true : false,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                                onChanged: (value) {
                                                  //
                                                },
                                              ).visible(paymentMode == paymentModeList[index].title),
                                            ).expand(),
                                          ],
                                        ),
                                      ).onTap(() {
                                        setState(() {
                                          paymentMode = paymentModeList[index].title!;
                                        });
                                      }, highlightColor: transparentColor, splashColor: transparentColor);
                                    },
                                  ),
                                ),
                                30.height,
                                Text(language!.paymentDetails, style: boldTextStyle()),
                                16.height,
                                PriceCalculation(cartItemList: cartItemList, key: UniqueKey(), context: BuildContext),
                                30.height,
                                cartItemList.length != 0 || appStore.cartCount != 0
                                    ? AppButton(
                                        text: language!.placeOrder,
                                        color: defaultPrimaryColor,
                                        width: context.width(),
                                        enableScaleAnimation: false,
                                        onTap: () {
                                          toast('This Functionality will work only in Mobile!');
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ).expand(flex: 4),
                        ],
                      )
                    : Observer(
                        builder: (context) => NoDataFoundWidget().visible(!appStore.isLoading),
                      ),
                Observer(
                  builder: (context) => AppLoaderWidget().visible(appStore.isLoading.validate()).center(),
                )
              ],
            ).paddingBottom(16),
          ],
        ),
      ),
    );
  }
}
