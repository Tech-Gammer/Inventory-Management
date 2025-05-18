// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class InventoryPage extends StatefulWidget {
//   @override
//   _InventoryPageState createState() => _InventoryPageState();
// }
//
// class _InventoryPageState extends State<InventoryPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController qtyController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//
//   List<Map<String, dynamic>> items = [];
//
//   void addItem() {
//     final name = nameController.text.trim();
//     final qty = int.tryParse(qtyController.text.trim()) ?? 0;
//     final price = double.tryParse(priceController.text.trim()) ?? 0.0;
//
//     if (name.isNotEmpty) {
//       setState(() {
//         items.add({'name': name, 'qty': qty, 'price': price});
//         nameController.clear();
//         qtyController.clear();
//         priceController.clear();
//       });
//     }
//   }
//
//   void deleteItem(int index) {
//     setState(() {
//       items.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Add Item Section
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text('Add New Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: nameController,
//                           decoration: InputDecoration(labelText: 'Item Name'),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           controller: qtyController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Quantity'),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           controller: priceController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(labelText: 'Price'),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: addItem,
//                         child: Text('Add'),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // List Items Section
//         Expanded(
//           child: items.isEmpty
//               ? Center(child: Text('No items added yet.'))
//               : ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return Card(
//                 margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 child: ListTile(
//                   title: Text(item['name']),
//                   subtitle: Text('Qty: ${item['qty']} | Price: \$${item['price']}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit, color: Colors.orange),
//                         onPressed: () {
//                           // Optional: Add edit functionality
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => deleteItem(index),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
