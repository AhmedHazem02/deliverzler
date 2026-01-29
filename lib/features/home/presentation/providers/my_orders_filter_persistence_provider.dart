import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'my_orders_filter_persistence_provider.freezed.dart';

/// حالة الفلتر
@freezed
class MyOrdersFilterState with _$MyOrdersFilterState {
  const factory MyOrdersFilterState({
    required String selectedFilter, // 'all', 'pending', 'in_progress', 'delivered'
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _MyOrdersFilterState;
}

/// مفتاح التخزين
const String _filterStorageKey = 'my_orders_filter';
const String _defaultFilter = 'all';

/// موفر حالة الفلتر مع المثابرة
final myOrdersFilterProvider =
    StateNotifierProvider.autoDispose<MyOrdersFilterNotifier, MyOrdersFilterState>(
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
    } catch (e) {
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
    } catch (e) {
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
