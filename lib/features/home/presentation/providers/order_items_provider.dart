import 'package:flutter/foundation.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order_item.dart';
import '../../infrastructure/repos/order_items_repo.dart';

part 'order_items_provider.g.dart';

/// Provider to fetch order items for a specific order
@riverpod
Future<List<OrderItem>> orderItems(Ref ref, String orderId) async {
  if (orderId.isEmpty) {
    debugPrint('⚠️ Empty orderId provided to orderItemsProvider');
    return [];
  }

  final repo = ref.watch(orderItemsRepoProvider);

  try {
    final items = await repo.getOrderItems(orderId);

    return items;
  } catch (e) {
    // Return empty list instead of rethrowing to avoid Flutter web diagnostics issues
    return [];
  }
}

/// Stream provider for real-time order items updates
@riverpod
Stream<List<OrderItem>> orderItemsStream(Ref ref, String orderId) {
  if (orderId.isEmpty) {
    return Stream.value([]);
  }

  final repo = ref.watch(orderItemsRepoProvider);

  return repo.streamOrderItems(orderId);
}
