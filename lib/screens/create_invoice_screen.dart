import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/invoice_item.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final customerController = TextEditingController();
  final discountController = TextEditingController();

  final List<Item> inventory = [
    Item(
      id: '1',
      name: 'Sample Earbuds',
      categoryId: '2',
      price: 1200,
      stock: 20,
    ),
    Item(
      id: '2',
      name: 'Data Cable',
      categoryId: '2',
      price: 500,
      stock: 30,
    ),
    Item(
      id: '3',
      name: 'Watch',
      categoryId: '3',
      price: 1800,
      stock: 10,
    ),
  ];

  final List<InvoiceItem> invoiceItems = [];

  double get subtotal {
    return invoiceItems.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  double get discount {
    return double.tryParse(discountController.text) ?? 0;
  }

  double get grandTotal {
    final total = subtotal - discount;
    return total < 0 ? 0 : total;
  }

  void addItem(Item item) {
    final existingIndex = invoiceItems.indexWhere(
      (invoiceItem) => invoiceItem.itemId == item.id,
    );

    setState(() {
      if (existingIndex == -1) {
        invoiceItems.add(
          InvoiceItem(
            itemId: item.id,
            itemName: item.name,
            price: item.price,
            quantity: 1,
          ),
        );
      } else {
        final existing = invoiceItems[existingIndex];

        if (existing.quantity < item.stock) {
          invoiceItems[existingIndex] = InvoiceItem(
            itemId: existing.itemId,
            itemName: existing.itemName,
            price: existing.price,
            quantity: existing.quantity + 1,
            discount: existing.discount,
          );
        }
      }
    });
  }

  void increaseQuantity(int index) {
    final current = invoiceItems[index];

    final stockItem = inventory.firstWhere(
      (item) => item.id == current.itemId,
    );

    if (current.quantity >= stockItem.stock) return;

    setState(() {
      invoiceItems[index] = InvoiceItem(
        itemId: current.itemId,
        itemName: current.itemName,
        price: current.price,
        quantity: current.quantity + 1,
        discount: current.discount,
      );
    });
  }

  void decreaseQuantity(int index) {
    final current = invoiceItems[index];

    setState(() {
      if (current.quantity > 1) {
        invoiceItems[index] = InvoiceItem(
          itemId: current.itemId,
          itemName: current.itemName,
          price: current.price,
          quantity: current.quantity - 1,
          discount: current.discount,
        );
      } else {
        invoiceItems.removeAt(index);
      }
    });
  }

  void showItemSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      final item = inventory[index];

                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.inventory_2_outlined),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Stock: ${item.stock} ${item.unit}',
                        ),
                        trailing: Text(
                          'Rs ${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          addItem(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveInvoice() {
    if (invoiceItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invoice saved — Total: Rs ${grandTotal.toStringAsFixed(0)}',
        ),
      ),
    );
  }

  @override
  void dispose() {
    customerController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Invoice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: customerController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: showItemSelector,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        'Select Item',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Invoice Items',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (invoiceItems.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No items added',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    ...invoiceItems.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rs ${item.price.toStringAsFixed(0)} × ${item.quantity}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        decreaseQuantity(index);
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        increaseQuantity(index);
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Invoice Discount',
                      prefixText: 'Rs ',
                      prefixIcon: Icon(Icons.discount_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _summaryRow(
                            'Subtotal',
                            'Rs ${subtotal.toStringAsFixed(0)}',
                          ),
                          const SizedBox(height: 10),
                          _summaryRow(
                            'Discount',
                            'Rs ${discount.toStringAsFixed(0)}',
                          ),
                          const Divider(height: 24),
                          _summaryRow(
                            'Grand Total',
                            'Rs ${grandTotal.toStringAsFixed(0)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: saveInvoice,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save Invoice',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 19 : 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
