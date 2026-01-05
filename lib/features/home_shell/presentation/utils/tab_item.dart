import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/widgets/platform_widgets/platform_icons.dart';

enum TabItem {
  home,
  myOrders,
  profile,
  settings;

  const TabItem();

  Widget getTabItemIcon(BuildContext context) {
    return _getTabIcon(context, _getTabIconData(context));
  }

  Widget getTabItemSelectedIcon(BuildContext context) {
    return _getTabIcon(context, _getTabIconData(context), isSelected: true);
  }

  IconData _getTabIconData(BuildContext context) {
    return switch (this) {
      TabItem.home => AppPlatformIcons.platformIcons(context).home,
      TabItem.myOrders => Icons.list_alt,
      TabItem.profile => AppPlatformIcons.platformIcons(context).accountCircleSolid,
      TabItem.settings => AppPlatformIcons.platformIcons(context).settingsSolid,
    };
  }

  Widget _getTabIcon(
    BuildContext context,
    IconData? icon, {
    bool isSelected = false,
  }) {
    return Icon(
      icon,
      size: Sizes.navBarIconR22,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
    );
  }

  String getTabItemLabel(BuildContext context) {
    return switch (this) {
      TabItem.home => tr(context).home,
      TabItem.myOrders => tr(context).myOrders,
      TabItem.profile => tr(context).myProfile,
      TabItem.settings => tr(context).settings,
    };
  }
}
