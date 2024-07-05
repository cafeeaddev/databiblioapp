import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/app_theme.dart';
import 'package:granth_flutter/firebase/firebase_options.dart';
import 'package:granth_flutter/locale/app_localizations.dart';
import 'package:granth_flutter/locale/languages.dart';
import 'package:granth_flutter/screen/splash_screen.dart';
import 'package:granth_flutter/store/app_store.dart';
import 'package:granth_flutter/theme_notifier.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/database_helper.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'network/rest_apis.dart';

AppStore appStore = AppStore();
BaseLanguage? language;
List<int> cartItemListBookId = [];
String? appVersion;

final dbHelper = DatabaseHelper.instance;
int mAdShowCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;

  HttpOverrides.global = HttpOverridesSkipCertificate();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    if (isMobile) {
      MobileAds.instance.initialize();
    }
  });

  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = defaultPrimaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultBlurRadius = 4;
  defaultSpreadRadius = 4;
  defaultRadius = 16;
  defaultAppButtonRadius = 16;
  defaultAppButtonElevation = 0;
  defaultLoaderBgColorGlobal = secondaryPrimaryColor;
  defaultLoaderBgColorGlobal = secondaryPrimaryColor;
  defaultCurrencySymbol = currencyDollar;

  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN, defaultValue: false));

  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
  await appStore.setDisplayWalkThrough(getBoolAsync(FIRST_TIME, defaultValue: true));
  await appStore.setDisableNotification(getBoolAsync(IS_NOTIFICATION, defaultValue: false));
  await appStore.setDarkMode(getBoolAsync(IS_DARK_MODE));
  await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
  await appStore.setName(getStringAsync(USER_NAME), isInitializing: true);
  await appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitializing: true);
  await appStore.setUserName(getStringAsync(USER_NAME), isInitializing: true);
  await appStore.setUserProfile(getStringAsync(USER_PROFILE), isInitializing: true);
  await appStore.setUserContactNumber(getStringAsync(USER_CONTACT_NUMBER), isInitializing: true);
  await appStore.setPaymentMode(getStringAsync(SELECTED_PAYMENT_MODE));
  await appStore.setToken(getStringAsync(TOKEN));
  await appStore.setCartCount(getIntAsync(CART_COUNT));
  await appStore.setAddToCart(getBoolAsync(IS_ADD_TO_CART));

  await appStore.setPageVariant(getIntAsync(PAGE_VARIANT, defaultValue: 1));
  if (appStore.isLoggedIn) {
    getCartItem();
  }

  if (isMobile) {
    Stripe.publishableKey = STRIPE_PAYMENT_PUBLISH_KEY;
    setOneSignal();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

Future<void> getCartItem() async {
  await getCart().then((value) {
    List<int?> newList = value.data!.map((v) => v.bookId).toList();
    cartItemListBookId = List.from(newList);
  }).catchError((e) {
    toast(e.toString());
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      appStore.setConnectionState(result);
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Observer(
          builder: (_) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            home: SplashScreen(),
            theme: AppThemeData.lightTheme,
            darkTheme: AppThemeData.darkTheme,
            themeMode: themeNotifier.themeMode,
            supportedLocales: LanguageDataModel.languageLocales(),
            localizationsDelegates: [
              AppLocalizations(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) => locale,
            locale: Locale(appStore.selectedLanguageCode),
          ),
        );
      },
    );
  }
}
