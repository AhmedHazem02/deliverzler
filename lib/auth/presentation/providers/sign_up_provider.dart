import 'package:flutter/foundation.dart';

import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../infrastructure/repos/auth_repo.dart';
import '../../../core/infrastructure/error/app_exception.dart';
import '../../domain/user.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUpState extends _$SignUpState {
  @override
  FutureOr<Option<User>> build() => const None();

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    debugPrint('🔵 [SignUp Provider] Starting signup process...');
    debugPrint('🔵 [SignUp Provider] Email: $email, Name: $name');
    
    state = const AsyncLoading();

    try {
      final authRepo = ref.read(authRepoProvider);
      debugPrint('🔵 [SignUp Provider] Got authRepo');
      // Create user account
      debugPrint('🔵 [SignUp Provider] Step 1: Calling registerWithEmail...');
      final user = await authRepo.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
      debugPrint('✅ [SignUp Provider] Step 1 SUCCESS: User created with ID: ${user.id}');

      // Send email verification immediately
      debugPrint('🔵 [SignUp Provider] Step 2: Sending email verification...');
      await authRepo.sendEmailVerification();
      debugPrint('✅ [SignUp Provider] Step 2 SUCCESS: Verification email sent');

      debugPrint('🔵 [SignUp Provider] Step 3: Getting full user data...');
      final fullUser = await authRepo.getUserData(user.id);
      debugPrint('✅ [SignUp Provider] Step 3 SUCCESS: Got user data');

      // Note: We don't authenticate the user here because:
      // 1. Email needs to be verified first
      // 2. Account needs admin approval
      // User will be redirected to email verification screen

      debugPrint('✅ [SignUp Provider] ALL STEPS COMPLETED!');
      state = AsyncData(Some(fullUser));
    } catch (e, st) {
      if (e is AppException) {
        debugPrint('❌ [SignUp Provider] Handled Error: ${e.message}');
        state = AsyncError(e, st);
      } else {
        debugPrint('❌ [SignUp Provider] CAUGHT ERROR: $e');
        debugPrint('❌ [SignUp Provider] Stack: $st');
        
        // Convert error to safe string to avoid JS interop TypeErrors
        final errString = e.toString();
        state = AsyncError(errString, st);
      }
    }
  }
}
