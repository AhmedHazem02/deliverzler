import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../presentation/utils/riverpod_framework.dart';
import '../error/app_exception.dart';
import 'extensions/local_error_extension.dart';

part 'image_picker_facade.g.dart';

enum PickSource {
  camera,
  gallery,
}

/// Cross-platform image data
class PickedImageData {
  const PickedImageData({
    required this.bytes,
    required this.filename,
  });

  final Uint8List bytes;
  final String filename;
}

@Riverpod(keepAlive: true)
ImagePickerFacade imagePickerFacade(Ref ref) {
  return ImagePickerFacade(
    imagePicker: ImagePicker(),
  );
}

class ImagePickerFacade {
  ImagePickerFacade({required this.imagePicker});

  final ImagePicker imagePicker;

  Future<PickedImageData> pickImage({
    required PickSource pickSource,
    double? maxHeight,
    double? maxWidth,
  }) async {
    return _errorHandler(
      () async {
        final pickedFile = await imagePicker.pickImage(
          source: pickSource == PickSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        );
        if (pickedFile != null) {
          // Read as bytes - works on all platforms including web
          final bytes = await pickedFile.readAsBytes();
          return PickedImageData(
            bytes: bytes,
            filename: pickedFile.name,
          );
        } else {
          throw const CacheException(
            type: CacheExceptionType.general,
            message: "Couldn't Pick Image",
          );
        }
      },
    );
  }

  Future<T> _errorHandler<T>(Future<T> Function() body) async {
    try {
      return await body.call();
    } catch (e, st) {
      final error = e.localErrorToCacheException();
      throw Error.throwWithStackTrace(error, st);
    }
  }
}
