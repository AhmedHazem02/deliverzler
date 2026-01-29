import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'offline_sync_manager.freezed.dart';

/// نموذج العملية المعلقة
@freezed
class PendingOperation with _$PendingOperation {
  const factory PendingOperation({
    required String id,
    required String orderId,
    required String operationType, // 'update_status', 'update_location'
    required Map<String, dynamic> data,
    required DateTime createdAt,
    required int retryCount,
    @Default(null) String? error,
  }) = _PendingOperation;

  factory PendingOperation.fromJson(Map<String, dynamic> json) =>
      _$PendingOperationFromJson(json);
}

/// مدير المزامنة غير المتصلة
class OfflineSyncManager {
  static const String _storageKey = 'pending_operations';
  final SharedPreferences _prefs;

  OfflineSyncManager(this._prefs);

  /// حفظ عملية معلقة
  Future<void> savePendingOperation(PendingOperation operation) async {
    try {
      final operations = await getPendingOperations();
      operations.add(operation);
      await _saveToDisk(operations);
      debugPrint('✅ حفظت عملية معلقة: ${operation.id}');
    } catch (e) {
      debugPrint('❌ خطأ في حفظ العملية المعلقة: $e');
      rethrow;
    }
  }

  /// الحصول على جميع العمليات المعلقة
  Future<List<PendingOperation>> getPendingOperations() async {
    try {
      final json = _prefs.getString(_storageKey);
      if (json == null || json.isEmpty) return [];

      final List<dynamic> decoded = jsonDecode(json);
      return decoded
          .map((item) => PendingOperation.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ خطأ في قراءة العمليات المعلقة: $e');
      return [];
    }
  }

  /// حذف عملية معلقة بعد نجاحها
  Future<void> removePendingOperation(String operationId) async {
    try {
      final operations = await getPendingOperations();
      operations.removeWhere((op) => op.id == operationId);
      await _saveToDisk(operations);
      debugPrint('✅ حذفت العملية المعلقة: $operationId');
    } catch (e) {
      debugPrint('❌ خطأ في حذف العملية المعلقة: $e');
      rethrow;
    }
  }

  /// تحديث محاولات إعادة المحاولة
  Future<void> incrementRetryCount(String operationId) async {
    try {
      final operations = await getPendingOperations();
      final index =
          operations.indexWhere((op) => op.id == operationId);

      if (index >= 0) {
        final operation = operations[index];
        operations[index] = operation.copyWith(
          retryCount: operation.retryCount + 1,
        );
        await _saveToDisk(operations);
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحديث محاولات إعادة المحاولة: $e');
      rethrow;
    }
  }

  /// حفظ إلى القرص
  Future<void> _saveToDisk(List<PendingOperation> operations) async {
    final json = jsonEncode(operations.map((op) => op.toJson()).toList());
    await _prefs.setString(_storageKey, json);
  }

  /// مسح جميع العمليات المعلقة
  Future<void> clearAll() async {
    await _prefs.remove(_storageKey);
    debugPrint('✅ مسحت جميع العمليات المعلقة');
  }
}
