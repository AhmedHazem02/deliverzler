import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../dtos/rejection_request_dto.dart';

part 'rejection_requests_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
RejectionRequestsRemoteDataSource rejectionRequestsRemoteDataSource(Ref ref) {
  return RejectionRequestsRemoteDataSource(
    ref,
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

class RejectionRequestsRemoteDataSource {
  RejectionRequestsRemoteDataSource(
    this.ref, {
    required this.firebaseFirestore,
  });

  final Ref ref;
  final FirebaseFirestoreFacade firebaseFirestore;

  static const String rejectionRequestsCollectionPath = 'rejection_requests';

  static String rejectionRequestDocPath(String id) =>
      '$rejectionRequestsCollectionPath/$id';

  /// Create a new rejection request.
  Future<String> createRejectionRequest(RejectionRequestDto request) async {
    try {
      final docRef = await firebaseFirestore.addDataToCollection(
        path: rejectionRequestsCollectionPath,
        data: request.toJson(),
      );
      return docRef;
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to create rejection request: $e',
      );
    }
  }

  /// Get rejection request by ID.
  Future<RejectionRequestDto> getRejectionRequest(String requestId) async {
    try {
      final response = await firebaseFirestore.getData(
        path: rejectionRequestDocPath(requestId),
      );

      if (response.data() != null) {
        return RejectionRequestDto.fromFirestore(response);
      } else {
        throw const ServerException(
          type: ServerExceptionType.notFound,
          message: 'Rejection request not found.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Stream all pending rejection requests (for admin dashboard).
  Stream<List<RejectionRequestDto>> getPendingRejectionRequests() {
    return firebaseFirestore
        .collectionStream(
      path: rejectionRequestsCollectionPath,
      queryBuilder: (query) => query
          .where('adminDecision', isEqualTo: AdminDecision.pending.jsonValue)
          .orderBy('createdAt', descending: true)
          .limit(100),
    )
        .map((snapshot) {
      return RejectionRequestDto.parseListOfDocument(snapshot.docs);
    });
  }

  /// Stream rejection requests for a specific driver.
  Stream<List<RejectionRequestDto>> getDriverRejectionRequests(
    String driverId,
  ) {
    return firebaseFirestore
        .collectionStream(
      path: rejectionRequestsCollectionPath,
      queryBuilder: (query) => query
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .limit(50),
    )
        .map((snapshot) {
      return RejectionRequestDto.parseListOfDocument(snapshot.docs);
    });
  }

  /// Update rejection request (admin decision).
  Future<void> updateRejectionRequest({
    required String requestId,
    required AdminDecision adminDecision,
    String? adminComment,
  }) async {
    try {
      await firebaseFirestore.updateData(
        path: rejectionRequestDocPath(requestId),
        data: {
          'adminDecision': adminDecision.jsonValue,
          if (adminComment != null) 'adminComment': adminComment,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to update rejection request: $e',
      );
    }
  }

  /// Delete rejection request (optional - for cleanup).
  Future<void> deleteRejectionRequest(String requestId) async {
    try {
      await firebaseFirestore.deleteData(
        path: rejectionRequestDocPath(requestId),
      );
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to delete rejection request: $e',
      );
    }
  }
}
