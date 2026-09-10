import 'package:flutter/material.dart';
import '../models/business_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String currency = 'Rs';

  BusinessSettings? settings;

  void saveSettings() {
    final name = businessNameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter business name'),
        ),
      );
      return;
    }

    setState(() {
      settings = BusinessSettings(
        businessName: name,
        phone: phone,
        address: address,
        currency: currency,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Business settings saved'),
      ),
    );
  }

  @override
  void dispose() {
    businessNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'This information will be used on invoices.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                prefixIcon: Icon(Icons.store_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Business Address',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: currency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                prefixIcon: Icon(Icons.currency_exchange),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Rs',
                  child: Text('Rs — Pakistani Rupee'),
                ),
                DropdownMenuItem(
                  value: '\$',
                  child: Text('\$ — US Dollar'),
                ),
                DropdownMenuItem(
                  value: '€',
                  child: Text('€ — Euro'),
                ),
                DropdownMenuItem(
                  value: '£',
                  child: Text('£ — Pound'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    currency = value;
                  });
                }
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: saveSettings,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            if (settings != null) ...[
              const SizedBox(height: 30),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        settings!.businessName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (settings!.phone.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 6),
                          child: Text(settings!.phone),
                        ),

                      if (settings!.address.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 6),
                          child: Text(settings!.address),
                        ),

                      Padding(
                        padding:
                            const EdgeInsets.only(top: 6),
                        child: Text(
                          'Currency: ${settings!.currency}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
