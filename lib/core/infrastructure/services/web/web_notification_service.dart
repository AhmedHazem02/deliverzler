import 'dart:async';
import 'dart:html' as html;

import '../../config/firebase_web_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Web-specific notification service with high performance
/// Implements clean architecture principles
class WebNotificationService {
  WebNotificationService();

  static const String _notificationTag = 'deliverzler-notification';

  bool _isInitialized = false;
  StreamSubscription<html.Event>? _notificationClickSubscription;

  /// Request notification permissions from browser
  Future<NotificationPermission> requestPermission() async {
    if (!kIsWeb) {
      throw UnsupportedError('WebNotificationService is only supported on web');
    }

    try {
      final permission = await html.window.navigator.permissions?.query({
        'name': 'notifications',
      });

      if (permission != null && permission.state == 'granted') {
        return NotificationPermission.granted;
      }

      // Request permission using Notification API
      final result = await html.Notification.requestPermission();

      switch (result) {
        case 'granted':
          return NotificationPermission.granted;
        case 'denied':
          return NotificationPermission.denied;
        default:
          return NotificationPermission.default_;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error requesting notification permission: $e');
      }
      return NotificationPermission.denied;
    }
  }

  /// Initialize web notifications with service worker
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if service worker is supported
      if (!_isServiceWorkerSupported()) {
        if (kDebugMode) debugPrint('Service Worker not supported');
        return;
      }

      // Register Firebase Messaging service worker
      await _registerServiceWorker();

      // Setup notification click listener
      _setupNotificationClickListener();

      _isInitialized = true;
      if (kDebugMode) debugPrint('Web notifications initialized successfully');
    } catch (e) {
      if (kDebugMode) debugPrint('Error initializing web notifications: $e');
    }
  }

  /// Check if service workers are supported
  bool _isServiceWorkerSupported() {
    return html.window.navigator.serviceWorker != null;
  }

  /// Register service worker for push notifications
  Future<void> _registerServiceWorker() async {
    try {
      final registration = await html.window.navigator.serviceWorker?.register(
        '/firebase-messaging-sw.js',
        {'scope': '/'},
      );

      if (registration != null) {
        if (kDebugMode) {
          debugPrint(
            'Service Worker registered with scope: ${registration.scope}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Service Worker registration failed: $e');
    }
  }

  /// Setup listener for notification clicks
  void _setupNotificationClickListener() {
    _notificationClickSubscription?.cancel();
    _notificationClickSubscription =
        html.window.navigator.serviceWorker?.onMessage.listen((event) {
      if (kDebugMode) debugPrint('Message from service worker: ${event.data}');
    });
  }

  /// Show local notification using Web Notification API
  Future<void> showNotification({
    required String title,
    required String body,
    String? icon,
    Map<String, dynamic>? data,
  }) async {
    try {
      final permission = await requestPermission();

      if (permission != NotificationPermission.granted) {
        if (kDebugMode) debugPrint('Notification permission not granted');
        return;
      }

      final options = {
        'body': body,
        'icon': icon ?? '/icons/Icon-192.png',
        'badge': '/icons/Icon-192.png',
        'tag': _notificationTag,
        'requireInteraction': true,
        'data': data,
      };

      // Create notification with proper type casting
      final bodyText = (options['body'] as String?) ?? '';
      final iconPath = options['icon'] as String?;
      html.Notification(title, body: bodyText, icon: iconPath);

      if (kDebugMode) debugPrint('Notification shown: $title');
    } catch (e) {
      if (kDebugMode) debugPrint('Error showing notification: $e');
    }
  }

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) async {
    // Web FCM topic subscription requires backend implementation
    // This is a placeholder for the client-side logic
    if (kDebugMode) {
      debugPrint(
        'Web FCM topic subscription requires server-side implementation',
      );
      debugPrint('Topic: $topic');
    }
  }

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    // Web FCM topic unsubscription requires backend implementation
    if (kDebugMode) {
      debugPrint(
        'Web FCM topic unsubscription requires server-side implementation',
      );
      debugPrint('Topic: $topic');
    }
  }

  /// Get FCM token for web
  Future<String?> getToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Use VAPID key from environment configuration
      const vapidKey = FirebaseWebConfig.vapidKey;

      if (!FirebaseWebConfig.hasVapidKey) {
        if (kDebugMode) {
          debugPrint('⚠️ WARNING: VAPID key not configured!');
          debugPrint('Please set FIREBASE_WEB_VAPID_KEY in .env.local');
          debugPrint(
            'Get it from: Firebase Console > Project Settings > Cloud Messaging > Web Push certificates',
          );
        }
        return null;
      }

      final token = await messaging.getToken(vapidKey: vapidKey);

      if (kDebugMode) debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Handle foreground messages
  void onMessage(void Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  /// Dispose resources
  void dispose() {
    _notificationClickSubscription?.cancel();
    _isInitialized = false;
  }
}

/// Notification permission enum for web
enum NotificationPermission {
  granted,
  denied,
  default_,
}
