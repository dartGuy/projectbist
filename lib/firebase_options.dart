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
    apiKey: 'AIzaSyB63F0xMqZoEId14mkj28duQ0VFqAiIC6g',
    appId: '1:483842136792:web:9c7801ff03c722bd3815ad',
    messagingSenderId: '483842136792',
    projectId: 'projectbistapp',
    authDomain: 'projectbistapp.firebaseapp.com',
    storageBucket: 'projectbistapp.appspot.com',
    measurementId: 'G-ESDZRXTK2F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArkmlkP7cniBqW-vptFiF4fnh-lK5c4eQ',
    appId: '1:483842136792:android:d2196ab2a522b55e3815ad',
    messagingSenderId: '483842136792',
    projectId: 'projectbistapp',
    storageBucket: 'projectbistapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBktda-jMmZMWAzs1kRI099Sx173ib3yi0',
    appId: '1:483842136792:ios:d422087a5e60f5d73815ad',
    messagingSenderId: '483842136792',
    projectId: 'projectbistapp',
    storageBucket: 'projectbistapp.appspot.com',
    iosBundleId: 'com.projectbist.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBktda-jMmZMWAzs1kRI099Sx173ib3yi0',
    appId: '1:483842136792:ios:d422087a5e60f5d73815ad',
    messagingSenderId: '483842136792',
    projectId: 'projectbistapp',
    storageBucket: 'projectbistapp.appspot.com',
    iosBundleId: 'com.projectbist.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB63F0xMqZoEId14mkj28duQ0VFqAiIC6g',
    appId: '1:483842136792:web:9bb12d7b9675e60d3815ad',
    messagingSenderId: '483842136792',
    projectId: 'projectbistapp',
    authDomain: 'projectbistapp.firebaseapp.com',
    storageBucket: 'projectbistapp.appspot.com',
    measurementId: 'G-7Q67EM2KVK',
  );
}