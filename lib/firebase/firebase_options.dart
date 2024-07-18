// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1vYVOlaDB8sQjpOefb9S8ewC7t7_sZIw',
    appId: '1:152869979546:web:42289b990c2fb291eda623',
    messagingSenderId: '152869979546',
    projectId: 'databiblio-df216',
    authDomain: 'databiblio-df216.firebaseapp.com',
    storageBucket: 'databiblio-df216.appspot.com',
    measurementId: 'G-2DRVB4DXSY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPdc4jkuzFNZTsLsLw1teF6W1RjA_wXnI',
    appId: '1:152869979546:android:61b64b8bb690bbb2eda623',
    messagingSenderId: '152869979546',
    projectId: 'databiblio-df216',
    storageBucket: 'databiblio-df216.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAF40zAGdQz7FiCZBGDFDa7GueETaT1_sw',
    appId: '1:152869979546:ios:77b28c203d5153d6eda623',
    messagingSenderId: '152869979546',
    projectId: 'databiblio-df216',
    storageBucket: 'databiblio-df216.appspot.com',
    androidClientId: '152869979546-0ba010urqe9133dvbq7mb3f6foor4g2v.apps.googleusercontent.com',
    iosClientId: '152869979546-0gsfjgfb2kafraor350ljbvblerup9b0.apps.googleusercontent.com',
    iosBundleId: 'com.cafeead.databiblio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAF40zAGdQz7FiCZBGDFDa7GueETaT1_sw',
    appId: '1:152869979546:ios:d6594be638c7d7e3eda623',
    messagingSenderId: '152869979546',
    projectId: 'databiblio-df216',
    storageBucket: 'databiblio-df216.appspot.com',
    androidClientId: '152869979546-0ba010urqe9133dvbq7mb3f6foor4g2v.apps.googleusercontent.com',
    iosClientId: '152869979546-qaut7rpk6c1tiv6soeti9mrgmnpaue8m.apps.googleusercontent.com',
    iosBundleId: 'com.iqonic.granthFlutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1vYVOlaDB8sQjpOefb9S8ewC7t7_sZIw',
    appId: '1:152869979546:web:e0556d09c5a6108deda623',
    messagingSenderId: '152869979546',
    projectId: 'databiblio-df216',
    authDomain: 'databiblio-df216.firebaseapp.com',
    storageBucket: 'databiblio-df216.appspot.com',
    measurementId: 'G-3KSZKB6FSC',
  );
}
