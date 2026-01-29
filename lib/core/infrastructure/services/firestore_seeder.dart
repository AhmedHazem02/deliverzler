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
    // Check if Sohag orders already exist to avoid duplicates
    final sohagQuery = await ordersCollection
        .where('addressModel.city', isEqualTo: 'Girga')
        .limit(1)
        .get();

    if (sohagQuery.docs.isNotEmpty) {
      debugPrint('ℹ️ FirestoreSeeder: Sohag orders already exist. Skipping.');
    } else {
      debugPrint('🚀 FirestoreSeeder: Seeding Sohag Orders...');
      
      // Helper to get vendor info (reuse existing logic if possible, or fetch)
      // Since specific vendors might not match the "Sohag" context perfectly, 
      // we will use the same generic vendors or the ones passed in if available. 
      // If vendors argument is empty, we might need to fetch them or just use generic data.
      String getStoreId(int index) {
        if (vendors.isNotEmpty) return vendors[index % vendors.length]['id'];
        return 'store_${index}'; 
      }
      String getStoreName(int index) {
        if (vendors.isNotEmpty) return vendors[index % vendors.length]['name'];
        return 'Store ${index}';
      }

      final sohagOrders = [
        {
          'date': DateTime.now().millisecondsSinceEpoch,
          'pickupOption': 'delivery',
          'paymentMethod': 'cash',
          'userId': 'user_sohag_1',
          'userName': 'Mahmoud Sohag',
          'userImage': '',
          'userPhone': '01111111111',
          'userNote': 'Near the station',
          'employeeCancelNote': null,
          'deliveryStatus': 'upcoming',
          'status': 'confirmed',
          'deliveryId': null,
          'deliveryGeoPoint': null,
          'deliveryHeading': null,
          'storeId': getStoreId(0),
          'storeName': getStoreName(0),
          'total': 120.0,
          'subtotal': 100.0,
          'deliveryFee': 20.0,
          'addressModel': {
            'state': 'Sohag',
            'city': 'Girga',
            'street': 'El Mahatta St',
            'mobile': '01111111111',
            'geoPoint': const GeoPoint(26.3389, 31.8917), // Approximate Girga coords
          },
          'items': [
            {'id': 's1', 'name': 'Koshary', 'quantity': 2, 'price': 50.0, 'total': 100.0},
          ],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'date': DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
          'pickupOption': 'delivery',
          'paymentMethod': 'cash',
          'userId': 'user_sohag_2',
          'userName': 'Ali Girga',
          'userImage': '',
          'userPhone': '01222222222',
          'userNote': '',
          'employeeCancelNote': null,
          'deliveryStatus': 'upcoming',
          'status': 'ready',
          'deliveryId': null,
          'deliveryGeoPoint': null,
          'deliveryHeading': null,
          'storeId': getStoreId(1),
          'storeName': getStoreName(1),
          'total': 250.0,
          'subtotal': 230.0,
          'deliveryFee': 20.0,
          'addressModel': {
            'state': 'Sohag',
            'city': 'Girga',
            'street': 'El Bahr St',
            'mobile': '01222222222',
            'geoPoint': const GeoPoint(26.3420, 31.8950), // Another spot in Girga
          },
          'items': [
            {'id': 's2', 'name': 'Pizza', 'quantity': 1, 'price': 230.0, 'total': 230.0},
          ],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      final batchSohag = _firestore.batch();
      for (final order in sohagOrders) {
        final docRef = ordersCollection.doc();
        batchSohag.set(docRef, order);
      }
      await batchSohag.commit();
      debugPrint('✅ FirestoreSeeder: Sohag Orders seeded successfully');
    }

    final snapshot = await ordersCollection.limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      debugPrint('ℹ️ FirestoreSeeder: Generic Orders already exist. Skipping generic seed.');
      return;
    }

    debugPrint('🚀 FirestoreSeeder: Seeding Generic Orders...');

    // Use a fixed User ID for testing if available, or generic
    const String userId = 'fbXrYLdlJRcvrVLrvj8XAaw0N4t1'; // Using ID from logs
    
    // Helper to get vendor info
    Map<String, dynamic>? getVendor(int index) {
      if (vendors.isEmpty) return null;
      return vendors[index % vendors.length];
    }
    
    // Vendor 0 info
    final v0 = getVendor(0);
    // Vendor 1 info
    final v1 = getVendor(1);

    final orders = [
      {
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
        'status': 'confirmed', // Matches Admin Dashboard
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0?['id'],
        'storeName': v0?['name'],
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
          {'id': 'i1', 'name': 'Item 1', 'quantity': 1, 'price': 50.0, 'total': 50.0},
          {'id': 'i2', 'name': 'Item 2', 'quantity': 2, 'price': 40.0, 'total': 80.0},
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'date': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'visa',
        'userId': userId,
        'userName': 'User',
        'userImage': '',
        'userPhone': '+201000000000',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming',
        'status': 'preparing',
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v1?['id'],
        'storeName': v1?['name'],
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
        'items': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
       {
        'date': DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
        'pickupOption': 'delivery',
        'paymentMethod': 'cash',
        'userId': 'other_user',
        'userName': 'Other User',
        'userImage': '',
        'userPhone': '01155566677',
        'userNote': '',
        'employeeCancelNote': null,
        'deliveryStatus': 'upcoming', // Shows as available for drivers
        'status': 'ready', 
        'deliveryId': null,
        'deliveryGeoPoint': null,
        'deliveryHeading': null,
        'storeId': v0?['id'], // Back to first vendor
        'storeName': v0?['name'],
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
        'items': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _firestore.batch();
    for (final order in orders) {
      final docRef = ordersCollection.doc();
      batch.set(docRef, order);
    }
    await batch.commit();
    debugPrint('✅ FirestoreSeeder: Orders seeded successfully');
  }
}
