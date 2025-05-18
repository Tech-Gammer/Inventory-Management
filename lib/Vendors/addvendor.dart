import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';

class AddVendorPage extends StatefulWidget {
  @override
  _AddVendorPageState createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void saveVendor() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vendor name is required")));
      return;
    }

    final vendor = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'phone_number': phoneController.text.trim(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/vendors'), // ✅ Use lowercase `vendors`
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vendor),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add vendor")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Vendor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Vendor Name')),
            TextField(controller: addressController, decoration: InputDecoration(labelText: 'Address')),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveVendor, child: Text('Save Vendor')),
          ],
        ),
      ),
    );
  }
}
