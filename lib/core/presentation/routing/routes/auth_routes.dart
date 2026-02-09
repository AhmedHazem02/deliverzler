part of '../app_router.dart';

@TypedGoRoute<SignInRoute>(path: '/login')
class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(state.pageKey, const SignInScreen());
}

@TypedGoRoute<SignUpRoute>(path: '/signup')
class SignUpRoute extends GoRouteData {
  const SignUpRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(state.pageKey, const SignUpScreen());
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData {
  const ForgotPasswordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(state.pageKey, const ForgotPasswordScreen());
}

@TypedGoRoute<ForgotPasswordMethodRoute>(path: '/forgot-password-method')
class ForgotPasswordMethodRoute extends GoRouteData {
  const ForgotPasswordMethodRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(
          state.pageKey, const ForgotPasswordMethodScreen());
}

@TypedGoRoute<ForgotPasswordPhoneRoute>(path: '/forgot-password-phone')
class ForgotPasswordPhoneRoute extends GoRouteData {
  const ForgotPasswordPhoneRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(
          state.pageKey, const ForgotPasswordPhoneScreen());
}

@TypedGoRoute<EmailVerificationRoute>(path: '/verify-email/:email')
class EmailVerificationRoute extends GoRouteData {
  const EmailVerificationRoute({required this.email});

  final String email;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(state.pageKey, EmailVerificationScreen(email: email));
}

@TypedGoRoute<PhoneVerificationRoute>(path: '/verify-phone/:phone')
class PhoneVerificationRoute extends GoRouteData {
  const PhoneVerificationRoute({required this.phone});

  final String phone;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(state.pageKey, PhoneVerificationScreen(phone: phone));
}

@TypedGoRoute<VerificationMethodRoute>(
    path: '/choose-verification/:email/:phone/:uid')
class VerificationMethodRoute extends GoRouteData {
  const VerificationMethodRoute({
    required this.email,
    required this.phone,
    required this.uid,
  });

  final String email;
  final String phone;
  final String uid;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      FadeTransitionPage(
        state.pageKey,
        VerificationMethodScreen(email: email, phone: phone, uid: uid),
      );
}
