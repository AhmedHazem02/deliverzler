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
    return AppStore(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
    );
  } catch (e) {
    return null;
  }
});
