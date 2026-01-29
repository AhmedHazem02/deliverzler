import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/delivery_order.dart';
import '../../../../core/infrastructure/utils/retry_utility.dart';
import '../../../../core/infrastructure/utils/network_retry_strategy.dart';
import '../../../../core/infrastructure/utils/geo_point_validator.dart';

part 'update_delivery_status_optimistic_provider.freezed.dart';

/// حالة التحديث المتفائل
@freezed
class UpdateDeliveryStatusState with _$UpdateDeliveryStatusState {
  const factory UpdateDeliveryStatusState({
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(false) bool isOptimistic,
  }) = _UpdateDeliveryStatusState;
}

/// موفر تحديث حالة التوصيل بطريقة متفائلة
final updateDeliveryStatusOptimisticProvider = StateNotifierProvider.autoDispose
    .family<UpdateDeliveryStatusNotifier, UpdateDeliveryStatusState, String>(
  (ref, orderId) => UpdateDeliveryStatusNotifier(orderId, ref),
);

/// معالج التحديث المتفائل
class UpdateDeliveryStatusNotifier extends StateNotifier<UpdateDeliveryStatusState> {
  final String orderId;
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UpdateDeliveryStatusNotifier(this.orderId, this.ref)
      : super(const UpdateDeliveryStatusState());

  /// تحديث الحالة بطريقة متفائلة
  Future<void> updateStatusOptimistic({
    required String newStatus,
    GeoPoint? location,
    String? notes,
  }) async {
    try {
      // 1️⃣ تحديث واجهة المستخدم فوراً (متفائل)
      state = state.copyWith(
        isLoading: true,
        error: null,
        isOptimistic: true,
      );

      // 2️⃣ تجهيز البيانات
      final updateData = {
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
        if (notes != null) 'notes': notes,
      };

      // إضافة الموقع إذا كان صحيحاً
      if (GeoPointValidator.isValidGeoPoint(location)) {
        updateData['location'] = location;
      }

      // 3️⃣ محاولة التحديث مع إعادة محاولة ذكية
      await RetryUtility.retry(
        operation: () => _firestore
            .collection('orders')
            .doc(orderId)
            .update(updateData),
        maxRetries: 3,
        retryIf: (e) {
          // إعادة محاولة فقط للأخطاء المتعلقة بالشبكة
          final isFirebaseError = e is FirebaseException;
          if (isFirebaseError) {
            return NetworkRetryStrategy.shouldRetry(e);
          }
          return e is SocketException || e is TimeoutException;
        },
      );

      // 4️⃣ نجح - حدّث الحالة
      state = state.copyWith(
        isLoading: false,
        isOptimistic: false,
      );
    } on FirebaseException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل تحديث الحالة: ${e.toString()}',
        isOptimistic: false,
      );
    }
  }

  /// معالجة أخطاء Firebase
  void _handleFirebaseError(FirebaseException error) {
    final errorMessage = switch (error.code) {
      'permission-denied' => 'ليس لديك صلاحيات كافية',
      'not-found' => 'الطلب غير موجود',
      'unavailable' => 'الخدمة غير متاحة الآن',
      _ => 'حدث خطأ: ${error.code}',
    };

    state = state.copyWith(
      isLoading: false,
      error: errorMessage,
      isOptimistic: false,
    );
  }
}
