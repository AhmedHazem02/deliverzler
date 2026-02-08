class AppStore {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String category;
  final double? latitude;
  final double? longitude;

  AppStore({
    required this.id,
    required this.name,
    required this.address,
    this.phone = '',
    this.category = '',
    this.latitude,
    this.longitude,
  });

  /// Whether this store has valid location coordinates.
  bool get hasLocation => latitude != null && longitude != null;
}
