import 'package:flutter/material.dart';

import 'core/core_features/locale/presentation/providers/current_app_locale_provider.dart';
import 'core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import 'core/presentation/providers/device_info_providers.dart';
import 'core/presentation/providers/splash_providers.dart';
import 'core/presentation/routing/app_router.dart';
import 'core/presentation/routing/navigation_service.dart';
import 'core/presentation/screens/splash_screen/splash_screen.dart';
import 'core/presentation/utils/riverpod_framework.dart';
import 'core/presentation/utils/scroll_behaviors.dart';
import 'l10n/app_localizations.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    useOnPlatformBrightnessChange((previous, current) {
      ref.read(platformBrightnessProvider.notifier).update((_) => current);
    });
    final supportsEdgeToEdge =
        ref.watch(androidDeviceInfoProvider).supportsEdgeToEdge;
    final themeMode = ref.watch(currentAppThemeModeProvider);
    final locale = ref.watch(currentAppLocaleProvider);

    return MaterialApp.router(
      routerConfig: router,
      restorationScopeId: 'app',
      builder: (context, child) {
        final warmupState = ref.watch(splashServicesWarmupProvider);
        if (warmupState.isLoading ||
            (!warmupState.hasValue && !warmupState.hasError)) {
          const splash = SplashScreen();
          return splash;
        }

        return ScrollConfiguration(
          behavior: MainScrollBehavior(),
          child: GestureDetector(
            onTap: NavigationService.removeFocus,
            child: child,
          ),
        );
      },
      title: 'Deliverzler',
      debugShowCheckedModeBanner: false,
      color: Theme.of(context).colorScheme.primary,
      theme: themeMode.getThemeData(
        locale.fontFamily,
        supportsEdgeToEdge: supportsEdgeToEdge,
      ),
      locale: Locale(locale.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
// ignore: eol_at_end_of_file
}
