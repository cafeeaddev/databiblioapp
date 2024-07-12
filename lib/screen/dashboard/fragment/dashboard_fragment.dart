// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/dashboard_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/dashboard/fragment/mobile_dashboard_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/web_fragment/dashboard_fragment_web.dart';
import 'package:granth_flutter/screen/dashboard/search_screen.dart';
import 'package:granth_flutter/screen/setting/wishlist_screen.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardFragment extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardFragmentState createState() => DashboardFragmentState();
}

class DashboardFragmentState extends State<DashboardFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      setStatusBarColor(transparentColor,
          statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset('images/app_images/app_logo_tra.png'),
        ),
        title: SizedBox(
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500]!,
                  offset: Offset(4.0, .5),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: TextField(
              onTap: () {
                SearchScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              },
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                alignLabelWithHint: true,
                hintStyle: TextStyle(fontFamily: 'Nunito'),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none, // remove as bordas
              ),
            ),
          ),
        ),
        titleTextStyle: boldTextStyle(size: 24),
        elevation: 0,
        actions: [
          /*
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                size: 32,
              ),
              onPressed: () {
                WishListScreen().launch(context);
              },
            ),
          ),
        */
        ],
      ),
      body: RefreshIndicator(
        color: secondaryPrimaryColor,
        backgroundColor: defaultPrimaryColor,
        onRefresh: () async {
          setState(() {});
          return await 2.seconds.delay;
        },
        child: SnapHelperWidget<DashboardResponse>(
          future: getDashboardDetailsMoodle(appStore.userId),
          onSuccess: (data) {
            return Responsive(
              mobile: MobileDashboardFragment(data: data),
              web: WebDashboardFragment(data: data),
              tablet: MobileDashboardFragment(data: data),
            );
          },
          loadingWidget: AppLoaderWidget().center(),
        ),
      ),
    );
  }
}
