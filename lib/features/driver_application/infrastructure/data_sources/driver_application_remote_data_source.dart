import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/infrastructure/services/supabase_storage_service.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/driver_application.dart';
import '../dtos/driver_application_dto.dart';

part 'driver_application_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
DriverApplicationRemoteDataSource driverApplicationRemoteDataSource(
  Ref ref,
) {
  return DriverApplicationRemoteDataSource(
    ref,
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
    supabaseStorage: ref.watch(supabaseStorageServiceProvider),
  );
}

class DriverApplicationRemoteDataSource {
  DriverApplicationRemoteDataSource(
    this.ref, {
    required this.firebaseFirestore,
    required this.supabaseStorage,
  });

  final Ref ref;
  final FirebaseFirestoreFacade firebaseFirestore;
  final SupabaseStorageService supabaseStorage;

  static const String applicationsCollectionPath = 'drivers';

  static String applicationDocPath(String applicationId) =>
      '$applicationsCollectionPath/$applicationId';

  /// Submit a new driver application
  Future<String> submitApplication(DriverApplicationDto applicationDto) async {
    final applicationId = await firebaseFirestore.addDataToCollection(
      path: applicationsCollectionPath,
      data: applicationDto.toFirestore(),
    );
    return applicationId;
  }

  /// Get application by user ID
  Future<DriverApplicationDto?> getApplicationByUserId(String userId) async {
    try {
      final querySnapshot = await firebaseFirestore.getCollectionData(
        path: applicationsCollectionPath,
        queryBuilder: (query) =>
            query.where('userId', isEqualTo: userId).limit(1),
      );

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return DriverApplicationDto.fromFirestore(
          querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      throw Exception(
          'فشل تحميل طلب التقديم. تأكد من اتصالك بالإنترنت: ${e.toString()}');
    }
  }

  /// Get application by ID
  Future<DriverApplicationDto?> getApplicationById(String applicationId) async {
    final docSnapshot = await firebaseFirestore.getData(
      path: applicationDocPath(applicationId),
    );

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return null;
    }

    return DriverApplicationDto.fromFirestore(
      docSnapshot as DocumentSnapshot<Map<String, dynamic>>,
    );
  }

  /// Watch application status changes in real-time
  Stream<DriverApplication?> watchApplicationByUserId(String userId) {
    return firebaseFirestore
        .collectionStream(
      path: applicationsCollectionPath,
      queryBuilder: (query) =>
          query.where('userId', isEqualTo: userId).limit(1),
    )
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      final dto = DriverApplicationDto.fromFirestore(
          querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);
      return dto.toDomain();
    }).handleError((error, stackTrace) {
      // Log the error for debugging
      print('Error watching application: $error');
      // Return null instead of throwing to allow graceful handling
      return null;
    });
  }

  /// Update an existing application
  Future<void> updateApplication({
    required String applicationId,
    required Map<String, dynamic> data,
  }) async {
    await firebaseFirestore.updateData(
      path: applicationDocPath(applicationId),
      data: data,
    );
  }

  /// Upload a document file to Supabase Storage
  Future<String> uploadDocument({
    required String userId,
    required String documentType,
    dynamic file,
    XFile? webFile,
  }) async {
    return supabaseStorage.uploadDocument(
      userId: userId,
      documentType: documentType,
      file: file,
      webFile: webFile,
    );
  }

  /// Upload multiple documents at once
  Future<Map<String, String>> uploadMultipleDocuments({
    required String userId,
    required Map<String, dynamic> documents,
  }) async {
    return supabaseStorage.uploadMultipleDocuments(
      userId: userId,
      documents: documents,
    );
  }

  /// Delete a document from Supabase Storage
  Future<void> deleteDocument(String filePath) async {
    await supabaseStorage.deleteDocument(filePath);
  }

  /// Delete all documents for a user
  Future<void> deleteUserDocuments(String userId) async {
    await supabaseStorage.deleteUserDocuments(userId);
  }
}
