import 'package:flutter/material.dart';

import '../../../core/presentation/helpers/localization_helper.dart';
import '../../../core/presentation/styles/styles.dart';
import '../../../core/presentation/routing/app_router.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../core/presentation/widgets/platform_widgets/platform_icons.dart';
import '../../domain/sign_in_with_email.dart';
import '../providers/sign_in_provider.dart';
import '../../../core/presentation/extensions/app_error_extension.dart';

class LoginFormComponent extends HookConsumerWidget {
  const LoginFormComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final isPasswordVisible = useState(false);
    final errorMessage = useState<String?>(null);

    ref.listen(signInStateProvider, (previous, next) {
      next.when(
        data: (_) {
          errorMessage.value = null;
        },
        loading: () {
          errorMessage.value = null;
        },
        error: (error, stackTrace) {
          errorMessage.value = error.errorMessage(context);
        },
      );
    });

    void signIn() {
      if (loginFormKey.currentState!.validate()) {
        final params = SignInWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );
        ref.read(signInStateProvider.notifier).signIn(params);
      }
    }

    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          if (errorMessage.value != null)
            Container(
              margin: const EdgeInsets.only(bottom: Sizes.marginV16),
              padding: const EdgeInsets.all(Sizes.marginV12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                errorMessage.value!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            ),
          TextFormField(
            key: const ValueKey('login_email'),
            controller: emailController,
            decoration: InputDecoration(
              hintText: tr(context).email,
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: Theme.of(context)
                          .inputDecorationTheme
                          .contentPadding!
                          .horizontal /
                      2,
                ),
                child: Icon(AppPlatformIcons.platformIcons(context).mail),
              ),
              suffixIconConstraints: const BoxConstraints(),
            ),
            validator: SignInWithEmail.validateEmail(context),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: Sizes.marginV24,
          ),
          TextFormField(
            key: const ValueKey('login_password'),
            controller: passwordController,
            decoration: InputDecoration(
              hintText: tr(context).password,
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: Theme.of(context)
                          .inputDecorationTheme
                          .contentPadding!
                          .horizontal /
                      2,
                ),
                child: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ),
              ),
              suffixIconConstraints: const BoxConstraints(),
            ),
            validator: SignInWithEmail.validatePassword(context),
            textInputAction: TextInputAction.go,
            obscureText: !isPasswordVisible.value,
            onFieldSubmitted:
                ref.isLoading(signInStateProvider) ? null : (_) => signIn(),
          ),
          const SizedBox(
            height: Sizes.marginV12,
          ),

          // Forgot Password Button
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => const ForgotPasswordMethodRoute().go(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                tr(context).forgotPassword,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          const SizedBox(
            height: Sizes.marginV24,
          ),
          CustomElevatedButton(
            enableGradient: true,
            onPressed: ref.isLoading(signInStateProvider) ? null : signIn,
            child: Text(
              tr(context).signIn.toUpperCase(),
              style: TextStyles.coloredElevatedButton(context),
            ),
          ),
          const SizedBox(height: Sizes.marginV12),
          TextButton(
            onPressed: () => const SignUpRoute().go(context),
            child: Text(tr(context).dontHaveAnAccount),
          ),
        ],
      ),
    );
  }
}
