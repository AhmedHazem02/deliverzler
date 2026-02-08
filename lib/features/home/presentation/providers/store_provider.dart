import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/store.dart';

/// Manual provider (no codegen) to fetch a store document by id.
/// Stores are now embedded inside the `users` collection as a `store` map field.
final storeProvider =
    FutureProvider.family<AppStore?, String>((ref, storeId) async {
  if (storeId.isEmpty) return null;

  try {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(storeId).get();
    if (!doc.exists) return null;
    final data = doc.data() ?? {};

    // Store data is now a nested map inside the user document
    final storeData = data['store'] as Map<String, dynamic>?;
    if (storeData == null) return null;

    // Address is now a simple string in the store map
    final address = (storeData['address'] as String?) ?? '';

    return AppStore(
      id: doc.id,
      name: (storeData['name'] as String?) ?? '',
      address: address,
      phone: (storeData['phone'] as String?) ?? '',
      category: (storeData['category'] as String?) ?? '',
      latitude: (storeData['latitude'] as num?)?.toDouble(),
      longitude: (storeData['longitude'] as num?)?.toDouble(),
    );
  } catch (e) {
    return null;
  }
});

/// Fetches all stores for the pickup stops in a multi-store order.
/// Returns a map of storeId → AppStore for quick lookup.
final pickupStopsStoresProvider =
    FutureProvider.family<Map<String, AppStore>, List<String>>(
        (ref, storeIds) async {
  if (storeIds.isEmpty) return {};

  final stores = <String, AppStore>{};
  for (final storeId in storeIds) {
    final store = await ref.watch(storeProvider(storeId).future);
    if (store != null) {
      stores[storeId] = store;
    }
  }
  return stores;
});
