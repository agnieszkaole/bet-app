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
    apiKey: 'AIzaSyA1lBkuN8_wjNbJCG5-H9iXC8iw7WrFKZ4',
    appId: '1:936911404344:web:44d6f2d5d50f5c4ec715cd',
    messagingSenderId: '936911404344',
    projectId: 'bet-app-fd68c',
    authDomain: 'bet-app-fd68c.firebaseapp.com',
    storageBucket: 'bet-app-fd68c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQH7O8aVHkV4D1C17il8LsF5ZxZ5aogqg',
    appId: '1:936911404344:android:c2bc3a4652e60648c715cd',
    messagingSenderId: '936911404344',
    projectId: 'bet-app-fd68c',
    storageBucket: 'bet-app-fd68c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt2ePOTdjTF_wrU95jFDkGjyMOnq-aQ0k',
    appId: '1:936911404344:ios:c3250ccc94532b16c715cd',
    messagingSenderId: '936911404344',
    projectId: 'bet-app-fd68c',
    storageBucket: 'bet-app-fd68c.appspot.com',
    iosBundleId: 'com.example.betApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBt2ePOTdjTF_wrU95jFDkGjyMOnq-aQ0k',
    appId: '1:936911404344:ios:2224e929c8166a5fc715cd',
    messagingSenderId: '936911404344',
    projectId: 'bet-app-fd68c',
    storageBucket: 'bet-app-fd68c.appspot.com',
    iosBundleId: 'com.example.betApp.RunnerTests',
  );
}
