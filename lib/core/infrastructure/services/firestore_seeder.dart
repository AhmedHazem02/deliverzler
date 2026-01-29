import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Seeds Firestore with sample data for development/testing
class FirestoreSeeder {
  static final _firestore = FirebaseFirestore.instance;

  /// Seeds sample data (Vendors and Orders) if collections are empty.
  /// Only runs in debug mode to avoid seeding in production.
  static Future<void> seedIfEmpty() async {
    // Only seed in debug mode
    if (!kDebugMode) return;

    try {
      debugPrint('🌱 FirestoreSeeder: Checking if seeding is needed...');
      
      // 1. Seed Vendors
      final vendors = await _seedVendorsIfEmpty();

      // 2. Seed Orders (using vendors to link data)
      await _seedOrdersIfEmpty(vendors);

    } catch (e) {
      debugPrint('❌ FirestoreSeeder Error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> _seedVendorsIfEmpty() async {
    final vendorsCollection = _firestore.collection('vendors');
    final snapshot = await vendorsCollection.limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      debugPrint('ℹ️ FirestoreSeeder: Vendors already exist. Fetching for linking...');
      // Return existing vendors to link orders to them
      final query = await vendorsCollection.limit(5).get();
      return query.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }).toList();
    }

    debugPrint('🚀 FirestoreSeeder: Seeding Vendors...');
    final List<Map<String, dynamic>> vendors = [
      {
        'name': 'Burger King',
        'description': 'The Home of the Whopper',
        'category': 'food',
        'status': 'active',
        'address': {
          'state': 'Cairo',
          'city': 'Nasr City',
          'street': 'Abbas El Akkad',
          'mobile': '+201000000001',
          'geoPoint': const GeoPoint(30.0566, 31.3301), 
        },
        'rating': 4.5,
        'totalRatings': 120,
        'isVerified': true,
        'isFeatured': true,
        'totalOrders': 500,
        'totalRevenue': 50000.0,
        'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Zara',
        'description': 'Latest fashion trends',
        'category': 'clothing',
        'status': 'active',
        'address': {
          'state': 'Cairo',
          'city': 'Maadi',
          'street': 'Road 9',
          'mobile': '+201000000002',
          'geoPoint': const GeoPoint(29.9602, 31.2569), 
        },
        'rating': 4.8,
        'totalRatings': 300,
        'isVerified': true,
        'isFeatured': false,
        'totalOrders': 1200,
        'totalRevenue': 150000.0,
        'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Zara_Logo.svg/1000px-Zara_Logo.svg.png',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'El Ezaby Pharmacy',
        'description': 'Your health partner',
        'category': 'pharmacy',
        'status': 'active',
        'address': {
          'state': 'Giza',
          'city': 'Mohandessin',
          'street': 'Syria St',
          'mobile': '+201000000003',
          'geoPoint': const GeoPoint(30.0511, 31.2001), 
        },
        'rating': 4.2,
        'totalRatings': 50,
        'isVerified': true,
        'isFeatured': false,
        'totalOrders': 200,
        'totalRevenue': 10000.0,
        'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/El_Ezaby_Pharmacy_Logo.jpg/800px-El_Ezaby_Pharmacy_Logo.jpg',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final List<Map<String, dynamic>> createdVendors = [];
    final batch = _firestore.batch();

    for (final vendor in vendors) {
      final docRef = vendorsCollection.doc();
      batch.set(docRef, vendor);
      
      final vendorWithId = Map<String, dynamic>.from(vendor);
      vendorWithId['id'] = docRef.id;
      createdVendors.add(vendorWithId);
    }
    
    await batch.commit();
    debugPrint('✅ FirestoreSeeder: Vendors seeded successfully');
    return createdVendors;
  }

  static Future<void> _seedOrdersIfEmpty(List<Map<String, dynamic>> vendors) async {
    final ordersCollection = _firestore.collection('orders');

    // Basic Vendor Helper
    Map<String, dynamic> getVendor(int index) {
      if (vendors.isNotEmpty && index < vendors.length) {
        return vendors[index];
      }
      return {
        'id': 'vendor_$index',
        'name': 'Store $index',
      };
    }

    final v0 = getVendor(0);
    final v1 = getVendor(1);
    final v2 = getVendor(2);

    debugPrint('🚀 FirestoreSeeder: Seeding/Updating Generic Orders...');

    // Fixed User ID for testing (matches one used in logs/previous code)
    const String userId = 'fbXrYLdlJRcvrVLrvj8XAaw0N4t1';

    final orders = [
      {
        'id': 'order_new_1',
        'date': DateTime.now().millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': 'Please deliver fast',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'confirmed',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0['id'],
        'storeName': v0['name'],
        'total': 150.0,
        'subtotal': 130.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'New Cairo',
          'street': 'Street 90',
          'mobile': '+201234567890',
          'geoPoint': const GeoPoint(30.0296, 31.4770),
        },
        'items': [
          {'id': 'i1', 'name': 'Beef Burger', 'quantity': 1, 'price': 50.0, 'total': 50.0},
          {'id': 'i2', 'name': 'Cheese Fries', 'quantity': 2, 'price': 40.0, 'total': 80.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_new_2',
        'date': DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
        'pickupOption': 'pickUp',
        'paymentMethod': 'visa',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': 'No onions',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'confirmed',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0['id'],
        'storeName': v0['name'],
        'total': 90.0,
        'subtotal': 90.0,
        'deliveryFee': 0.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Nasr City',
          'street': 'Pickup from Store',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(30.0566, 31.3301),
        },
        'items': [
          {'id': 'i4', 'name': 'Chicken Salad', 'quantity': 1, 'price': 90.0, 'total': 90.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_new_3',
        'date': DateTime.now().subtract(const Duration(minutes: 2)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'pending',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v2['id'],
        'storeName': v2['name'],
        'total': 60.0,
        'subtotal': 40.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Giza',
          'city': 'Dokki',
          'street': 'Messaha Sq',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(30.0350, 31.2150),
        },
        'items': [
          {'id': 'm2', 'name': 'Panadol', 'quantity': 1, 'price': 40.0, 'total': 40.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_preparing_1',
        'date': DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'visa',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': 'Extra sauce',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'preparing',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v1['id'],
        'storeName': v1['name'],
        'total': 300.0,
        'subtotal': 280.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Giza',
          'city': 'Dokki',
          'street': 'Tahrir St',
          'mobile': '+201234567891',
          'geoPoint': const GeoPoint(30.0385, 31.2123),
        },
        'items': [
          {'id': 'p1', 'name': 'Large Pizza', 'quantity': 1, 'price': 280.0, 'total': 280.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_ready_1',
        'date': DateTime.now().subtract(const Duration(minutes: 15)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': 'other_user',
        'userName': 'Other User',
        'userImage': '',
        'userPhone': '01155566677',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'ready',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0['id'],
        'storeName': v0['name'],
        'total': 80.0,
        'subtotal': 60.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Maadi',
          'street': 'Corniche',
          'mobile': '01155566677',
          'geoPoint': const GeoPoint(29.9602, 31.2569),
        },
        'items': [
          {'id': 's1', 'name': 'Sandwich', 'quantity': 2, 'price': 30.0, 'total': 60.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_ontheway_1',
        'date': DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'wallet',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'onTheWay',
        'status': 'ready',
        'deliveryId': 'driver_1',
        'deliveryGeoPoint': const GeoPoint(30.0400, 31.2200),
        'deliveryHeading': 90.0,
        'storeId': v2['id'],
        'storeName': v2['name'],
        'total': 450.0,
        'subtotal': 430.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Giza',
          'city': 'Mohandessin',
          'street': 'Syria St',
          'mobile': '+201000000003',
          'geoPoint': const GeoPoint(30.0511, 31.2001),
        },
        'items': [
          {'id': 'm1', 'name': 'Medicine Box', 'quantity': 1, 'price': 430.0, 'total': 430.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_delivered_1',
        'date': DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'delivered',
        'status': 'ready',
        'deliveryId': 'driver_2',
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0['id'],
        'storeName': v0['name'],
        'total': 200.0,
        'subtotal': 180.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Nasr City',
          'street': 'Abbas St',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(30.0566, 31.3301),
        },
        'items': [
          {'id': 'i3', 'name': 'Combo Meal', 'quantity': 1, 'price': 180.0, 'total': 180.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_delivered_2',
        'date': DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'visa',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'delivered',
        'status': 'ready',
        'deliveryId': 'driver_3',
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v1['id'],
        'storeName': v1['name'],
        'total': 1200.0,
        'subtotal': 1200.0,
        'deliveryFee': 0.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Maadi',
          'street': 'Road 9',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(29.9602, 31.2569),
        },
        'items': [
          {'id': 'c2', 'name': 'Winter Jacket', 'quantity': 1, 'price': 1200.0, 'total': 1200.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_canceled_1',
        'date': DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'visa',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': 'Out of stock',
        'deliveryStatus': 'canceled',
        'status': 'canceled',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v1['id'],
        'storeName': v1['name'],
        'total': 120.0,
        'subtotal': 100.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Maadi',
          'street': 'Road 9',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(29.9602, 31.2569),
        },
        'items': [
          {'id': 'c1', 'name': 'T-Shirt', 'quantity': 1, 'price': 100.0, 'total': 100.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'order_canceled_2',
        'date': DateTime.now().subtract(const Duration(minutes: 40)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'canceled',
        'status': 'canceled',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0['id'],
        'storeName': v0['name'],
        'total': 50.0,
        'subtotal': 30.0,
        'deliveryFee': 20.0,
        'addressModel': {
          'state': 'Cairo',
          'city': 'Nasr City',
          'street': 'Makram Ebeid',
          'mobile': '+201000000000',
          'geoPoint': const GeoPoint(30.0560, 31.3300),
        },
        'items': [
          {'id': 'i5', 'name': 'Coffee', 'quantity': 1, 'price': 30.0, 'total': 30.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _firestore.batch();
    for (final order in orders) {
      final docRef = ordersCollection.doc(order['id'] as String);
      batch.set(docRef, order, SetOptions(merge: true));
    }
    await batch.commit();
    debugPrint('✅ FirestoreSeeder: Orders seeded/updated successfully');
  }

  /// Deletes all data from vendors and orders collections
  static Future<void> clear() async {
    if (!kDebugMode) return;
    debugPrint('🗑️ FirestoreSeeder: Deleting all seeded data...');

    try {
      final batch = _firestore.batch();

      final orders = await _firestore.collection('orders').get();
      for (final doc in orders.docs) {
        batch.delete(doc.reference);
      }

      final vendors = await _firestore.collection('vendors').get();
      for (final doc in vendors.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('✅ FirestoreSeeder: All data deleted successfully.');
    } catch (e) {
      debugPrint('❌ FirestoreSeeder Delete Error: $e');
    }
  }
}
