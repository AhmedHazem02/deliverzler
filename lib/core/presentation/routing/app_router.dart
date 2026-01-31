import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../auth/domain/email_not_verified_exception.dart';
import '../../../auth/domain/user.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../auth/presentation/providers/check_auth_provider.dart';
import '../../../auth/presentation/screens/email_verification_screen/email_verification_screen.dart';
import '../../../auth/presentation/screens/forgot_password_screen/forgot_password_screen.dart';
import '../../../auth/presentation/screens/sign_in_screen/sign_in_screen.dart';
import '../../../auth/presentation/screens/sign_up_screen/sign_up_screen.dart';
import '../../../features/home/presentation/screens/home_screen/home_screen.dart';
import '../../../features/home/presentation/screens/my_orders_screen/my_orders_screen.dart';
import '../../../features/home_shell/presentation/screens/home_shell_screen.dart';
import '../../../features/map/presentation/screens/map_screen/map_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen/profile_screen.dart';
import '../../../features/settings/presentation/screens/language_screen/language_screen.dart';
import '../../../features/settings/presentation/screens/settings_screen/settings_screen.dart';
import '../../../features/driver_application/presentation/screens/application_status_gate.dart';
import '../../../features/driver_application/presentation/screens/driver_application_screen.dart';
import '../../../features/driver_application/presentation/screens/pending_approval_screen.dart';
import '../providers/splash_providers.dart';
import '../screens/no_internet_screen/no_internet_screen.dart';
import '../screens/route_error_screen/route_error_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../utils/fp_framework.dart';
import '../utils/riverpod_framework.dart';
import 'navigation_transitions.dart';

part 'app_router.g.dart';

part 'route_authority.dart';
part 'route_extensions.dart';
part 'routes/core_routes.dart';
part 'routes/auth_routes.dart';
part 'routes/home_shell_route.dart';
part 'routes/home_branch_routes.dart';
part 'routes/profile_branch_routes.dart';
part 'routes/settings_branch_routes.dart';
part 'routes/driver_application_routes.dart';

// This or other ShellRoutes keys can be used to display a child route on a different Navigator.
// i.e: use the rootNavigatorKey for a child route inside a ShellRoute
// which need to take the full screen and ignore that Shell.
// https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html
final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final listenable = ValueNotifier<int>(0);

  // Listen to auth state, warmup state, AND checkAuth state
  ref.listen(
    authStateProvider.select((user) => user.isSome()),
    (_, __) => listenable.value++,
  );

  ref.listen(
    splashServicesWarmupProvider,
    (_, __) => listenable.value++,
  );

  ref.listen(
    checkAuthProvider,
    (_, __) => listenable.value++,
  );

  final router = GoRouter(
    debugLogDiagnostics: true,
    restorationScopeId: 'router',
    navigatorKey: _rootNavigatorKey,
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
    redirect: (BuildContext context, GoRouterState state) {
      final warmupState = ref.read(splashServicesWarmupProvider);
      final authState = ref.read(authStateProvider);

      // Check for EmailNotVerifiedException
      final checkAuthState = ref.read(checkAuthProvider);
      if (checkAuthState.hasError &&
          checkAuthState.error is EmailNotVerifiedException) {
        final exception = checkAuthState.error as EmailNotVerifiedException;
        final email = exception.email ?? '';
        // Redirect to verification screen if we have an email
        if (email.isNotEmpty &&
            state.matchedLocation !=
                EmailVerificationRoute(email: email).location) {
          return EmailVerificationRoute(email: email).location;
        }
      }

      // CRITICAL: Stay at current location until warmup is FULLY complete
      // This includes waiting for checkAuth to finish updating authState
      if (warmupState.isLoading) {
        return null;
      }

      // If warmup hasn't started yet (no value and no error), stay put
      if (!warmupState.hasValue && !warmupState.hasError) {
        return null;
      }

      // If warmup completed successfully but we're still at splash, wait a bit more
      // This gives checkAuth time to update authState
      if (warmupState.hasValue &&
          state.matchedLocation == const SplashRoute().location &&
          authState.isNone()) {
        // Check if checkAuth is still running
        final checkAuthState = ref.read(checkAuthProvider);
        if (checkAuthState.isLoading) {
          return null;
        }
      }

      // If warmup failed, check if we're already at splash
      if (warmupState.hasError &&
          state.matchedLocation != const SplashRoute().location) {
        // Let error handling happen naturally - don't redirect yet
        // The error might be temporary (network issue, etc)
      }

      final routeAuthority = state.routeAuthority;
      final isLegitRoute =
          routeAuthority.contains(RouteAuthority.fromAuthState(authState));

      // If warmed up and at splash, redirect to home/login
      if (state.matchedLocation == const SplashRoute().location) {
        return authState.match(
          () => const SignInRoute().location,
          (user) => const ApplicationStatusGateRoute().location,
        );
      }

      if (!isLegitRoute) {
        return switch (authState) {
          Some() => const ApplicationStatusGateRoute().location,
          None() => const SignInRoute().location,
        };
      }

      // Return null (no redirecting) if the user is at or heading to a legit route.
      return null;
    },
    refreshListenable: listenable,
    errorBuilder: (_, state) => RouteErrorScreen(state.error),
  );

  ref.onDispose(() {
    listenable.dispose();
    router.dispose();
  });

  return router;
}
