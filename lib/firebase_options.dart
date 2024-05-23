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
    apiKey: 'AIzaSyB4WZZhWEMjSu7q8tDxHUK0eFzwxmiXEO8',
    appId: '1:1028879529241:web:bebb4283114454c03ac188',
    messagingSenderId: '1028879529241',
    projectId: 'personal-application-data',
    authDomain: 'personal-application-data.firebaseapp.com',
    databaseURL: 'https://personal-application-data-default-rtdb.firebaseio.com',
    storageBucket: 'personal-application-data.appspot.com',
    measurementId: 'G-CCWXLGLWBS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCv0WWFr91tvUfWibfqdOL-qxAwYN6_zyg',
    appId: '1:1028879529241:android:23a0012b75994ca93ac188',
    messagingSenderId: '1028879529241',
    projectId: 'personal-application-data',
    databaseURL: 'https://personal-application-data-default-rtdb.firebaseio.com',
    storageBucket: 'personal-application-data.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYBJH-a4zRZDxUEO6AJDcuIkZZ9jXfLS4',
    appId: '1:1028879529241:ios:94d0c18f024439f43ac188',
    messagingSenderId: '1028879529241',
    projectId: 'personal-application-data',
    databaseURL: 'https://personal-application-data-default-rtdb.firebaseio.com',
    storageBucket: 'personal-application-data.appspot.com',
    iosBundleId: 'com.example.portfoliomanagementapp',
  );
}
