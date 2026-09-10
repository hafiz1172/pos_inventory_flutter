import '../models/category.dart';
import '../models/item.dart';
import '../models/customer.dart';
import '../models/invoice.dart';
import '../models/business_settings.dart';

class AppData {
  static final AppData instance = AppData._internal();

  AppData._internal();

  final List<Category> categories = [];

  final List<Item> items = [];

  final List<Customer> customers = [];

  final List<Invoice> invoices = [];

  BusinessSettings? businessSettings;

  int get totalItems => items.length;

  int get totalCategories => categories.length;

  int get totalCustomers => customers.length;

  int get totalInvoices => invoices.length;

  double get totalSales {
    return invoices.fold(
      0,
      (sum, invoice) => sum + invoice.total,
    );
  }

  void addCategory(Category category) {
    categories.add(category);
  }

  void addItem(Item item) {
    items.add(item);
  }

  void addCustomer(Customer customer) {
    customers.add(customer);
  }

  void addInvoice(Invoice invoice) {
    invoices.add(invoice);
  }

  void updateBusinessSettings(
    BusinessSettings settings,
  ) {
    businessSettings = settings;
  }
}
