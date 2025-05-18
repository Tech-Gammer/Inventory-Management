import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/api_config.dart';
import 'dart:convert';

import 'addInventory.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<Map<String, dynamic>> items = [];


  Map<String, dynamic>? selectedItem;

  List<Map<String, dynamic>> transactions = [
    {'type': 'Invoice', 'num': 861, 'date': '02/01/2025', 'account': 'Raw Materials Inventory', 'amount': -1888.00},
    {'type': 'Invoice', 'num': 881, 'date': '07/01/2025', 'account': 'Raw Materials Inventory', 'amount': -1888.00},
    {'type': 'Invoice', 'num': 955, 'date': '31/01/2025', 'account': 'Raw Materials Inventory', 'amount': -826.00},
  ];

  Future<void> fetchItems() async {
    final url = Uri.parse("$baseUrl/api/items");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          items = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("Failed to load items");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// LEFT PANEL
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Add Item Section
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: TextField(
              //               controller: nameController,
              //               decoration: InputDecoration(labelText: 'Item Name'),
              //             ),
              //           ),
              //           SizedBox(width: 10),
              //           Expanded(
              //             child: TextField(
              //               controller: priceController,
              //               keyboardType: TextInputType.number,
              //               decoration: InputDecoration(labelText: 'Price'),
              //             ),
              //           ),
              //           SizedBox(width: 10),
              //           ElevatedButton(
              //             onPressed: addItem,
              //             child: Text("Add"),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Inside _InventoryPageState build method, replace the Add Item section with:

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => AddInventoryItemPage()));
                      fetchItems(); // Refresh list after coming back
                    },

                    child: Text("New Inventory Item"),
                  ),
                ),
              ),


              // Inventory List
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item['name']),
                      // trailing: Text('PKR-${item['price']}'),
                      trailing: IconButton(
                      //     onPressed: (){
                      //   Navigator.push(context, MaterialPageRoute(builder: (_) => AddInventoryItemPage(data:item)));
                      //   fetchItems();
                      // },
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddInventoryItemPage(data: item)),
                            );

                            if (result == true) {
                              await fetchItems(); // refresh inventory list
                              setState(() {
                                selectedItem = null; // clear selection or you can reselect the updated item if needed
                              });
                            }
                          },

                          icon: Icon(Icons.edit)),
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
              ? Center(child: Text("Select an item to view details"))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inventory Information Header
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Inventory Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${selectedItem!['name']}"),
                    Text("Cost Price: PKR-${selectedItem!['cost_price']}"),
                    Text("Sale Price: PKR-${selectedItem!['sale_price']}"),
                    Text("Preferred Vendor: ${selectedItem!['vendor']}"),
                    Text("Unit: ${selectedItem!['unit']}"),
                    Text("Quantity On Hand: ${selectedItem!['qty_on_hand']}"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Transactions Tab
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
                                  DataCell(Text("₹${txn['amount'].abs()}", style: TextStyle(color: txn['amount'] < 0 ? Colors.red : Colors.green))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
