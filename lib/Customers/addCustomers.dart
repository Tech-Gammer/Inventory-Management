import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';

class AddCustomerPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const AddCustomerPage({Key? key, this.data}) : super(key: key);

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void saveCustomer() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Customer name is required")));
      return;
    }

    final customer = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'phone_number': phoneController.text.trim(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/customers'), // ✅ Use lowercase `customer`
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add customer")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Customer Name')),
            TextField(controller: addressController, decoration: InputDecoration(labelText: 'Address')),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveCustomer, child: Text('Save Customer')),
          ],
        ),
      ),
    );
  }
}
