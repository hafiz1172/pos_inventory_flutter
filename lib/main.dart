import 'package:flutter/material.dart';
import 'items_screen.dart';

void main() {
  runApp(const POSApp());
}

class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS & Inventory',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const DashboardScreen(),
    );
  }
}

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
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    Icons.inventory_2_outlined,
                    'Items',
                    '0',
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: dashboardCard(
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
                  child: dashboardCard(
                    Icons.shopping_cart_outlined,
                    'Sales',
                    'Rs 0',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: dashboardCard(
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

            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Create Invoice',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItemsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.inventory_2),
                label: const Text(
                  'Manage Inventory',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history),
                label: const Text(
                  'Invoice History',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
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
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
