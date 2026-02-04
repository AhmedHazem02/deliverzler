import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/store.dart';

/// Manual provider (no codegen) to fetch a store document by id.
final storeProvider =
    FutureProvider.family<AppStore?, String>((ref, storeId) async {
  if (storeId.isEmpty) return null;

  try {
    final doc = await FirebaseFirestore.instance
        .collection('stores')
        .doc(storeId)
        .get();
    if (!doc.exists) return null;
    final data = doc.data() ?? {};

    // Extract address from address map
    String address = '';
    if (data['address'] != null && data['address'] is Map) {
      final addressMap = data['address'] as Map<String, dynamic>;
      final street = (addressMap['street'] as String?) ?? '';
      final city = (addressMap['city'] as String?) ?? '';
      final country = (addressMap['country'] as String?) ?? '';

      address =
          [street, city, country].where((part) => part.isNotEmpty).join(', ');
    }

    return AppStore(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      address: address,
      phone: (data['phone'] as String?) ?? '',
      category: (data['category'] as String?) ?? '',
    );
  } catch (e) {
    return null;
  }
});
