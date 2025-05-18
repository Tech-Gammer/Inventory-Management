import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_config.dart';

class UnitListPage extends StatelessWidget {
  const UnitListPage({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchUnits() async {
    final response = await http.get(Uri.parse('$baseUrl/api/units'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load units');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Units')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUnits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final units = snapshot.data!;
          return ListView.builder(
            itemCount: units.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(units[index]['name']),
            ),
          );
        },
      ),
    );
  }
}
