part of 'app_router.dart';

extension GoRouterStateX on GoRouterState {
  // TODO(AHMED): Use routeLocation when https://github.com/flutter/flutter/issues/125752 is fixed?
  String get routeLocation => uri.toString();

  List<RouteAuthority> get routeAuthority {
    const defaultAuthority = [RouteAuthority.user, RouteAuthority.admin];

    final publicRoutes = [
      const SplashRoute().location,
      const NoInternetRoute().location,
    ];
    if (publicRoutes.any(routeLocation.startsWith)) {
      return RouteAuthority.values;
    }

    if (routeLocation.startsWith('/login') ||
        routeLocation.startsWith('/signup') ||
        routeLocation.startsWith('/forgot-password') ||
        routeLocation.startsWith('/verify-email')) {
      return const [RouteAuthority.unauthenticated];
    }

    // Application status routes - accessible by authenticated users
    if (routeLocation.startsWith('/status-gate') ||
        routeLocation.startsWith('/driver-application') ||
        routeLocation.startsWith('/pending-approval')) {
      return defaultAuthority;
    }

    final homeRoutes = [
      const HomeRoute().location,
      const MyOrdersRoute().location,
      const ProfileRoute().location,
      const SettingsRoute().location,
    ];

    if (homeRoutes.any(routeLocation.startsWith)) {
      return defaultAuthority;
    }

    throw UnimplementedError('Route $uri has not set routeAuthority.');
  }
}
