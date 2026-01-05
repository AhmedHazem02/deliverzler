import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Seeds Firestore with sample data for development/testing
class FirestoreSeeder {
  static final _firestore = FirebaseFirestore.instance;

  /// Seeds sample orders if the orders collection is empty
  /// Only runs in debug mode to avoid seeding in production
  static Future<void> seedIfEmpty() async {
    // Only seed in debug mode
    if (!kDebugMode) return;

    try {
      final ordersSnapshot = await _firestore.collection('orders').limit(1).get();
      if (ordersSnapshot.docs.isEmpty) {
        await seedSampleOrders();
        debugPrint('FirestoreSeeder: Sample orders added successfully');
      }
    } catch (e) {
      // Collection might not exist, try to seed it
      try {
        await seedSampleOrders();
        debugPrint('FirestoreSeeder: Sample orders added successfully');
      } catch (e2) {
        debugPrint('FirestoreSeeder: Failed to seed orders - $e2');
      }
    }
  }

  /// Seeds sample orders
  static Future<void> seedSampleOrders() async {
    final orders = [
      {
        'date': DateTime.now().millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': 'test-user-1',
        'userName': 'أحمد محمد',
        'userImage': '',
        'userPhone': '01012345678',
        'userNote': 'الطلب على الباب',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'deliveryId': '',
        'deliveryGeoPoint': null,
        'addressModel': {
          'state': 'سوهاج',
          'city': 'جرجا',
          'street': 'شارع الجمهورية',
          'mobile': '01012345678',
          'geoPoint': const GeoPoint(26.3389, 31.8917),
        },
      },
      {
        'date': DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'visa',
        'userId': 'test-user-2',
        'userName': 'محمد علي',
        'userImage': '',
        'userPhone': '01098765432',
        'userNote': 'اتصل قبل الوصول',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'deliveryId': '',
        'deliveryGeoPoint': null,
        'addressModel': {
          'state': 'سوهاج',
          'city': 'جرجا',
          'street': 'شارع النيل',
          'mobile': '01098765432',
          'geoPoint': const GeoPoint(26.3400, 31.8900),
        },
      },
      {
        'date': DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': 'test-user-3',
        'userName': 'فاطمة أحمد',
        'userImage': '',
        'userPhone': '01155566677',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'deliveryId': '',
        'deliveryGeoPoint': null,
        'addressModel': {
          'state': 'سوهاج',
          'city': 'جرجا',
          'street': 'شارع المحطة',
          'mobile': '01155566677',
          'geoPoint': const GeoPoint(26.3375, 31.8925),
        },
      },
    ];

    final batch = _firestore.batch();
    for (final order in orders) {
      final docRef = _firestore.collection('orders').doc();
      batch.set(docRef, order);
    }
    await batch.commit();
  }
}
