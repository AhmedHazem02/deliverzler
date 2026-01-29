import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// حالة الفلتر
class MyOrdersFilterState {
  final String selectedFilter; // 'all', 'onTheWay', 'delivered'
  final bool isLoading;
  final String? error;

  const MyOrdersFilterState({
    required this.selectedFilter,
    this.isLoading = false,
    this.error,
  });

  MyOrdersFilterState copyWith({
    String? selectedFilter,
    bool? isLoading,
    String? error,
  }) {
    return MyOrdersFilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// مفتاح التخزين
const String _filterStorageKey = 'my_orders_filter';
const String _defaultFilter = 'all';

/// موفر حالة الفلتر مع المثابرة
final myOrdersFilterPersistenceProvider = StateNotifierProvider.autoDispose<
    MyOrdersFilterNotifier, MyOrdersFilterState>(
  (ref) => MyOrdersFilterNotifier(),
);

/// معالج حالة الفلتر
class MyOrdersFilterNotifier extends StateNotifier<MyOrdersFilterState> {
  MyOrdersFilterNotifier()
      : super(const MyOrdersFilterState(selectedFilter: _defaultFilter)) {
    _initializeFilter();
  }

  /// تحميل الفلتر المحفوظ
  Future<void> _initializeFilter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFilter = prefs.getString(_filterStorageKey) ?? _defaultFilter;

      state = state.copyWith(selectedFilter: savedFilter);
      debugPrint('✅ تم تحميل الفلتر المحفوظ: $savedFilter');
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الفلتر المحفوظ: $e');
      state = state.copyWith(error: 'فشل تحميل الفلتر المحفوظ');
    }
  }

  /// تعديل الفلتر وحفظه
  Future<void> setFilter(String filter) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_filterStorageKey, filter);

      state = state.copyWith(selectedFilter: filter, isLoading: false);
      debugPrint('✅ تم حفظ الفلتر: $filter');
    } catch (e) {
      debugPrint('❌ خطأ في حفظ الفلتر: $e');
      state = state.copyWith(
        error: 'فشل حفظ الفلتر',
        isLoading: false,
      );
    }
  }

  /// إعادة تعيين الفلتر إلى الافتراضي
  Future<void> resetFilter() async {
    await setFilter(_defaultFilter);
  }
}
