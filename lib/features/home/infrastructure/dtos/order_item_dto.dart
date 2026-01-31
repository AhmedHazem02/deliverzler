import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/order_item.dart';

part 'order_item_dto.freezed.dart';
part 'order_item_dto.g.dart';

@freezed
class OrderItemDto with _$OrderItemDto {
  const factory OrderItemDto({
    required String id,
    required String name,
    String? imageUrl,
    @Default('') String? image, // Alternative field name in Firestore
    required int quantity,
    required double price,
    required double total,
    String? category,
    String? description,
  }) = _OrderItemDto;

  const OrderItemDto._();

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  OrderItem toDomain() {
    return OrderItem(
      id: id,
      name: name,
      imageUrl: imageUrl ?? image, // Use imageUrl or fallback to image
      quantity: quantity,
      price: price,
      total: total,
      category: category,
      description: description,
    );
  }
}
