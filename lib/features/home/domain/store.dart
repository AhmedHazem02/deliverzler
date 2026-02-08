class AppStore {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String category;
  final double? latitude;
  final double? longitude;

  AppStore({
    required this.id,
    required this.name,
    required this.address,
    this.city = '',
    this.phone = '',
    this.category = '',
    this.latitude,
    this.longitude,
  });

  /// Whether this store has valid location coordinates.
  bool get hasLocation => latitude != null && longitude != null;

  /// Full address combining street address and city.
  String get fullAddress {
    if (address.isNotEmpty && city.isNotEmpty) {
      return '$address، $city';
    }
    return address.isNotEmpty ? address : city;
  }
}
