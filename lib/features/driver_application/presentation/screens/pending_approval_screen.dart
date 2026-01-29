import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/presentation/providers/sign_in_provider.dart';
import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../domain/driver_application.dart';
import '../providers/driver_application_provider.dart';

class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for status changes to redirect approved users to Home
    ref.listen(driverApplicationStreamProvider(userId), (previous, next) {
      if (next.hasValue && next.value?.status == ApplicationStatus.approved) {
        context.go(const HomeRoute().location);
      }
    });

    final applicationAsync = ref.watch(driverApplicationStreamProvider(userId));

    return FullScreenScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.marginV24),
          child: applicationAsync.when(
            data: (DriverApplication? application) {
              if (application == null) {
                return _buildNoApplicationView(context, ref);
              }
              // If approved, show a success message and button to go home (in case auto-redirect didn't happen yet)
              if (application.status == ApplicationStatus.approved) {
                 return _buildApprovedView(context, ref);
              }
              return _buildStatusView(context, ref, application);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, _) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApprovedView(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: Sizes.marginV24),
          Text(
             tr(context).applicationApproved,
             style: Theme.of(context).textTheme.headlineSmall,
             textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.marginV16),
          Text(
             tr(context).applicationApprovedMessage,
             textAlign: TextAlign.center,
             style: const TextStyle(color: Colors.grey),
          ),
           const SizedBox(height: Sizes.marginV32),
           CustomElevatedButton(
            onPressed: () {
              context.go(const HomeRoute().location);
            },
            child: Text(tr(context).continue2),
           ),
        ],
      ),
    );
  }

  Widget _buildNoApplicationView(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: Sizes.marginV24),
          Text(
            tr(context).noApplicationFound,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.marginV16),
          Text(
            tr(context).submitApplicationToJoin,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.marginV32),
          CustomElevatedButton(
            onPressed: () {
               context.go(DriverApplicationRoute(userId: userId).location);
            },
            child: Text(tr(context).submitApplication),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusView(
    BuildContext context,
    WidgetRef ref,
    DriverApplication application,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIcon(application.status),
            const SizedBox(height: Sizes.marginV24),
            Text(
              _getStatusTitle(context, application.status),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.marginV16),
            Text(
              _getStatusMessage(context, application.status),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (application.status == ApplicationStatus.rejected &&
                application.rejectionReason != null) ...[
              const SizedBox(height: Sizes.marginV16),
              Container(
                padding: const EdgeInsets.all(Sizes.marginV16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      tr(context).rejectionReason,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: Sizes.marginV8),
                    Text(
                      application.rejectionReason!,
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: Sizes.marginV32),
            if (application.status == ApplicationStatus.rejected)
              CustomElevatedButton(
                onPressed: () {
                   context.go(DriverApplicationRoute(userId: userId).location);
                },
                child: Text(tr(context).resubmitApplication),
              ),
            const SizedBox(height: Sizes.marginV16),
            TextButton.icon(
              onPressed: () {
                ref.read(signInStateProvider.notifier).logOut();
              },
              icon: const Icon(Icons.logout),
              label: Text(tr(context).signOut),
            ),
            const SizedBox(height: Sizes.marginV24),
            // Application details card
            _buildApplicationDetailsCard(context, application),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.hourglass_empty,
            size: 60,
            color: Colors.orange.shade700,
          ),
        );
      case ApplicationStatus.underReview:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.rate_review,
            size: 60,
            color: Colors.blue.shade700,
          ),
        );
      case ApplicationStatus.approved:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 60,
            color: Colors.green.shade700,
          ),
        );
      case ApplicationStatus.rejected:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cancel,
            size: 60,
            color: Colors.red.shade700,
          ),
        );
    }
  }

  String _getStatusTitle(BuildContext context, ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return tr(context).applicationPending;
      case ApplicationStatus.underReview:
        return tr(context).applicationUnderReview;
      case ApplicationStatus.approved:
        return tr(context).applicationApproved;
      case ApplicationStatus.rejected:
        return tr(context).applicationRejected;
    }
  }

  String _getStatusMessage(BuildContext context, ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return tr(context).applicationPendingMessage;
      case ApplicationStatus.underReview:
        return tr(context).applicationUnderReviewMessage;
      case ApplicationStatus.approved:
        return tr(context).applicationApprovedMessage;
      case ApplicationStatus.rejected:
        return tr(context).applicationRejectedMessage;
    }
  }

  Widget _buildApplicationDetailsCard(
    BuildContext context,
    DriverApplication application,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.marginV16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(context).applicationDetails,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _DetailRow(
              label: tr(context).name,
              value: application.name,
            ),
            _DetailRow(
              label: tr(context).email,
              value: application.email,
            ),
            _DetailRow(
              label: tr(context).phone,
              value: application.phone,
            ),
            _DetailRow(
              label: tr(context).vehicleType,
              value: application.vehicleType.arabicName,
            ),
            _DetailRow(
              label: tr(context).vehiclePlate,
              value: application.vehiclePlate,
            ),
            _DetailRow(
              label: tr(context).submittedAt,
              value: _formatDate(application.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
