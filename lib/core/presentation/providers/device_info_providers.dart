import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/services/web/web_device_info_service.dart';
import '../utils/fp_framework.dart';
import '../utils/riverpod_framework.dart';

part 'device_info_providers.g.dart';
part '../extensions/device_info_extensions.dart';

@Riverpod(keepAlive: true)
FutureOr<Option<AndroidDeviceInfo>> androidDeviceInfo(
  Ref ref,
) async {
  if (kIsWeb) return const None();
  if (Platform.isAndroid) {
    return await DeviceInfoPlugin().androidInfo.then(Some.new);
  }
  return const None();
}

@Riverpod(keepAlive: true)
FutureOr<Option<WebDeviceInfo>> webDeviceInfo(
  Ref ref,
) async {
  if (!kIsWeb) return const None();

  final webDeviceInfoService = WebDeviceInfoService();
  return await webDeviceInfoService.getDeviceInfo().then(Some.new);
}

