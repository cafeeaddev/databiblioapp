import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceComponent extends StatefulWidget {
  static String tag = '/PriceComponent';
  final num? discountedPrice;
  final num? price;
  final num? discount;
  final bool isCenter;

  PriceComponent({this.discountedPrice, this.price, this.discount, this.isCenter = false});

  @override
  PriceComponentState createState() => PriceComponentState();
}

class PriceComponentState extends State<PriceComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.price == 0 && widget.isCenter) Text(language!.free, style: boldTextStyle(color: defaultPrimaryColor, size: 18), textAlign: TextAlign.center).center(),
        if (widget.price == 0 && widget.isCenter == false) Text(language!.free, style: boldTextStyle(color: defaultPrimaryColor, size: 18), textAlign: TextAlign.center),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: widget.isCenter == false ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            Marquee(
              direction: Axis.horizontal,
              child: Text(
                widget.discountedPrice.validate() != 0
                    ? int.parse(widget.discountedPrice.validate().toStringAsFixed(0)).toCurrencyAmount()
                    : int.parse(
                        widget.price.validate().toStringAsFixed(0),
                      ).toCurrencyAmount(),
                style: boldTextStyle(size: 18, color: widget.price != 0 ? defaultPrimaryColor : black),
              ).center().visible(widget.discountedPrice != 0 || widget.price != 0),
            ),
            6.width,
            Marquee(
              direction: Axis.horizontal,
              child: Text(
                int.parse(widget.price.validate().toStringAsFixed(0)).toCurrencyAmount(),
                style: primaryTextStyle(decoration: TextDecoration.lineThrough, size: 14),
              ).visible(widget.discount != 0 && widget.price != 0).center(),
            ),
          ],
        ),
      ],
    );
  }
}
