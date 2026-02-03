import 'package:flutter/material.dart';

import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/styles/styles.dart';

class ExcuseSubmissionDialog extends StatelessWidget {
  const ExcuseSubmissionDialog(
      {required this.excuseReasonController, super.key});

  final TextEditingController excuseReasonController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: Sizes.dialogWidth280,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tr(context).reasonForRejection}:',
            style: TextStyles.f16(context),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: Sizes.marginV12,
          ),
          Material(
            color: Colors.transparent,
            child: TextFormField(
              key: const ValueKey('excuse_reason'),
              controller: excuseReasonController,
              decoration: InputDecoration(
                filled: false,
                hintText: '${tr(context).typeYourReason}...',
              ),
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 8,
              maxLength: 300,
              autofocus: true,
            ),
          ),
          const SizedBox(
            height: Sizes.marginV8,
          ),
          Text(
            tr(context).excuseSubmissionNote,
            style: TextStyles.f12(context).copyWith(
              color: Theme.of(context).colorScheme.error.withOpacity(0.7),
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
