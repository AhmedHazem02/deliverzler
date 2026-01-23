import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required String? routeLocation,
    required Map<String, dynamic>? data,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}

@riverpod
Option<NotificationPayload> tappedNotification(Ref ref) {
  // Return a constant empty state
  // Actual state should be managed by a Notifier provider
  return const None();
}
