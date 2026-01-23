import 'package:flutter/material.dart';

import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../gen/my_assets.dart';
import '../../components/auth_settings_bar.dart';
import '../../components/login_content_component.dart';
import '../../components/login_logo_component.dart';

class SignInScreenCompact extends StatelessWidget {
  const SignInScreenCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenScaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    MyAssets.ASSETS_IMAGES_LOGIN_LOGIN_BACKGROUND_PNG,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.screenPaddingV16,
                  horizontal: Sizes.screenPaddingH28,
                ),
                child: Column(
                  children: [
                    // Settings bar (Theme & Language)
                    const AuthSettingsBar(),
                    const Flexible(
                      child: LoginLogoComponent(),
                    ),
                    const SizedBox(
                      height: Sizes.marginV12,
                    ),
                    const Flexible(
                      flex: 2,
                      child: LoginContentComponent(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
