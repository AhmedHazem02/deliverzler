class AppStore {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String category;

  AppStore({
    required this.id,
    required this.name,
    required this.address,
    this.phone = '',
    this.category = '',
  });
}
