import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../auth/domain/user.dart';
import '../../../auth/infrastructure/repos/auth_repo.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../auth/presentation/providers/sign_out_provider.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';

part 'check_auth_provider.g.dart';

@riverpod
Future<User> checkAuth(Ref ref) async {
  dev.log('checkAuth: Starting...');

  try {
    final sub = ref.listen(authStateProvider.notifier, (prev, next) {});

    final uid = await ref.watch(authRepoProvider).getUserAuthUid();
    dev.log('checkAuth: Got uid: $uid');

    final user = await ref.watch(authRepoProvider).getUserData(uid);
    dev.log('checkAuth: Got user: ${user.name}');

    // Authenticate user after getting data
    sub.read().authenticateUser(user);

    return user;
  } catch (e, st) {
    dev.log('checkAuth: Error: $e');
    // On web, Firebase auth might fail due to tracking prevention
    if (kIsWeb) {
      dev.log('checkAuth: Web platform - throwing auth error');
    }
    rethrow;
  }
}
