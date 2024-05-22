import 'package:flutter/material.dart';
import 'package:granth_flutter/screen/setting/component/mobile_language_component.dart';
import 'package:granth_flutter/screen/setting/web_screen/language_screen_web.dart';
import 'package:nb_utils/nb_utils.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  LanguagesScreenState createState() => LanguagesScreenState();
}

class LanguagesScreenState extends State<LanguagesScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: MobileLanguageComponent(),
        web: WebLanguageScreen(),
        tablet: MobileLanguageComponent(),
      ),
    );
  }
}
