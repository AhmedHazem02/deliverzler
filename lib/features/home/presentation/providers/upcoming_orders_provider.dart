import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../infrastructure/repos/orders_repo.dart';

part 'upcoming_orders_provider.g.dart';

@riverpod
Stream<List<AppOrder>> upcomingOrders(Ref ref) {
  debugPrint('🔍 upcomingOrders provider called');
  try {
    final user = ref.watch(currentUserProvider);
    final userId = user.id;
    debugPrint('👤 Current User Full Details:');
    debugPrint('   - ID: $userId');
    debugPrint('   - Name: ${user.name}');
    debugPrint('   - Email: ${user.email}');
    debugPrint('   - Phone: ${user.phone}');
    
    final ordersStream =
        ref.watch(ordersRepoProvider).getUpcomingOrders(userId);
    return ordersStream.map((orders) {
      debugPrint('📊 Orders stream emitted: ${orders.length} orders');
      return orders;
    }).distinct((previous, next) {
      //Compare prev,next streams by deep equals and skip if they're not equal,
      //while ignoring deliveryGeoPoint in Order entity's equality implementation.
      //This avoid updating the stream when the delivery updates his own deliveryGeoPoint
      //which will lead to unnecessary api calls.
      return previous.lock == next.lock;
    });
  } catch (e, st) {
    debugPrint('❌ Error in upcomingOrders provider: $e');
    debugPrint('Stack: $st');
    rethrow;
  }
}

