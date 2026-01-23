/// Remote data source for App Settings.
///
/// Fetches settings from Firebase Firestore `settings/app_config` document,
/// which is the same collection used by Admin Dashboard.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../dtos/app_settings_dto.dart';

part 'app_settings_remote_data_source.g.dart';

/// Firestore collection and document paths.
const String _settingsCollection = 'settings';
const String _appConfigDocument = 'app_config';

@Riverpod(keepAlive: true)
AppSettingsRemoteDataSource appSettingsRemoteDataSource(Ref ref) {
  return AppSettingsRemoteDataSource(
    firestore: FirebaseFirestore.instance,
  );
}

/// Remote data source for fetching app settings from Firebase.
class AppSettingsRemoteDataSource {
  AppSettingsRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Document reference for app settings.
  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _firestore.collection(_settingsCollection).doc(_appConfigDocument);

  /// Fetches app settings from Firebase.
  ///
  /// Returns null if document doesn't exist.
  Future<AppSettingsDto?> getSettings() async {
    final doc = await _settingsDoc.get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AppSettingsDto.fromJson(doc.data()!);
  }

  /// Streams app settings changes in real-time.
  ///
  /// Emits null if document doesn't exist.
  Stream<AppSettingsDto?> watchSettings() {
    return _settingsDoc.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return AppSettingsDto.fromJson(snapshot.data()!);
    });
  }
}
