import 'package:flutter/material.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/responsive_widgets/responsive_layouts.dart';
import 'forgot_password_screen_compact.dart';
import 'forgot_password_screen_medium.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WindowClassLayout(
      compact: (_) => OrientationLayout(
        portrait: (_) => const ForgotPasswordScreenCompact(),
      ),
      medium: (_) => OrientationLayout(
        portrait: (_) => const ForgotPasswordScreenMedium(),
      ),
    );
  }
}
