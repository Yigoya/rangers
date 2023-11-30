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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBh_UcsY3N5PGAGQrlvXvOK08YPLx8aj3k',
    appId: '1:795951509638:web:53fd2e4e6203799e6fe107',
    messagingSenderId: '795951509638',
    projectId: 'flutterchat-791c8',
    authDomain: 'flutterchat-791c8.firebaseapp.com',
    storageBucket: 'flutterchat-791c8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcGBbt3H_zqkGNrw9IsJXS8BqW1Hq0M_4',
    appId: '1:795951509638:android:0a122ef28d7932e46fe107',
    messagingSenderId: '795951509638',
    projectId: 'flutterchat-791c8',
    storageBucket: 'flutterchat-791c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgFr82WjWCRmaYy0-vfOsbMpAOgIQ-8IA',
    appId: '1:795951509638:ios:fb6eabcc99414fcb6fe107',
    messagingSenderId: '795951509638',
    projectId: 'flutterchat-791c8',
    storageBucket: 'flutterchat-791c8.appspot.com',
    iosBundleId: 'com.example.rangers',
  );
}