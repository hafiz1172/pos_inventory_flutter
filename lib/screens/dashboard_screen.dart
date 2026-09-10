import 'package:flutter/material.dart';
import '../items_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'POS & Inventory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage your business easily',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _card(
                    Icons.inventory_2_outlined,
                    'Items',
                    '0',
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _card(
                    Icons.receipt_long_outlined,
                    'Invoices',
                    '0',
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _card(
                    Icons.shopping_cart_outlined,
                    'Sales',
                    'Rs 0',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _card(
                    Icons.category_outlined,
                    'Categories',
                    '0',
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _action(
              context,
              Icons.add_shopping_cart,
              'Create Invoice',
              () {},
            ),

            const SizedBox(height: 10),

            _action(
              context,
              Icons.inventory_2,
              'Manage Inventory',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ItemsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _action(
              context,
              Icons.history,
              'Invoice History',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
