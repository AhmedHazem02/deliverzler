import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/utils/riverpod_framework.dart';

part 'supabase_storage_service.g.dart';

/// Supabase Storage bucket name for driver documents
const String _driverDocumentsBucket = 'driver-documents';

@Riverpod(keepAlive: true)
SupabaseStorageService supabaseStorageService(Ref ref) {
  return SupabaseStorageService();
}

/// Service for handling file uploads to Supabase Storage.
///
/// This service handles uploading driver application documents
/// such as photos, ID documents, licenses, etc.
class SupabaseStorageService {
  SupabaseStorageService();

  SupabaseClient get _client => Supabase.instance.client;
  SupabaseStorageClient get _storage => _client.storage;

  /// Upload a file to Supabase Storage.
  ///
  /// [userId] - The user's ID (used for organizing files)
  /// [documentType] - Type of document (photo, idDocument, license, etc.)
  /// [file] - The file to upload (for mobile)
  /// [webFile] - The XFile to upload (for web)
  ///
  /// Returns the public URL of the uploaded file.
  Future<String> uploadDocument({
    required String userId,
    required String documentType,
    dynamic file, // dart:io File on mobile, null on web
    XFile? webFile,
  }) async {
    if (file == null && webFile == null) {
      throw ArgumentError('Either file or webFile must be provided');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = _getFileExtension(file?.path ?? webFile!.path);
    final fileName = '$userId/$documentType\_$timestamp$extension';

    try {
      if (kIsWeb && webFile != null) {
        // Web upload
        final bytes = await webFile.readAsBytes();
        await _storage.from(_driverDocumentsBucket).uploadBinary(
              fileName,
              bytes,
              fileOptions: FileOptions(
                contentType: _getContentType(extension),
                upsert: true,
              ),
            );
      } else if (file != null) {
        // Mobile upload
        // Cast to dynamic to avoid 'dart:io' linking on web
        final dynamic storageBuilder = _storage.from(_driverDocumentsBucket);
        await storageBuilder.upload(
              fileName,
              file,
              fileOptions: FileOptions(
                contentType: _getContentType(extension),
                upsert: true,
              ),
            );
      }

      // Get the public URL
      final publicUrl =
          _storage.from(_driverDocumentsBucket).getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Failed to upload document: ${e.message}');
    }
  }

  /// Upload multiple documents at once.
  ///
  /// Returns a map of document type to public URL.
  Future<Map<String, String>> uploadMultipleDocuments({
    required String userId,
    required Map<String, dynamic> documents,
  }) async {
    final urls = <String, String>{};

    for (final entry in documents.entries) {
      if (entry.value == null) continue;

      final url = await uploadDocument(
        userId: userId,
        documentType: entry.key,
        file: entry.value is XFile ? null : entry.value, // Assume File if not XFile
        webFile: entry.value is XFile ? entry.value as XFile : null,
      );
      urls[entry.key] = url;
    }

    return urls;
  }

  /// Delete a document from storage.
  Future<void> deleteDocument(String filePath) async {
    try {
      await _storage.from(_driverDocumentsBucket).remove([filePath]);
    } on StorageException catch (e) {
      throw Exception('Failed to delete document: ${e.message}');
    }
  }

  /// Delete all documents for a user.
  Future<void> deleteUserDocuments(String userId) async {
    try {
      final files = await _storage.from(_driverDocumentsBucket).list(
            path: userId,
          );

      if (files.isNotEmpty) {
        final filePaths = files.map((f) => '$userId/${f.name}').toList();
        await _storage.from(_driverDocumentsBucket).remove(filePaths);
      }
    } on StorageException catch (e) {
      throw Exception('Failed to delete user documents: ${e.message}');
    }
  }

  String _getFileExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1) return '.jpg';
    return path.substring(lastDot).toLowerCase();
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
