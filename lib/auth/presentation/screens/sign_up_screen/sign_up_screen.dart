import 'package:flutter/material.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../providers/sign_up_provider.dart';
import '../../components/signup_form_component.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.easyListen(signUpStateProvider);
    return FullScreenScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                const SignupFormComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
