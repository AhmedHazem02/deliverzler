import 'package:flutter/material.dart';

import '../../../../presentation/helpers/theme_helper.dart';
import '../../../../presentation/utils/riverpod_framework.dart';
import '../utils/app_theme.dart';
import 'app_theme_provider.dart';

part 'current_app_theme_provider.g.dart';

@Riverpod(keepAlive: true)
class PlatformBrightness extends _$PlatformBrightness {
  @override
  // ignore: deprecated_member_use
  Brightness build() => WidgetsBinding.instance.window.platformBrightness;

  void update(Brightness Function(Brightness) fn) => state = fn(state);
}

@Riverpod(keepAlive: true)
AppThemeMode currentAppThemeMode(Ref ref) {
  final theme =
      ref.watch(appThemeControllerProvider.select((data) => data.valueOrNull));
  final platformBrightness = ref.watch(platformBrightnessProvider);
  return theme ?? getSystemTheme(platformBrightness);
}
