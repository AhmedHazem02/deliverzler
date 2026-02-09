import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/driver_application.dart';
import '../providers/driver_application_provider.dart';

/// Screen that checks driver application status and redirects accordingly.
///
/// This screen is shown after successful authentication to determine
/// where the driver should be redirected based on their application status:
/// - No application → DriverApplicationScreen
/// - Pending/Under Review → PendingApprovalScreen
/// - Approved → HomeScreen
/// - Rejected → PendingApprovalScreen (to show rejection and allow resubmit)
class ApplicationStatusGate extends ConsumerWidget {
  const ApplicationStatusGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.fold(
      // Not authenticated - this shouldn't happen, redirect to sign in
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(const SignInRoute().location);
        });
        return const _LoadingView();
      },
      // Authenticated - check application status
      (user) {
        final applicationAsync =
            ref.watch(driverApplicationStreamProvider(user.id));

        return applicationAsync.when(
          data: (application) {
            // Schedule navigation after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateBasedOnStatus(context, user.id, application);
            });
            return const _LoadingView();
          },
          loading: () => const _LoadingView(),
          error: (error, stackTrace) {
            // If error occurs, treat it as no application and redirect to form
            debugPrint('ApplicationStatusGate error: $error');
            debugPrint('Stack trace: $stackTrace');

            // Schedule navigation to application form
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(DriverApplicationRoute(userId: user.id).location);
            });
            return const _LoadingView();
          },
        );
      },
    );
  }

  void _navigateBasedOnStatus(
    BuildContext context,
    String userId,
    DriverApplication? application,
  ) {
    if (application == null) {
      // No application - go to application form
      context.go(DriverApplicationRoute(userId: userId).location);
      return;
    }

    // Check completeness first - if status is pending but data is missing,
    // it's a new registration that needs to fill the form
    if (application.status.isPending && !application.isComplete) {
      context.go(DriverApplicationRoute(userId: userId).location);
      return;
    }

    switch (application.status) {
      case ApplicationStatus.approved:
        // Approved - only go to home if we are currently at the status gate or login related routes
        final location = GoRouterState.of(context).matchedLocation;

        final isStatusRoute = location == const SplashRoute().location ||
            location == const SignInRoute().location ||
            location == const SignUpRoute().location ||
            location == '/status-gate' ||
            location == '/pending-approval' ||
            location == '/driver-application';

        if (isStatusRoute) {
          context.go(const HomeRoute().location);
        } else {}
      case ApplicationStatus.pending:
      case ApplicationStatus.underReview:
        // Waiting for approval - show pending screen
        context.go(PendingApprovalRoute(userId: userId).location);
      case ApplicationStatus.rejected:
        // Rejected - show pending screen with rejection info
        context.go(PendingApprovalRoute(userId: userId).location);
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const FullScreenScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'جاري التحقق من حالة الحساب...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
