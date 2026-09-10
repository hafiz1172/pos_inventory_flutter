import 'package:flutter/material.dart';
import 'models/item.dart';
import 'models/category.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final List<Category> categories = [
    Category(id: '1', name: 'General'),
    Category(id: '2', name: 'Electronics'),
    Category(id: '3', name: 'Accessories'),
  ];

  final List<Item> items = [];

  void showItemDialog({Item? existingItem}) {
    final nameController =
        TextEditingController(text: existingItem?.name ?? '');
    final priceController = TextEditingController(
      text: existingItem != null ? existingItem.price.toString() : '',
    );
    final stockController = TextEditingController(
      text: existingItem != null ? existingItem.stock.toString() : '',
    );
    final unitController =
        TextEditingController(text: existingItem?.unit ?? 'pcs');

    String selectedCategoryId =
        existingItem?.categoryId ?? categories.first.id;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existingItem == null ? 'Add Item' : 'Edit Item',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategoryId = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price',
                        prefixText: 'Rs ',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        hintText: 'pcs, box, kg, etc.',
                        prefixIcon: Icon(Icons.straighten),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price =
                        double.tryParse(priceController.text.trim());
                    final stock =
                        int.tryParse(stockController.text.trim());
                    final unit = unitController.text.trim();

                    if (name.isEmpty || price == null || stock == null) {
                      return;
                    }

                    setState(() {
                      if (existingItem == null) {
                        items.add(
                          Item(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: name,
                            categoryId: selectedCategoryId,
                            price: price,
                            stock: stock,
                            unit: unit.isEmpty ? 'pcs' : unit,
                          ),
                        );
                      } else {
                        final index = items.indexWhere(
                          (item) => item.id == existingItem.id,
                        );

                        if (index != -1) {
                          items[index] = Item(
                            id: existingItem.id,
                            name: name,
                            categoryId: selectedCategoryId,
                            price: price,
                            stock: stock,
                            unit: unit.isEmpty ? 'pcs' : unit,
                          );
                        }
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    existingItem == null ? 'Add' : 'Update',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteItem(Item item) {
    setState(() {
      items.removeWhere((element) => element.id == item.id);
    });
  }

  String getCategoryName(String categoryId) {
    final category = categories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => categories.first,
    );

    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No items yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Add your first inventory item',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        item.name.isNotEmpty
                            ? item.name[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${getCategoryName(item.categoryId)} • '
                      'Stock: ${item.stock} ${item.unit}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs ${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                showItemDialog(existingItem: item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                              ),
                              onPressed: () {
                                deleteItem(item);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showItemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
