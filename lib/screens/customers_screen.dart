import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final List<Customer> customers = [];

  void showCustomerDialog({Customer? existingCustomer}) {
    final nameController =
        TextEditingController(text: existingCustomer?.name ?? '');
    final phoneController =
        TextEditingController(text: existingCustomer?.phone ?? '');
    final addressController =
        TextEditingController(text: existingCustomer?.address ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existingCustomer == null
                ? 'Add Customer'
                : 'Edit Customer',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
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

                if (name.isEmpty) return;

                final customer = Customer(
                  id: existingCustomer?.id ??
                      DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(),
                  name: name,
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );

                setState(() {
                  if (existingCustomer == null) {
                    customers.add(customer);
                  } else {
                    final index = customers.indexWhere(
                      (item) => item.id == existingCustomer.id,
                    );

                    if (index != -1) {
                      customers[index] = customer;
                    }
                  }
                });

                Navigator.pop(context);
              },
              child: Text(
                existingCustomer == null ? 'Add' : 'Update',
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteCustomer(Customer customer) {
    setState(() {
      customers.removeWhere(
        (item) => item.id == customer.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: customers.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No customers yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Add customers to use them on invoices',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    title: Text(
                      customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      customer.phone.isEmpty
                          ? 'No phone number'
                          : customer.phone,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showCustomerDialog(
                            existingCustomer: customer,
                          );
                        } else if (value == 'delete') {
                          deleteCustomer(customer);
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
        onPressed: () => showCustomerDialog(),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Customer'),
      ),
    );
  }
}
