import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';

class VendorListPage extends StatelessWidget {
  const VendorListPage({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchVendors() async {
    final response = await http.get(Uri.parse('$baseUrl/api/vendors'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load vendors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendors')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchVendors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final vendors = snapshot.data!;
          return ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return ListTile(
                title: Text(vendor['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vendor['address'] != null) Text('Address: ${vendor['address']}'),
                    if (vendor['phone_number'] != null) Text('Phone: ${vendor['phone_number']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
