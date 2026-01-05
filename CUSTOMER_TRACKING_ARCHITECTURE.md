# Customer Tracking App - Architecture Guide

## Firebase Structure للـ Real-time Tracking:

```
orders/
  └─ {orderId}/
      ├─ status: "upcoming" | "onTheWay" | "delivered" | "canceled"
      ├─ deliveryId: "uid-of-delivery-person"
      ├─ deliveryGeoPoint: GeoPoint(lat, lng)  ← يتحدث كل 5 ثواني
      ├─ userId: "uid-of-customer"
      ├─ date: timestamp
      └─ ... other order data

users/
  └─ {deliveryId}/
      ├─ name: "Mohamed Ali"
      ├─ phone: "+201234567890"
      └─ image: "url"
```

## Customer App Features:

### 1. Real-time Order Tracking Screen

```dart
// lib/features/tracking/presentation/screens/order_tracking_screen.dart

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to order changes in real-time
    final orderStream = ref.watch(orderTrackingProvider(orderId));
    
    return orderStream.when(
      data: (order) {
        return Stack(
          children: [
            // Google Map showing:
            // 1. Customer location (fixed)
            // 2. Delivery person location (real-time)
            // 3. Route polyline between them
            GoogleMap(
              markers: {
                _buildCustomerMarker(order.customerLocation),
                _buildDeliveryMarker(order.deliveryGeoPoint), // Updates automatically
              },
              polylines: {
                _buildRouteLine(order.customerLocation, order.deliveryGeoPoint),
              },
            ),
            
            // Order Status Card
            OrderStatusCard(
              status: order.status,
              estimatedTime: _calculateETA(order),
              deliveryPerson: order.deliveryPerson,
            ),
          ],
        );
      },
      loading: () => LoadingWidget(),
      error: (e, st) => ErrorWidget(e),
    );
  }
}
```

### 2. Order Tracking Provider (Riverpod)

```dart
// lib/features/tracking/presentation/providers/order_tracking_provider.dart

@riverpod
Stream<Order> orderTracking(OrderTrackingRef ref, String orderId) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  
  // Listen to order document changes in real-time
  return firestore
      .collection('orders')
      .doc(orderId)
      .snapshots()
      .map((snapshot) => Order.fromFirestore(snapshot));
}

@riverpod
Stream<GeoPoint?> deliveryLocationStream(
  DeliveryLocationStreamRef ref,
  String orderId,
) {
  final order = ref.watch(orderTrackingProvider(orderId));
  
  return order.when(
    data: (order) {
      if (order.deliveryId == null) {
        return Stream.value(null);
      }
      
      // Watch the delivery person's live location
      return ref
          .watch(firebaseFirestoreProvider)
          .collection('orders')
          .doc(orderId)
          .snapshots()
          .map((snapshot) => snapshot.data()?['deliveryGeoPoint'] as GeoPoint?);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
}
```

### 3. FCM Notifications للعميل

```dart
// functions/index.js - Cloud Function

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Send notification when delivery status changes
exports.notifyCustomerOnStatusChange = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    
    // Check if status changed
    if (newValue.deliveryStatus !== previousValue.deliveryStatus) {
      const customerId = newValue.userId;
      
      // Get customer FCM token
      const userDoc = await admin.firestore().collection('users').doc(customerId).get();
      const fcmToken = userDoc.data()?.fcmToken;
      
      if (!fcmToken) return;
      
      // Send notification based on status
      let title, body;
      switch (newValue.deliveryStatus) {
        case 'onTheWay':
          title = '🚗 Your order is on the way!';
          body = 'The delivery person is heading to your location';
          break;
        case 'delivered':
          title = '✅ Order Delivered!';
          body = 'Your order has been delivered successfully';
          break;
        case 'canceled':
          title = '❌ Order Canceled';
          body = 'Unfortunately, your order was canceled';
          break;
      }
      
      // Send FCM notification
      await admin.messaging().send({
        token: fcmToken,
        notification: { title, body },
        data: {
          orderId: context.params.orderId,
          status: newValue.deliveryStatus,
        },
      });
    }
  });

// Send notification when delivery is near (200m radius)
exports.notifyWhenDeliveryNear = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    
    if (!newValue.deliveryGeoPoint || !newValue.customerGeoPoint) return;
    
    // Calculate distance
    const distance = calculateDistance(
      newValue.deliveryGeoPoint,
      newValue.customerGeoPoint
    );
    
    // If delivery person is within 200m and wasn't before
    if (distance <= 200 && previousDistance > 200) {
      // Send notification to customer
      const userDoc = await admin.firestore().collection('users').doc(newValue.userId).get();
      const fcmToken = userDoc.data()?.fcmToken;
      
      if (fcmToken) {
        await admin.messaging().send({
          token: fcmToken,
          notification: {
            title: '🎯 Delivery Almost There!',
            body: 'Your order will arrive in a few minutes',
          },
        });
      }
    }
  });
```

### 4. Customer App Home Screen

```dart
// lib/features/home/presentation/screens/customer_home_screen.dart

class CustomerHomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final ordersStream = ref.watch(customerOrdersProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: ordersStream.when(
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyOrdersWidget();
          }
          
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                onTrack: () {
                  // Navigate to tracking screen
                  context.push('/tracking/${order.id}');
                },
              );
            },
          );
        },
        loading: () => LoadingWidget(),
        error: (e, st) => ErrorWidget(e),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new-order'),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 5. Firestore Security Rules

```javascript
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Orders collection
    match /orders/{orderId} {
      // Customer can read their own orders
      allow read: if request.auth != null && 
                    resource.data.userId == request.auth.uid;
      
      // Customer can create new orders
      allow create: if request.auth != null && 
                      request.resource.data.userId == request.auth.uid;
      
      // Only delivery person assigned to order can update delivery fields
      allow update: if request.auth != null && 
                      resource.data.deliveryId == request.auth.uid &&
                      // Can only update delivery-specific fields
                      request.resource.data.diff(resource.data).affectedKeys()
                        .hasOnly(['deliveryGeoPoint', 'deliveryStatus']);
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Implementation Steps:

### Step 1: Create Customer App Project
```bash
flutter create customer_app
cd customer_app
flutter pub add firebase_core cloud_firestore firebase_auth
flutter pub add riverpod_annotation hooks_riverpod flutter_hooks
flutter pub add google_maps_flutter geolocator
flutter pub add firebase_messaging flutter_local_notifications
```

### Step 2: Update Delivery App (الحالي)
```dart
// Ensure delivery location updates are being sent to Firebase
// This already exists in your app at:
// lib/features/home/presentation/providers/location_stream_provider.dart

// Make sure it's updating Firestore with deliveryGeoPoint
```

### Step 3: Deploy Cloud Functions
```bash
cd functions
npm install
firebase deploy --only functions
```

### Step 4: Test Real-time Updates
1. Open Customer App
2. Create order
3. Open Delivery App and accept order
4. Move delivery person → See map update in Customer App in real-time!

## Summary:

الحل الكامل بيشمل:
- ✅ **Customer App** → للتتبع Real-time
- ✅ **Delivery App** → بينقل موقعه كل 5 ثواني (already implemented)
- ✅ **Firebase Firestore** → Real-time database
- ✅ **Cloud Functions** → للإشعارات التلقائية
- ✅ **Security Rules** → للحماية

هل عايز أساعدك تعمل الـ Customer App من الصفر؟
