import 'package:flutter/foundation.dart';
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
      print('🔍 [StatusGate] No application found. Redirecting to form.');
      // No application - go to application form
      context.go(DriverApplicationRoute(userId: userId).location);
      return;
    }

    print('🔍 [StatusGate] Status: ${application.status}');
    print('🔍 [StatusGate] Is Complete: ${application.isComplete}');

    // Check completeness first - if status is pending but data is missing,
    // it's a new registration that needs to fill the form
    if (application.status.isPending && !application.isComplete) {
       print('🔍 [StatusGate] Status is pending but incomplete. Redirecting to form.');
       context.go(DriverApplicationRoute(userId: userId).location);
       return;
    }

    switch (application.status) {
      case ApplicationStatus.approved:
        print('🔍 [StatusGate] Status is APPROVED.');
        // Approved - only go to home if we are currently at the status gate or login related routes
        final location = GoRouterState.of(context).matchedLocation;
        print('🔍 [StatusGate] Current location: $location');
        
        final isStatusRoute = location == const SplashRoute().location ||
            location == const SignInRoute().location ||
            location == const SignUpRoute().location ||
            location == '/status-gate' ||
            location == '/pending-approval' ||
            location == '/driver-application';

        if (isStatusRoute) {
          print('🔍 [StatusGate] Redirecting to Home.');
          context.go(const HomeRoute().location);
        } else {
          print('🔍 [StatusGate] Already on a valid route.');
        }
      case ApplicationStatus.pending:
      case ApplicationStatus.underReview:
        print('🔍 [StatusGate] Status is Pending/UnderReview. Redirecting to Pending Screen.');
        // Waiting for approval - show pending screen
        context.go(PendingApprovalRoute(userId: userId).location);
      case ApplicationStatus.rejected:
        print('🔍 [StatusGate] Status is Rejected. Redirecting to Pending Screen (Rejection).');
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.error,
    required this.onRetry,
    required this.onContinue,
  });

  final String error;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return FullScreenScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'حدث خطأ أثناء التحقق من حالة الحساب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'تفاصيل الخطأ: $error',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: onContinue,
                    child: const Text('المتابعة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
