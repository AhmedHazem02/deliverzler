import 'package:flutter/material.dart';

import '../../../../../core/presentation/screens/nested_screen_scaffold.dart';
import '../../components/edit_driver_profile_form_component.dart';

class ProfileScreenCompact extends StatelessWidget {
  const ProfileScreenCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return const NestedScreenScaffold(
      body: EditDriverProfileFormComponent(),
    );
  }
}
