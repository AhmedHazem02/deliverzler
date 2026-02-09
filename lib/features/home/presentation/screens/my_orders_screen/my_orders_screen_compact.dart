import 'package:flutter/material.dart';

import '../../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../components/my_orders_component.dart';

class MyOrdersScreenCompact extends HookConsumerWidget {
  const MyOrdersScreenCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context).myOrders),
        centerTitle: true,
      ),
      body: const MyOrdersComponent(),
    );
  }
}
