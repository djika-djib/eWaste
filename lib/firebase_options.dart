// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB5W_PM6t_MHneuCOEJyT_YXXZOMGpYEd8',
    appId: '1:427798096916:web:37b74a3496daeb86ad4b01',
    messagingSenderId: '427798096916',
    projectId: 'ewaste-baff5',
    authDomain: 'ewaste-baff5.firebaseapp.com',
    storageBucket: 'ewaste-baff5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnni8JuYrgknUCqfmSUHWAPfYeG-nfAzk',
    appId: '1:427798096916:android:b662f4edd07099b9ad4b01',
    messagingSenderId: '427798096916',
    projectId: 'ewaste-baff5',
    storageBucket: 'ewaste-baff5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoQAFmmeWy-V9uz4CzpRhMVAdWTkRDeWU',
    appId: '1:427798096916:ios:923d7f2af133bf41ad4b01',
    messagingSenderId: '427798096916',
    projectId: 'ewaste-baff5',
    storageBucket: 'ewaste-baff5.appspot.com',
    iosBundleId: 'com.example.ewaste',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDoQAFmmeWy-V9uz4CzpRhMVAdWTkRDeWU',
    appId: '1:427798096916:ios:fc45ec0b25b74786ad4b01',
    messagingSenderId: '427798096916',
    projectId: 'ewaste-baff5',
    storageBucket: 'ewaste-baff5.appspot.com',
    iosBundleId: 'com.example.ewaste.RunnerTests',
  );
}
