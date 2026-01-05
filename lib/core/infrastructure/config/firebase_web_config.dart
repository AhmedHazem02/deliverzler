/// Firebase Web Configuration
/// This file contains compile-time constants for Firebase Web setup
/// Values are injected from .env.local via --dart-define-from-file
class FirebaseWebConfig {
  /// Firebase Web API Key
  static const String apiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
  );

  /// Firebase Web Auth Domain
  static const String authDomain = String.fromEnvironment(
    'FIREBASE_WEB_AUTH_DOMAIN',
  );

  /// Firebase Web Project ID
  static const String projectId = String.fromEnvironment(
    'FIREBASE_WEB_PROJECT_ID',
  );

  /// Firebase Web Storage Bucket
  static const String storageBucket = String.fromEnvironment(
    'FIREBASE_WEB_STORAGE_BUCKET',
  );

  /// Firebase Web Messaging Sender ID
  static const String messagingSenderId = String.fromEnvironment(
    'FIREBASE_WEB_MESSAGING_SENDER_ID',
  );

  /// Firebase Web App ID
  static const String appId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
  );

  /// Firebase Web Measurement ID
  static const String measurementId = String.fromEnvironment(
    'FIREBASE_WEB_MEASUREMENT_ID',
  );

  /// Firebase Web VAPID Key for Push Notifications
  static const String vapidKey = String.fromEnvironment(
    'FIREBASE_WEB_VAPID_KEY',
  );

  /// Google Maps Web API Key
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_WEB_API_KEY',
  );

  /// Validate that all required keys are set
  static bool get isValid {
    return apiKey.isNotEmpty &&
        projectId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        appId.isNotEmpty &&
        googleMapsApiKey.isNotEmpty;
  }

  /// Validate VAPID key (optional but recommended for push notifications)
  static bool get hasVapidKey {
    return vapidKey.isNotEmpty && vapidKey != 'YOUR_VAPID_KEY_HERE';
  }
}
