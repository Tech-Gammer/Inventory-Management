import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
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
                  Expanded(child: _buildInvoiceForm(context)),
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
        Text('Invoice', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
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

  Widget _buildInvoiceForm(BuildContext context) {
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
            Expanded(child: _buildInvoiceItemRows()),
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
                items: ["Customer A", "Customer B"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (_) {},
              ),
              SizedBox(height: 16),
              Text("Invoice To"),
              SizedBox(height: 8),
              Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
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
                decoration: InputDecoration(labelText: "Date"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Invoice #"),
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

  Widget _buildInvoiceItemRows() {
    return ListView.builder(
      itemCount: 10, // You can make this dynamic later
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(flex: 2, child: TextFormField()),
            Expanded(child: TextFormField()),
            Expanded(child: TextFormField()),
            Expanded(child: TextFormField()),
            Expanded(child: TextFormField()),
            Expanded(child: TextFormField()),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Total: "),
            SizedBox(width: 10),
            Container(
              width: 100,
              child: TextFormField(
                readOnly: true,
                initialValue: "PKR 0.00",
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
                readOnly: true,
                initialValue: "PKR 0.00",
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
                initialValue: "PKR 0.00",
              ),
            )
          ],
        ),
      ],
    );
  }
}
