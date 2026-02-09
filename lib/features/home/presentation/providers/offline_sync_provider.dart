import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/infrastructure/utils/offline_sync_manager.dart';

/// موفر مدير المزامنة غير المتصلة
final offlineSyncManagerProvider =
    FutureProvider<OfflineSyncManager>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return OfflineSyncManager(prefs);
});

/// موفر قائمة العمليات المعلقة
final pendingOperationsProvider =
    FutureProvider<List<PendingOperation>>((ref) async {
  final syncManager = await ref.watch(offlineSyncManagerProvider.future);
  return syncManager.getPendingOperations();
});

/// موفر عدد العمليات المعلقة
final pendingOperationsCountProvider = FutureProvider<int>((ref) async {
  final operations = await ref.watch(pendingOperationsProvider.future);
  return operations.length;
});

/// معالج العمليات المعلقة
final processPendingOperationsProvider = FutureProvider<void>((ref) async {
  try {
    final syncManager = await ref.watch(offlineSyncManagerProvider.future);
    final operations = await syncManager.getPendingOperations();

    debugPrint('🔄 معالجة ${operations.length} عمليات معلقة...');

    // يمكن هنا إضافة منطق معالجة العمليات المعلقة
    // مثل إعادة محاولة العمليات الفاشلة

    for (final operation in operations) {
      if (operation.retryCount > 3) {
        debugPrint(
          '⏹️ إيقاف العملية ${operation.id} - تم تجاوز الحد الأقصى للمحاولات',
        );
        await syncManager.removePendingOperation(operation.id);
      }
    }
  } catch (e) {
    debugPrint('❌ خطأ في معالجة العمليات المعلقة: $e');
  }
});
