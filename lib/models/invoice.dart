import 'invoice_item.dart';

class Invoice {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String customerName;
  final List<InvoiceItem> items;
  final double discount;
  final double paidAmount;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.customerName,
    required this.items,
    this.discount = 0,
    this.paidAmount = 0,
  });

  double get subtotal {
    return items.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  double get total => subtotal - discount;

  double get remainingAmount => total - paidAmount;
}
