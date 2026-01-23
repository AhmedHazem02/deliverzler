part of '../app_router.dart';

@TypedGoRoute<ApplicationStatusGateRoute>(path: '/status-gate')
class ApplicationStatusGateRoute extends GoRouteData {
  const ApplicationStatusGateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ApplicationStatusGate();
}

@TypedGoRoute<DriverApplicationRoute>(path: '/driver-application/:userId')
class DriverApplicationRoute extends GoRouteData {
  const DriverApplicationRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DriverApplicationScreen(userId: userId);
}

@TypedGoRoute<PendingApprovalRoute>(path: '/pending-approval/:userId')
class PendingApprovalRoute extends GoRouteData {
  const PendingApprovalRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PendingApprovalScreen(userId: userId);
}
