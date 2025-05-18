import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_config.dart';

class AddUnitPage extends StatefulWidget {
  @override
  _AddUnitPageState createState() => _AddUnitPageState();
}

class _AddUnitPageState extends State<AddUnitPage> {
  final TextEditingController unitNameController = TextEditingController();

  void saveUnit() async {
    if (unitNameController.text.trim().isEmpty) return;
    final response = await http.post(
      Uri.parse('$baseUrl/api/units'),//s
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': unitNameController.text.trim()}),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add unit")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Unit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: unitNameController, decoration: InputDecoration(labelText: 'Unit Name')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveUnit, child: Text('Save Unit'))
          ],
        ),
      ),
    );
  }
}
