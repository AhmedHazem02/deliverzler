// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// Web-specific device information service
/// Provides comprehensive browser and device details
class WebDeviceInfoService {
  WebDeviceInfoService();

  /// Get comprehensive device information
  Future<WebDeviceInfo> getDeviceInfo() async {
    return WebDeviceInfo(
      browserName: _getBrowserName(),
      browserVersion: _getBrowserVersion(),
      platform: _getPlatform(),
      userAgent: html.window.navigator.userAgent,
      language: html.window.navigator.language,
      languages: html.window.navigator.languages?.toList() ?? [],
      screenWidth: html.window.screen?.width ?? 0,
      screenHeight: html.window.screen?.height ?? 0,
      devicePixelRatio: html.window.devicePixelRatio.toDouble(),
      isMobile: _isMobile(),
      isTablet: _isTablet(),
      isDesktop: _isDesktop(),
      vendor: html.window.navigator.vendor,
      vendorSub: _getVendorSub(),
      hardwareConcurrency: html.window.navigator.hardwareConcurrency ?? 0,
      maxTouchPoints: _getMaxTouchPoints(),
      cookieEnabled: html.window.navigator.cookieEnabled ?? false,
      onLine: html.window.navigator.onLine ?? true,
    );
  }

  /// Detect browser name
  String _getBrowserName() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (userAgent.contains('firefox')) return 'Firefox';
    if (userAgent.contains('samsungbrowser')) return 'Samsung Internet';
    if (userAgent.contains('opera') || userAgent.contains('opr')) {
      return 'Opera';
    }
    if (userAgent.contains('trident') || userAgent.contains('msie')) {
      return 'Internet Explorer';
    }
    if (userAgent.contains('edge') || userAgent.contains('edg')) return 'Edge';
    if (userAgent.contains('chrome')) return 'Chrome';
    if (userAgent.contains('safari')) return 'Safari';

    return 'Unknown';
  }

  /// Get browser version
  String _getBrowserVersion() {
    final userAgent = html.window.navigator.userAgent;
    final browserName = _getBrowserName();

    try {
      if (browserName == 'Firefox') {
        final match = RegExp(r'Firefox\/(\d+\.\d+)').firstMatch(userAgent);
        return match?.group(1) ?? '';
      }
      if (browserName == 'Chrome') {
        final match = RegExp(r'Chrome\/(\d+\.\d+)').firstMatch(userAgent);
        return match?.group(1) ?? '';
      }
      if (browserName == 'Safari') {
        final match = RegExp(r'Version\/(\d+\.\d+)').firstMatch(userAgent);
        return match?.group(1) ?? '';
      }
      if (browserName == 'Edge') {
        final match = RegExp(r'Edg\/(\d+\.\d+)').firstMatch(userAgent);
        return match?.group(1) ?? '';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error parsing browser version: $e');
    }

    return '';
  }

  /// Get platform information
  String _getPlatform() {
    final platform = html.window.navigator.platform ?? '';
    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (userAgent.contains('android')) return 'Android';
    if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
      return 'iOS';
    }
    if (platform.toLowerCase().contains('mac')) return 'macOS';
    if (platform.toLowerCase().contains('win')) return 'Windows';
    if (platform.toLowerCase().contains('linux')) return 'Linux';

    return platform;
  }

  /// Check if device is mobile
  bool _isMobile() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone');
  }

  /// Check if device is tablet
  bool _isTablet() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return (userAgent.contains('tablet') || userAgent.contains('ipad')) &&
        !_isMobile();
  }

  /// Check if device is desktop
  bool _isDesktop() {
    return !_isMobile() && !_isTablet();
  }

  /// Get vendor sub information
  String _getVendorSub() {
    try {
      final vendorSub = (html.window.navigator as dynamic).vendorSub;
      return (vendorSub ?? '') as String;
    } catch (e) {
      return '';
    }
  }

  /// Get max touch points
  int _getMaxTouchPoints() {
    try {
      final maxTouchPoints = (html.window.navigator as dynamic).maxTouchPoints;
      return (maxTouchPoints ?? 0) as int;
    } catch (e) {
      return 0;
    }
  }

  /// Get screen orientation
  String getScreenOrientation() {
    try {
      final orientation = html.window.screen?.orientation;
      return orientation?.type ?? 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  /// Get available memory (if supported)
  double? getAvailableMemory() {
    try {
      final memory = (html.window.navigator as dynamic).deviceMemory;
      return (memory as num?)?.toDouble();
    } catch (e) {
      return null;
    }
  }

  /// Check if feature is supported
  bool isFeatureSupported(String feature) {
    switch (feature.toLowerCase()) {
      case 'serviceworker':
        return (html.window.navigator as dynamic).serviceWorker != null;
      case 'geolocation':
        return true; // Geolocation is always available in modern browsers
      case 'notification':
        return (html.window as dynamic).Notification != null;
      case 'indexeddb':
        return (html.window as dynamic).indexedDB != null;
      case 'webstorage':
        return (html.window as dynamic).localStorage != null;
      case 'webgl':
        return _isWebGLSupported();
      default:
        return false;
    }
  }

  /// Check WebGL support
  bool _isWebGLSupported() {
    try {
      final canvas = html.CanvasElement();
      return canvas.getContext('webgl') != null ||
          canvas.getContext('experimental-webgl') != null;
    } catch (e) {
      return false;
    }
  }
}

/// Web device information model
class WebDeviceInfo {
  const WebDeviceInfo({
    required this.browserName,
    required this.browserVersion,
    required this.platform,
    required this.userAgent,
    required this.language,
    required this.languages,
    required this.screenWidth,
    required this.screenHeight,
    required this.devicePixelRatio,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.vendor,
    required this.vendorSub,
    required this.hardwareConcurrency,
    required this.maxTouchPoints,
    required this.cookieEnabled,
    required this.onLine,
  });
  final String browserName;
  final String browserVersion;
  final String platform;
  final String userAgent;
  final String language;
  final List<String> languages;
  final int screenWidth;
  final int screenHeight;
  final double devicePixelRatio;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final String vendor;
  final String vendorSub;
  final int hardwareConcurrency;
  final int maxTouchPoints;
  final bool cookieEnabled;
  final bool onLine;

  @override
  String toString() {
    return '''
WebDeviceInfo(
  browser: $browserName $browserVersion,
  platform: $platform,
  screen: ${screenWidth}x$screenHeight @ ${devicePixelRatio}x,
  device: ${isMobile ? 'Mobile' : isTablet ? 'Tablet' : 'Desktop'},
  cores: $hardwareConcurrency,
  touchPoints: $maxTouchPoints,
  online: $onLine
)''';
  }
}
