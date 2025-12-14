import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default configuration for all supported Firebase platforms
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      // You have not provided iOS configuration yet.
      // Once you add an iOS app in Firebase Console,
      // fill its FirebaseOptions below.
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS is not configured. Add your iOS app in Firebase and update FirebaseOptions.',
        );

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android Firebase configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSXdAqqNla84oCPwBYKgMjgjwATOgl-QA',
    appId: '1:731422501282:android:31f5aa86d38dd06454eafb',
    messagingSenderId: '731422501282',
    projectId: 'smart-phishing-detection',
    databaseURL: 'https://smart-phishing-detection-default-rtdb.firebaseio.com',
    storageBucket: 'smart-phishing-detection.firebasestorage.app',
  );

  /// Web Firebase configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB52CMAJSVju8FUnOwS-38S_2QHKxnyn2Y',
    appId: '1:731422501282:web:7fd5a3edf27cc32d54eafb',
    messagingSenderId: '731422501282',
    projectId: 'smart-phishing-detection',
    authDomain: 'smart-phishing-detection.firebaseapp.com',
    databaseURL: 'https://smart-phishing-detection-default-rtdb.firebaseio.com',
    storageBucket: 'smart-phishing-detection.firebasestorage.app',
    measurementId: 'G-GESFBNVFTH',
  );
}