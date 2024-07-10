import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/download_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/screen/dashboard/fragment/mobile_challenges_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/web_fragment/challenges_fragment_web.dart';
import 'package:nb_utils/nb_utils.dart';

class ChallengesFragment extends StatefulWidget {
  static String tag = '/LibraryScreen';

  @override
  ChallengesFragmentState createState() => ChallengesFragmentState();
}

class ChallengesFragmentState extends State<ChallengesFragment>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (appStore.isNetworkConnected || !appStore.isNetworkConnected)
          return Stack(
            children: [
              Responsive(
                mobile: MobileChallengesFragment(),
                // web: WebChallengesFragmentScreen(),
                // tablet: WebChallengesFragmentScreen(),
              ),
              Observer(
                builder: (context) {
                  return Align(
                      alignment: Alignment.center,
                      child: AppLoaderWidget()
                          .center()
                          .visible(appStore.isLoading));
                },
              ),
              Observer(
                builder: (context) {
                  return DownloadWidget(
                    downloadPercentage: appStore.downloadPercentageStore,
                  ).center().visible(appStore.isDownloading);
                },
              ),
            ],
          );
        return Offstage();
      },
    );
  }
}
