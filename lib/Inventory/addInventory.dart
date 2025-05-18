import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Vendors/addvendor.dart';
import '../api_config.dart';
import '../dashboard.dart';
import '../unit/addUnit.dart';

class AddInventoryItemPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const AddInventoryItemPage({Key? key, this.data}) : super(key: key);

  @override
  _AddInventoryItemPageState createState() => _AddInventoryItemPageState();
}

class _AddInventoryItemPageState extends State<AddInventoryItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> units = [];
  List<String> vendors = [];

  @override
  void initState()  {
    if(widget.data != null){
      nameController.text = widget.data!['name'];
      barcodeController.text = widget.data!['barcode'];
      unitController.text = widget.data!['unit'];
      costPriceController.text = widget.data!['cost_price'].toString();
      salePriceController.text = widget.data!['sale_price'].toString();
      taxController.text = widget.data!['tax'].toString();
      vendorController.text = widget.data!['vendor'];
      qtyController.text = widget.data!['qty_on_hand'].toString();
      descriptionController.text = widget.data!['description'];
    }
    // ✅ Call this to load unit and vendor lists
    fetchUnitsAndVendors();
    super.initState();
  }

  Future<void> fetchUnitsAndVendors() async {
    try {
      final unitsResponse = await http.get(Uri.parse('$baseUrl/api/units'));
      final vendorsResponse = await http.get(Uri.parse('$baseUrl/api/vendors'));

      if (unitsResponse.statusCode == 200 && vendorsResponse.statusCode == 200) {
        setState(() {
          units = List<String>.from(jsonDecode(unitsResponse.body).map((u) => u['name']));
          vendors = List<String>.from(jsonDecode(vendorsResponse.body).map((v) => v['name']));
        });
      }
    } catch (e) {
      print("Error fetching units/vendors: $e");
    }
  }

  void saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = {
        "name": nameController.text.trim(),
        "barcode": barcodeController.text.trim(),
        "unit": unitController.text.trim(),
        "cost_price": double.parse(costPriceController.text),
        "sale_price": double.parse(salePriceController.text),
        "tax": double.parse(taxController.text),
        "vendor": vendorController.text.trim(),
        "qty_on_hand": int.parse(qtyController.text),
        "description": descriptionController.text.trim(),
      };

      final bool isEditing = widget.data != null;
      final url = isEditing
          ? Uri.parse("$baseUrl/api/items/${widget.data!['id']}")
          : Uri.parse("$baseUrl/api/items");

      try {
        final response = await (isEditing
            ? http.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(item))
            : http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(item)));

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(isEditing ? "Item updated successfully" : "Item saved successfully")));
           Navigator.pop(context, true);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save item")));
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving item")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Inventory Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Item Name"), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: barcodeController, decoration: InputDecoration(labelText: "Barcode")),
              // TextFormField(controller: unitController, decoration: InputDecoration(labelText: "Unit of Measure")),
              TextFormField(controller: costPriceController, decoration: InputDecoration(labelText: "Cost Price"), keyboardType: TextInputType.number),
              TextFormField(controller: salePriceController, decoration: InputDecoration(labelText: "Sale Price"), keyboardType: TextInputType.number),
              TextFormField(controller: taxController, decoration: InputDecoration(labelText: "Tax"), keyboardType: TextInputType.number),
              // TextFormField(controller: vendorController, decoration: InputDecoration(labelText: "Vendor")),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: unitController.text.isNotEmpty ? unitController.text : null,
                      items: units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
                      onChanged: (value) => setState(() => unitController.text = value ?? ''),
                      decoration: InputDecoration(labelText: 'Unit of Measure'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddUnitPage()));
                      if (result == true) fetchUnitsAndVendors();
                    },
                  )
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: vendorController.text.isNotEmpty ? vendorController.text : null,
                      items: vendors.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (value) => setState(() => vendorController.text = value ?? ''),
                      decoration: InputDecoration(labelText: 'Vendor'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddVendorPage()));
                      if (result == true) fetchUnitsAndVendors();
                    },
                  )
                ],
              ),

              TextFormField(controller: qtyController, decoration: InputDecoration(labelText: "Qty on Hand"), keyboardType: TextInputType.number),
              TextFormField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: saveItem, child: Text("Save Item"))
            ],
          ),
        ),
      ),
    );
  }
}
