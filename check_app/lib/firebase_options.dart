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
    apiKey: 'AIzaSyCzZ0og2VRaPZISs2jQfzmsZnVmN8lQAaE',
    appId: '1:623152174735:web:9aa43c8bf645cafa5f82fa',
    messagingSenderId: '623152174735',
    projectId: 'dijinx-check-applicaton',
    authDomain: 'dijinx-check-applicaton.firebaseapp.com',
    storageBucket: 'dijinx-check-applicaton.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpCz1yIeWz-pVhLBhYP8WS_i0ade_DyiU',
    appId: '1:623152174735:android:52aa0fbeb527c8265f82fa',
    messagingSenderId: '623152174735',
    projectId: 'dijinx-check-applicaton',
    storageBucket: 'dijinx-check-applicaton.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWvUyiMme9csrAx57bZI3D4c2hCX0QmOU',
    appId: '1:623152174735:ios:9411219d98cc6da75f82fa',
    messagingSenderId: '623152174735',
    projectId: 'dijinx-check-applicaton',
    storageBucket: 'dijinx-check-applicaton.appspot.com',
    iosBundleId: 'com.dijinx.checkApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWvUyiMme9csrAx57bZI3D4c2hCX0QmOU',
    appId: '1:623152174735:ios:9411219d98cc6da75f82fa',
    messagingSenderId: '623152174735',
    projectId: 'dijinx-check-applicaton',
    storageBucket: 'dijinx-check-applicaton.appspot.com',
    iosBundleId: 'com.dijinx.checkApp',
  );
}
