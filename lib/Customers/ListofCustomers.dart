import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/api_config.dart';
import 'dart:convert';

import 'addCustomers.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Map<String, dynamic>> items = [];
  Map<String, dynamic>? selectedItem;

  List<Map<String, dynamic>> transactions = [
    {'type': 'Invoice', 'num': 861, 'date': '02/01/2025', 'account': 'Accounts Receivable', 'amount': 1200.00},
    {'type': 'Invoice', 'num': 881, 'date': '07/01/2025', 'account': 'Accounts Receivable', 'amount': 500.00},
    {'type': 'Invoice', 'num': 955, 'date': '31/01/2025', 'account': 'Accounts Receivable', 'amount': 800.00},
  ];

  Future<void> fetchCustomers() async {
    final url = Uri.parse("$baseUrl/api/customers");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          items = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("Failed to load customers");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// LEFT PANEL
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Add Customer Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => AddCustomerPage()));
                        fetchCustomers(); // Refresh after returning
                      },
                      child: Text("New Customer"),
                    ),
                  ),
                ),

                // Customer List
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item['name']),
                        trailing: IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddCustomerPage(data: item)),
                            );

                            if (result == true) {
                              await fetchCustomers(); // Refresh after update
                              setState(() {
                                selectedItem = null;
                              });
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                        tileColor: selectedItem == item ? Colors.green[100] : null,
                        onTap: () {
                          setState(() {
                            selectedItem = item;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT PANEL
          Expanded(
            flex: 5,
            child: selectedItem == null
                ? Center(child: Text("Select a customer to view details"))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Customer Information",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${selectedItem!['id']}"),
                      Text("Name: ${selectedItem!['name']}"),
                      Text("Address: ${selectedItem!['address']}"),
                      Text("Phone Number: ${selectedItem!['phone_number']}"),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Transactions Table
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("Num")),
                                DataColumn(label: Text("Date")),
                                DataColumn(label: Text("Account")),
                                DataColumn(label: Text("Amount")),
                              ],
                              rows: transactions.map((txn) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(txn['type'])),
                                    DataCell(Text(txn['num'].toString())),
                                    DataCell(Text(txn['date'])),
                                    DataCell(Text(txn['account'])),
                                    DataCell(Text("₹${txn['amount']}", style: TextStyle(color: txn['amount'] < 0 ? Colors.red : Colors.green))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
