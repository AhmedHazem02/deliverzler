import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../extensions/firebase_error_extension.dart';

part 'firebase_firestorage_facade.g.dart';

//Our main API is Firebase
@Riverpod(keepAlive: true)
FirebaseStorageFacade firebaseStorageFacade(Ref ref) {
  return FirebaseStorageFacade(
    firebaseStorage: FirebaseStorage.instance,
  );
}

class FirebaseStorageFacade {
  FirebaseStorageFacade({
    required this.firebaseStorage,
  });

  final FirebaseStorage firebaseStorage;

  /// Upload image from bytes (works on all platforms including web)
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    String? filename,
  }) async {
    return await _errorHandler(
      () async {
        final uploadTask = firebaseStorage.ref().child(path).putData(
              bytes,
              SettableMetadata(
                contentType: 'image/${filename?.split('.').last ?? 'png'}',
              ),
            );
        final downloadURL = await (await uploadTask).ref.getDownloadURL();
        return downloadURL;
      },
    );
  }

  Future<void> deleteImage({required String path}) async {
    return await _errorHandler(
      () async {
        return firebaseStorage.ref().child(path).delete();
      },
    );
  }

  Future<void> deleteAllFolderImages({required String path}) async {
    return await _errorHandler(
      () async {
        return firebaseStorage.ref().child(path).listAll().then(
          (result) {
            for (final file in result.items) {
              file.delete();
            }
          },
        );
      },
    );
  }

  FutureOr<T> _errorHandler<T>(FutureOr<T> Function() body) async {
    try {
      return await body();
    } catch (e, st) {
      final error = e.firebaseErrorToServerException();
      throw Error.throwWithStackTrace(error, st);
    }
  }
}
