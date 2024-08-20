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
    apiKey: 'AIzaSyCVQc1KGS6rxgznVo7A_M-V0-JwoE0u4aU',
    appId: '1:66482745641:web:b780d2f034fc59c6504738',
    messagingSenderId: '66482745641',
    projectId: 'park-in-capstone',
    authDomain: 'park-in-capstone.firebaseapp.com',
    storageBucket: 'park-in-capstone.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYzAJlXw5bFwMU-BWoxNnK57bBFdixVdg',
    appId: '1:66482745641:android:84bfff87d8a0b466504738',
    messagingSenderId: '66482745641',
    projectId: 'park-in-capstone',
    storageBucket: 'park-in-capstone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeTHSjhR6mIA6HzjuG9XfBW1Q_dCjpV0s',
    appId: '1:66482745641:ios:f8fa4302a94dc27b504738',
    messagingSenderId: '66482745641',
    projectId: 'park-in-capstone',
    storageBucket: 'park-in-capstone.appspot.com',
    iosBundleId: 'com.example.parkIn',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeTHSjhR6mIA6HzjuG9XfBW1Q_dCjpV0s',
    appId: '1:66482745641:ios:f8fa4302a94dc27b504738',
    messagingSenderId: '66482745641',
    projectId: 'park-in-capstone',
    storageBucket: 'park-in-capstone.appspot.com',
    iosBundleId: 'com.example.parkIn',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVQc1KGS6rxgznVo7A_M-V0-JwoE0u4aU',
    appId: '1:66482745641:web:c96bbf940ac66e9b504738',
    messagingSenderId: '66482745641',
    projectId: 'park-in-capstone',
    authDomain: 'park-in-capstone.firebaseapp.com',
    storageBucket: 'park-in-capstone.appspot.com',
  );

}