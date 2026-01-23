import 'dart:io';

import '../../../core/infrastructure/local/image_picker_facade.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';

part 'profile_service.g.dart';

@Riverpod(keepAlive: true)
ProfileService profileService(Ref ref) {
  return ProfileService(
    ref: ref,
  );
}

class ProfileService {
  ProfileService({required this.ref});

  final Ref ref;

  Future<File> pickProfileImage(PickSource pickSource) async {
    return ref.read(imagePickerFacadeProvider).pickImage(
          pickSource: pickSource,
          maxHeight: 400,
          maxWidth: 400,
        );
  }
}

