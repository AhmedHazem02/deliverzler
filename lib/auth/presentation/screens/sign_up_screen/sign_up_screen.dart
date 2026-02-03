import 'package:flutter/material.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../providers/sign_up_provider.dart';
import 'desktop_signup_layout.dart';
import 'mobile_signup_layout.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    // Precache background image for smoother loading on desktop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/login/login_background.png'),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.easyListen(signUpStateProvider);
    return FullScreenScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return const DesktopSignupLayout();
            } else {
              return const MobileSignupLayout();
            }
          },
        ),
      ),
    );
  }
}
