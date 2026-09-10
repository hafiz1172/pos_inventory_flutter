import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'models/category.dart';
import 'models/item.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final AppData appData = AppData.instance;

  void showItemDialog({Item? existingItem}) {
    final nameController =
        TextEditingController(text: existingItem?.name ?? '');
    final priceController = TextEditingController(
      text: existingItem == null
          ? ''
          : existingItem.price.toStringAsFixed(0),
    );
    final stockController = TextEditingController(
      text: existingItem == null ? '' : '${existingItem.stock}',
    );
    final unitController =
        TextEditingController(text: existingItem?.unit ?? 'pcs');

    String? categoryId = existingItem?.categoryId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
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
                      value: appData.categories.any(
                        (category) => category.id == categoryId,
                      )
                          ? categoryId
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: appData.categories.map(
                        (category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        dialogSetState(() {
                          categoryId = value;
                        });
                      },
                    ),
                    if (appData.categories.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add a category first.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price',
                        prefixText: 'Rs ',
                        prefixIcon: Icon(Icons.payments_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        prefixIcon: Icon(Icons.inventory_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        prefixIcon: Icon(Icons.straighten_outlined),
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

                    if (name.isEmpty ||
                        price == null ||
                        stock == null ||
                        price < 0 ||
                        stock < 0) {
                      return;
                    }

                    if (appData.categories.isNotEmpty &&
                        categoryId == null) {
                      return;
                    }

                    final item = Item(
                      id: existingItem?.id ??
                          DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                      name: name,
                      categoryId: categoryId ?? '',
                      price: price,
                      stock: stock,
                      unit: unit.isEmpty ? 'pcs' : unit,
                    );

                    setState(() {
                      if (existingItem == null) {
                        appData.addItem(item);
                      } else {
                        final index = appData.items.indexWhere(
                          (oldItem) => oldItem.id == existingItem.id,
                        );

                        if (index != -1) {
                          appData.items[index] = item;
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
      appData.items.removeWhere(
        (oldItem) => oldItem.id == item.id,
      );
    });
  }

  String categoryName(String categoryId) {
    final index = appData.categories.indexWhere(
      (category) => category.id == categoryId,
    );

    if (index == -1) {
      return 'Uncategorized';
    }

    return appData.categories[index].name;
  }

  @override
  Widget build(BuildContext context) {
    final items = appData.items;

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
                    'Add products to your inventory',
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
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2_outlined),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${categoryName(item.categoryId)} • '
                      'Stock: ${item.stock} ${item.unit}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showItemDialog(existingItem: item);
                        } else if (value == 'delete') {
                          deleteItem(item);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
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
