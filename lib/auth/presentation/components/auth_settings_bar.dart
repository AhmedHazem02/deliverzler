import 'package:flutter/material.dart';

import '../../../core/core_features/locale/presentation/providers/app_locale_provider.dart';
import '../../../core/core_features/locale/presentation/providers/current_app_locale_provider.dart';
import '../../../core/core_features/locale/presentation/utils/app_locale.dart';
import '../../../core/core_features/theme/presentation/providers/app_theme_provider.dart';
import '../../../core/core_features/theme/presentation/providers/current_app_theme_provider.dart';
import '../../../core/core_features/theme/presentation/utils/app_theme.dart';
import '../../../core/presentation/helpers/localization_helper.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';

/// A row of quick settings toggles for theme and language.
/// Can be used in auth screens (login, signup) for easy access.
class AuthSettingsBar extends ConsumerWidget {
  const AuthSettingsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(currentAppThemeModeProvider);
    final currentLocale = ref.watch(currentAppLocaleProvider);
    final isDark = currentTheme == AppThemeMode.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Theme toggle
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Theme button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    final newTheme =
                        isDark ? AppThemeMode.light : AppThemeMode.dark;
                    ref
                        .read(appThemeControllerProvider.notifier)
                        .changeTheme(newTheme);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          size: 20,
                          color: isDark ? Colors.amber : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDark ? tr(context).darkTheme : tr(context).lightTheme,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.withOpacity(0.3),
              ),
              // Language button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    // Toggle between Arabic and English
                    final newLocale = currentLocale == AppLocale.arabic
                        ? AppLocale.english
                        : AppLocale.arabic;
                    ref
                        .read(appLocaleControllerProvider.notifier)
                        .changeLocale(newLocale);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.translate,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          currentLocale.code.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
