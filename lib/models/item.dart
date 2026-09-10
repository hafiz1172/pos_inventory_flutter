class Item {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int stock;
  final String unit;

  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.unit = 'pcs',
  });
}
