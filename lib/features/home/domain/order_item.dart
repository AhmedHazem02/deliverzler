import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String name,
    required int quantity,
    required double price,
    required double total,
    String? imageUrl,
    String? category,
    String? description,
    String? storeName,
  }) = _OrderItem;
}
