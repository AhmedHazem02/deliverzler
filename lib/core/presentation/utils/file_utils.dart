import 'file_utils_mobile.dart' if (dart.library.html) 'file_utils_web.dart';

/// Get a File object from a path (Android/iOS) or null/mock (Web)
dynamic getFile(String path) => getPlatformFile(path);
