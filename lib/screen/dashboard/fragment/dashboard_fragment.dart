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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: SizedBox(
          width: 210,
          height: 40,
          child: TextField(
            onTap: () {
              SearchScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
            readOnly: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              hintText: 'Search',
              alignLabelWithHint: true,
              hintStyle: TextStyle(fontFamily: 'Nunito'),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        titleTextStyle: boldTextStyle(size: 24),
        elevation: 0,
        actions: [
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
          future: getDashboardDetailsMoodle(),
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
