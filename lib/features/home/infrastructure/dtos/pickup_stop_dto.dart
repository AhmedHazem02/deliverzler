import '../../domain/order_item.dart';
import '../../domain/pickup_stop.dart';

/// DTO for parsing pickup_stops from Firestore.
///
/// Maps the raw Firestore map structure into domain [PickupStop] objects.
/// Each pickup stop contains a store's items within a multi-store order.
class PickupStopDto {
  final String storeId;
  final String storeName;
  final double subtotal;
  final String status;
  final List<Map<String, dynamic>> itemsRaw;
  final String? confirmedAt;
  final String? pickedUpAt;
  final String? rejectedAt;
  final String? rejectionReason;

  PickupStopDto({
    required this.storeId,
    required this.storeName,
    required this.subtotal,
    required this.status,
    required this.itemsRaw,
    this.confirmedAt,
    this.pickedUpAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  /// Creates a [PickupStopDto] from a Firestore pickup_stop map.
  factory PickupStopDto.fromJson(Map<String, dynamic> json) {
    return PickupStopDto(
      storeId: (json['store_id'] as String?) ?? '',
      storeName: (json['store_name'] as String?) ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] as String?) ?? 'pending',
      itemsRaw: _parseItemsList(json['items']),
      confirmedAt: json['confirmed_at'] as String?,
      pickedUpAt: json['picked_up_at'] as String?,
      rejectedAt: json['rejected_at'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Safely parses the items list from Firestore data.
  static List<Map<String, dynamic>> _parseItemsList(dynamic items) {
    if (items == null) return [];
    if (items is! List) return [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  /// Converts to domain [PickupStop].
  PickupStop toDomain() {
    return PickupStop(
      storeId: storeId,
      storeName: storeName,
      subtotal: subtotal,
      status: PickupStopStatus.fromValue(status),
      items: _parseItems(),
      confirmedAt: _parseDateTime(confirmedAt),
      pickedUpAt: _parseDateTime(pickedUpAt),
      rejectedAt: _parseDateTime(rejectedAt),
      rejectionReason: rejectionReason,
    );
  }

  /// Parses item maps into domain [OrderItem] objects.
  List<OrderItem> _parseItems() {
    return itemsRaw.map((itemJson) {
      final price = (itemJson['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (itemJson['quantity'] as num?)?.toInt() ?? 1;
      return OrderItem(
        id: (itemJson['product_id'] as String?) ?? '',
        name: (itemJson['name'] as String?) ?? '',
        imageUrl: itemJson['image_url'] as String?,
        quantity: quantity,
        price: price,
        total: price * quantity,
        storeName: storeName,
      );
    }).toList();
  }

  /// Safely parses a datetime string.
  static DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Creates a list of [PickupStop] from a Firestore pickup_stops array.
  static List<PickupStop> parseList(List<dynamic>? raw) {
    if (raw == null || raw.isEmpty) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map((json) => PickupStopDto.fromJson(json).toDomain())
        .toList();
  }

  /// Converts a [PickupStop] back to a Firestore-compatible map.
  static Map<String, dynamic> toFirestoreMap(PickupStop stop) {
    return {
      'store_id': stop.storeId,
      'store_name': stop.storeName,
      'subtotal': stop.subtotal,
      'status': stop.status.jsonValue,
      'confirmed_at': stop.confirmedAt?.toIso8601String(),
      'picked_up_at': stop.pickedUpAt?.toIso8601String(),
      'rejected_at': stop.rejectedAt?.toIso8601String(),
      'rejection_reason': stop.rejectionReason,
      'items': stop.items
          .map((item) => {
                'product_id': item.id,
                'name': item.name,
                'image_url': item.imageUrl,
                'price': item.price,
                'quantity': item.quantity,
              })
          .toList(),
    };
  }
}
