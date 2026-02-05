import 'package:flutter/material.dart';


import '../../../core/presentation/helpers/localization_helper.dart';
import '../../../core/presentation/styles/styles.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../presentation/providers/sign_up_provider.dart';
import '../../../core/infrastructure/error/app_exception.dart';
import '../../../core/presentation/extensions/app_error_extension.dart';
import '../../domain/sign_in_with_email.dart';

class SignupFormComponent extends HookConsumerWidget {
  const SignupFormComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController(text: '');
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final errorMessage = useState<String?>('');

    final isPasswordVisible = useState(false);

    ref.listen(
      signUpStateProvider,
      (previous, next) {
        next.when(
          data: (_) {
            errorMessage.value = '';
          },
          loading: () {},
          error: (error, stackTrace) {
            errorMessage.value = error.errorMessage(context);
          },
        );
      },
    );

    void signUp() {
      if (formKey.currentState!.validate()) {
        errorMessage.value = '';
        ref.read(signUpStateProvider.notifier).signUp(
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
            );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          if (errorMessage.value != null && errorMessage.value!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: Sizes.marginV16),
              padding: const EdgeInsets.all(Sizes.marginV12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                errorMessage.value ?? '',
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(hintText: tr(context).name),
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter a name' : null,
            textInputAction: TextInputAction.next,
            enabled: !ref.isLoading(signUpStateProvider),
          ),
          const SizedBox(height: Sizes.marginV16),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: tr(context).email),
            validator: SignInWithEmail.validateEmail(context),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            enabled: !ref.isLoading(signUpStateProvider),
          ),
          const SizedBox(height: Sizes.marginV16),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: tr(context).password,
              suffixIcon: IconButton(
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
            validator: SignInWithEmail.validatePassword(context),
            obscureText: !isPasswordVisible.value,
            textInputAction: TextInputAction.go,
            onFieldSubmitted:
                ref.isLoading(signUpStateProvider) ? null : (_) => signUp(),
            enabled: !ref.isLoading(signUpStateProvider),
          ),
          const SizedBox(height: Sizes.marginV24),
          CustomElevatedButton(
            onPressed: ref.isLoading(signUpStateProvider) ? null : signUp,
            child: Text(
              ref.isLoading(signUpStateProvider)
                  ? 'Creating account...'
                  : tr(context).signIn,
            ),
          ),
        ],
      ),
    );
  }
}


