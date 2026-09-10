class InvoiceItem {
  final String itemId;
  final String itemName;
  final double price;
  final int quantity;
  final double discount;

  InvoiceItem({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.discount = 0,
  });

  double get subtotal => price * quantity;

  double get total => subtotal - discount;
}
