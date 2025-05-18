import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/api_config.dart';
class quoteScreen extends StatefulWidget {
  const quoteScreen({super.key});

  @override
  State<quoteScreen> createState() => _quoteScreenState();
}

class _quoteScreenState extends State<quoteScreen> {
  List<String> customers = [];
  String? selectedCustomer;
  DateTime selectedDate = DateTime.now();
  late TextEditingController _dateController;
  int quoteNumber = 1;
  late TextEditingController _quoteNumberController;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> selectedItems = [];
  TextEditingController searchController = TextEditingController();

  void fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/api/items'));
    if (response.statusCode == 200) {
      setState(() {
        items = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        filteredItems = List.from(items);
      });
    } else {
      print('Failed to load items');
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items.where((item) {
        final name = item['name'].toString().toLowerCase();
        final barcode = item['barcode']?.toString().toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            barcode.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    fetchLastQuoteNumber();
    fetchItems(); // Add this line
    _dateController = TextEditingController(
      text: "${selectedDate.toLocal()}".split(' ')[0],
    );
    _quoteNumberController = TextEditingController();

  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void fetchLastQuoteNumber() async {
    final response = await http.get(Uri.parse('$baseUrl/api/quotes/last-number'));
    if (response.statusCode == 200) {
      final lastNumber = int.tryParse(response.body) ?? 0;
      setState(() {
        quoteNumber = lastNumber + 1;
        _quoteNumberController.text = "Q$quoteNumber";
      });
    } else {
      print('Failed to fetch last quote number');
      _quoteNumberController.text = "Q$quoteNumber";
    }
  }

  void fetchCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/customers/names'));
    if (response.statusCode == 200) {
      setState(() {
        customers = List<String>.from(jsonDecode(response.body));
      });
    } else {
      print('Failed to load customers');
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void saveQuote() async {
    // Calculate totals
    double subtotal = selectedItems.fold(0, (sum, item) => sum + (item['amount'] ?? 0));
    double taxTotal = selectedItems.fold(0, (sum, item) => sum + (item['tax'] ?? 0));
    double total = subtotal + taxTotal;

    final response = await http.post(
      Uri.parse('$baseUrl/api/quotes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "customer_name": selectedCustomer ?? "Customer A",
        "quote_to": "Some address",
        "quote_number": "Q$quoteNumber",
        "date": _dateController.text,
        "subtotal": subtotal,
        "tax": taxTotal,
        "total": total,
        "payments_applied": 0.0,
        "balance_due": total,
        "items": selectedItems.map((item) => {
          "item_id": item['id'],
          "name": item['name'],
          "quantity": item['quantity'],
          "rate": item['rate'],
          "unit": item['unit'],
          "amount": item['amount'],
          "tax": item['tax'],
        }).toList(),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quote saved successfully!")),
      );
      // Reset form after successful save
      setState(() {
        selectedItems.clear();
        quoteNumber++;
        _quoteNumberController.text = "Q$quoteNumber";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save quote: ${response.body}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // You can integrate your NavigationRail here if needed
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: 12),
                  Expanded(child: _buildquoteForm(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('quote', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: saveQuote, // Update this line
              icon: Icon(Icons.save),
              label: Text("Save"),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.print),
              label: Text("Print"),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.mail_outline),
              label: Text("Email"),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildquoteForm(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTopFormFields(),
            Divider(),
            _buildTableHeader(),
            Expanded(child: _buildquoteItemRows()),
            Divider(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFormFields() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Customer / Job"),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCustomer,
                items: customers
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCustomer = val;
                  });
                },
              ),
              SizedBox(height: 16),
              Text("Quote To"),
              SizedBox(height: 8),
              Container(
                height: 80,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Text("Some address here..."), // Add a TextField if needed
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => pickDate(context),
                decoration: InputDecoration(
                  labelText: "Date",
                ),
              ),

              TextFormField(
                controller: _quoteNumberController,
                decoration: InputDecoration(labelText: "Quote #"),
                readOnly: true,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text("ITEM")),
          Expanded(child: Text("QTY")),
          Expanded(child: Text("RATE")),
          Expanded(child: Text("U/M")),
          Expanded(child: Text("AMOUNT")),
          Expanded(child: Text("TAX")),
        ],
      ),
    );
  }

  Widget _buildquoteItemRows() {
    return Column(
      children: [
        // Search field for items
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Items',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: filterItems,
          ),
        ),
        // Item selection dropdown
        if (filteredItems.isNotEmpty)
          DropdownButtonFormField<Map<String, dynamic>>(
            decoration: InputDecoration(labelText: 'Select Item'),
            items: filteredItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text('${item['name']} (${item['sale_price']})'),
              );
            }).toList(),
            onChanged: (selectedItem) {
              if (selectedItem != null) {
                setState(() {
                  selectedItems.add({
                    'id': selectedItem['id'],
                    'name': selectedItem['name'],
                    'quantity': 1,
                    'rate': selectedItem['sale_price'],
                    'unit': selectedItem['unit'],
                    'amount': selectedItem['sale_price'],
                    'tax': selectedItem['tax'] ?? 0.0,
                  });
                });
                searchController.clear();
                filterItems('');
              }
            },
          ),
        // Selected items table
        Expanded(
          child: ListView.builder(
            itemCount: selectedItems.length,
            itemBuilder: (_, index) {
              final item = selectedItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(item['name']),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['quantity'].toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final qty = double.tryParse(value) ?? 1;
                          setState(() {
                            selectedItems[index]['quantity'] = qty;
                            selectedItems[index]['amount'] = qty * (item['rate'] ?? 0);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['rate'].toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final rate = double.tryParse(value) ?? 0;
                          setState(() {
                            selectedItems[index]['rate'] = rate;
                            selectedItems[index]['amount'] = rate * (item['quantity'] ?? 1);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(item['unit'] ?? ''),
                    ),
                    Expanded(
                      child: Text(item['amount'].toString()),
                    ),
                    Expanded(
                      child: Text(item['tax'].toString()),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          selectedItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    double subtotal = selectedItems.fold(0, (sum, item) => sum + (item['amount'] ?? 0));
    double taxTotal = selectedItems.fold(0, (sum, item) => sum + (item['tax'] ?? 0));
    double total = subtotal + taxTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Subtotal: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                readOnly: true,
                initialValue: "PKR ${subtotal.toStringAsFixed(2)}",
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Tax: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                readOnly: true,
                initialValue: "PKR ${taxTotal.toStringAsFixed(2)}",
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Total: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                readOnly: true,
                initialValue: "PKR ${total.toStringAsFixed(2)}",
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Payments Applied: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                initialValue: "PKR 0.00",
                onChanged: (value) {
                  // You can handle payments applied if needed
                },
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Balance Due: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                readOnly: true,
                initialValue: "PKR ${total.toStringAsFixed(2)}",
              ),
            )
          ],
        ),
      ],
    );
  }

}

