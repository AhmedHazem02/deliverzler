import 'package:flutter/material.dart';

import '../../../core/presentation/helpers/localization_helper.dart';
import '../../../core/presentation/routing/app_router.dart';
import '../../../core/presentation/styles/styles.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../core/presentation/widgets/platform_widgets/platform_icons.dart';
import '../../domain/sign_in_with_email.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordFormComponent extends HookConsumerWidget {
  const ForgotPasswordFormComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    final successMessage = useState<String?>(null);

    // Listen to provider state for cooldown timer
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final notifier = ref.watch(forgotPasswordProvider.notifier);

    // Auto-update timer
    useEffect(
      () {
        if (notifier.secondsRemaining > 0) {
          final timer =
              Stream<int>.periodic(const Duration(seconds: 1), (i) => i).listen((_) {
            // Force rebuild every second while cooldown is active
            if (notifier.secondsRemaining <= 0) {
              ref.invalidate(forgotPasswordProvider);
            }
          });
          return timer.cancel;
        }
        return null;
      },
      [forgotPasswordState.lastSentTime],
    );

    Future<void> sendResetEmail() async {
      errorMessage.value = null;
      successMessage.value = null;

      if (formKey.currentState!.validate()) {
        final result =
            await notifier.sendPasswordResetEmail(emailController.text);

        result.fold(
          (failure) {
            failure.when(
              userNotFound: () =>
                  errorMessage.value = tr(context).authUserNotFoundError,
              invalidEmail: () =>
                  errorMessage.value = tr(context).authInvalidEmailError,
              tooManyRequests: () =>
                  errorMessage.value = tr(context).tooManyRequestsError,
              networkError: () =>
                  errorMessage.value = tr(context).noInternetError,
              serverError: (message) =>
                  errorMessage.value = message ?? tr(context).unknownError,
              emailAlreadyInUse: () =>
                  errorMessage.value = tr(context).authEmailAlreadyInUseError,
              wrongPassword: () =>
                  errorMessage.value = tr(context).authWrongPasswordError,
              emailNotVerified: () =>
                  errorMessage.value = tr(context).emailVerificationRequired,
              userDisabled: () =>
                  errorMessage.value = tr(context).authUserDisabledError,
              invalidPhoneNumber: () =>
                  errorMessage.value = tr(context).unknownError,
              invalidVerificationCode: () =>
                  errorMessage.value = tr(context).unknownError,
              smsQuotaExceeded: () =>
                  errorMessage.value = tr(context).unknownError,
              phoneVerificationFailed: (message) =>
                  errorMessage.value = message ?? tr(context).unknownError,
              sessionExpired: () =>
                  errorMessage.value = tr(context).unknownError,
            );
          },
          (_) {
            successMessage.value = tr(context).passwordResetEmailSent;
          },
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success Message
          if (successMessage.value != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          successMessage.value!,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr(context).checkEmailForResetLink,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.marginV24),
          ],

          // Error Message
          if (errorMessage.value != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage.value!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.marginV24),
          ],

          // Email Field
          TextFormField(
            key: const ValueKey('forgot_password_email'),
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
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: notifier.canSend ? (_) => sendResetEmail() : null,
          ),

          const SizedBox(height: Sizes.marginV40),

          // Send Button
          CustomElevatedButton(
            enableGradient: true,
            onPressed: notifier.canSend ? sendResetEmail : null,
            child: notifier.secondsRemaining > 0
                ? Text(
                    '${tr(context).resendIn} ${notifier.secondsRemaining} ${tr(context).seconds}',
                    style: TextStyles.coloredElevatedButton(context),
                  )
                : Text(
                    tr(context).sendResetLink.toUpperCase(),
                    style: TextStyles.coloredElevatedButton(context),
                  ),
          ),

          const SizedBox(height: Sizes.marginV12),

          // Back to Sign In Button
          TextButton(
            onPressed: () => const SignInRoute().go(context),
            child: Text(tr(context).backToSignIn),
          ),
        ],
      ),
    );
  }
}
