import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order_item.dart';
import '../data_sources/order_items_remote_data_source.dart';

part 'order_items_repo.g.dart';

@Riverpod(keepAlive: true)
OrderItemsRepo orderItemsRepo(Ref ref) {
  return OrderItemsRepo(
    ref,
    orderItemsRemoteDataSource: ref.watch(orderItemsRemoteDataSourceProvider),
  );
}

class OrderItemsRepo {
  OrderItemsRepo(
    this.ref, {
    required this.orderItemsRemoteDataSource,
  });

  final Ref ref;
  final OrderItemsRemoteDataSource orderItemsRemoteDataSource;

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    final itemsDto = await orderItemsRemoteDataSource.getOrderItems(orderId);
    return itemsDto.map((dto) => dto.toDomain()).toList();
  }

  Stream<List<OrderItem>> streamOrderItems(String orderId) {
    return orderItemsRemoteDataSource
        .streamOrderItems(orderId)
        .map((itemsDto) => itemsDto.map((dto) => dto.toDomain()).toList());
  }
}
