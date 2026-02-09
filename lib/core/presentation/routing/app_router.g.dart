// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $splashRoute,
      $noInternetRoute,
      $signInRoute,
      $signUpRoute,
      $forgotPasswordRoute,
      $forgotPasswordMethodRoute,
      $forgotPasswordPhoneRoute,
      $emailVerificationRoute,
      $phoneVerificationRoute,
      $verificationMethodRoute,
      $homeShellRouteData,
      $applicationStatusGateRoute,
      $driverApplicationRoute,
      $pendingApprovalRoute,
    ];

RouteBase get $splashRoute => GoRouteData.$route(
      path: '/splash',
      factory: $SplashRouteExtension._fromState,
    );

extension $SplashRouteExtension on SplashRoute {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  String get location => GoRouteData.$location(
        '/splash',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $noInternetRoute => GoRouteData.$route(
      path: '/no_internet',
      factory: $NoInternetRouteExtension._fromState,
    );

extension $NoInternetRouteExtension on NoInternetRoute {
  static NoInternetRoute _fromState(GoRouterState state) =>
      const NoInternetRoute();

  String get location => GoRouteData.$location(
        '/no_internet',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
      path: '/login',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signUpRoute => GoRouteData.$route(
      path: '/signup',
      factory: $SignUpRouteExtension._fromState,
    );

extension $SignUpRouteExtension on SignUpRoute {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  String get location => GoRouteData.$location(
        '/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
      path: '/forgot-password',
      factory: $ForgotPasswordRouteExtension._fromState,
    );

extension $ForgotPasswordRouteExtension on ForgotPasswordRoute {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  String get location => GoRouteData.$location(
        '/forgot-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordMethodRoute => GoRouteData.$route(
      path: '/forgot-password-method',
      factory: $ForgotPasswordMethodRouteExtension._fromState,
    );

extension $ForgotPasswordMethodRouteExtension on ForgotPasswordMethodRoute {
  static ForgotPasswordMethodRoute _fromState(GoRouterState state) =>
      const ForgotPasswordMethodRoute();

  String get location => GoRouteData.$location(
        '/forgot-password-method',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordPhoneRoute => GoRouteData.$route(
      path: '/forgot-password-phone',
      factory: $ForgotPasswordPhoneRouteExtension._fromState,
    );

extension $ForgotPasswordPhoneRouteExtension on ForgotPasswordPhoneRoute {
  static ForgotPasswordPhoneRoute _fromState(GoRouterState state) =>
      const ForgotPasswordPhoneRoute();

  String get location => GoRouteData.$location(
        '/forgot-password-phone',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $emailVerificationRoute => GoRouteData.$route(
      path: '/verify-email/:email',
      factory: $EmailVerificationRouteExtension._fromState,
    );

extension $EmailVerificationRouteExtension on EmailVerificationRoute {
  static EmailVerificationRoute _fromState(GoRouterState state) =>
      EmailVerificationRoute(
        email: state.pathParameters['email']!,
      );

  String get location => GoRouteData.$location(
        '/verify-email/${Uri.encodeComponent(email)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $phoneVerificationRoute => GoRouteData.$route(
      path: '/verify-phone/:phone',
      factory: $PhoneVerificationRouteExtension._fromState,
    );

extension $PhoneVerificationRouteExtension on PhoneVerificationRoute {
  static PhoneVerificationRoute _fromState(GoRouterState state) =>
      PhoneVerificationRoute(
        phone: state.pathParameters['phone']!,
      );

  String get location => GoRouteData.$location(
        '/verify-phone/${Uri.encodeComponent(phone)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verificationMethodRoute => GoRouteData.$route(
      path: '/choose-verification/:email/:phone/:uid',
      factory: $VerificationMethodRouteExtension._fromState,
    );

extension $VerificationMethodRouteExtension on VerificationMethodRoute {
  static VerificationMethodRoute _fromState(GoRouterState state) =>
      VerificationMethodRoute(
        email: state.pathParameters['email']!,
        phone: state.pathParameters['phone']!,
        uid: state.pathParameters['uid']!,
      );

  String get location => GoRouteData.$location(
        '/choose-verification/${Uri.encodeComponent(email)}/${Uri.encodeComponent(phone)}/${Uri.encodeComponent(uid)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeShellRouteData => StatefulShellRouteData.$route(
      restorationScopeId: HomeShellRouteData.$restorationScopeId,
      factory: $HomeShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          restorationScopeId: HomeBranchData.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomeRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'map',
                  factory: $MapRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          restorationScopeId: MyOrdersBranchData.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/my-orders',
              factory: $MyOrdersRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          restorationScopeId: ProfileBranchData.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/profile',
              factory: $ProfileRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          restorationScopeId: SettingsBranchData.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/settings',
              factory: $SettingsRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'language',
                  factory: $LanguageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $HomeShellRouteDataExtension on HomeShellRouteData {
  static HomeShellRouteData _fromState(GoRouterState state) =>
      const HomeShellRouteData();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MapRouteExtension on MapRoute {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  String get location => GoRouteData.$location(
        '/home/map',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyOrdersRouteExtension on MyOrdersRoute {
  static MyOrdersRoute _fromState(GoRouterState state) => const MyOrdersRoute();

  String get location => GoRouteData.$location(
        '/my-orders',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LanguageRouteExtension on LanguageRoute {
  static LanguageRoute _fromState(GoRouterState state) => const LanguageRoute();

  String get location => GoRouteData.$location(
        '/settings/language',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $applicationStatusGateRoute => GoRouteData.$route(
      path: '/status-gate',
      factory: $ApplicationStatusGateRouteExtension._fromState,
    );

extension $ApplicationStatusGateRouteExtension on ApplicationStatusGateRoute {
  static ApplicationStatusGateRoute _fromState(GoRouterState state) =>
      const ApplicationStatusGateRoute();

  String get location => GoRouteData.$location(
        '/status-gate',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $driverApplicationRoute => GoRouteData.$route(
      path: '/driver-application/:userId',
      factory: $DriverApplicationRouteExtension._fromState,
    );

extension $DriverApplicationRouteExtension on DriverApplicationRoute {
  static DriverApplicationRoute _fromState(GoRouterState state) =>
      DriverApplicationRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/driver-application/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pendingApprovalRoute => GoRouteData.$route(
      path: '/pending-approval/:userId',
      factory: $PendingApprovalRouteExtension._fromState,
    );

extension $PendingApprovalRouteExtension on PendingApprovalRoute {
  static PendingApprovalRoute _fromState(GoRouterState state) =>
      PendingApprovalRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/pending-approval/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goRouterHash() => r'cccfb92e26c33084865bd49527f833f1f3bbc590';

/// See also [goRouter].
@ProviderFor(goRouter)
final goRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  goRouter,
  name: r'goRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoRouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
