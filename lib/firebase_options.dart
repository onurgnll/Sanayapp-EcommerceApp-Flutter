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
    apiKey: 'AIzaSyDqakS1JdnanumQG5ddvZhpqqI2WxUEuT4',
    appId: '1:96592526076:web:cee4d6b67dbd82cdbc3579',
    messagingSenderId: '96592526076',
    projectId: 'sanayapp-cc855',
    authDomain: 'sanayapp-cc855.firebaseapp.com',
    storageBucket: 'sanayapp-cc855.appspot.com',
    measurementId: 'G-20BS3KW81W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5XnxTjrq8TrX6zgpdnRh_uHSsxCzHMDQ',
    appId: '1:96592526076:android:70f1e1c9da992490bc3579',
    messagingSenderId: '96592526076',
    projectId: 'sanayapp-cc855',
    storageBucket: 'sanayapp-cc855.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU2YOf_iq-XAHUWtDgsJ06WoYFeu9IL-8',
    appId: '1:96592526076:ios:d978f5f2ebe719d7bc3579',
    messagingSenderId: '96592526076',
    projectId: 'sanayapp-cc855',
    storageBucket: 'sanayapp-cc855.appspot.com',
    iosBundleId: 'com.example.sanayapp2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCU2YOf_iq-XAHUWtDgsJ06WoYFeu9IL-8',
    appId: '1:96592526076:ios:5ae88268cf878e55bc3579',
    messagingSenderId: '96592526076',
    projectId: 'sanayapp-cc855',
    storageBucket: 'sanayapp-cc855.appspot.com',
    iosBundleId: 'com.example.sanayapp2.RunnerTests',
  );
}