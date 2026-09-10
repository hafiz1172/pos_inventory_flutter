class BusinessSettings {
  final String businessName;
  final String phone;
  final String address;
  final String currency;

  BusinessSettings({
    required this.businessName,
    this.phone = '',
    this.address = '',
    this.currency = 'Rs',
  });
}
