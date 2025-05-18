import 'package:flutter/material.dart';
import 'package:inventory_management/Auth/login.dart';
import 'Customers/ListofCustomers.dart';
import 'Inventory/inventory.dart';
import 'Invoce/create invoice.dart';
import 'Invoce/createQuotes.dart';
import 'dashBoardScreen.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildQuickBooksFlow(),
      InventoryPage(),
      Center(child: InvoiceScreen()),
      Center(child: Text('Reports')),
      Center(child: Text('Settings')),
    ];
  }

  late List<Widget> _pages; // <- late initialization

  final List<String> _titles = [
    'Dashboard',
    'Inventory',
    'Invoices',
    'Reports',
    'Settings'
  ];

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    ).then((_){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout Successfully')));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.dashboard, size: 32),
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory),
                label: Text('Inventory'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt),
                label: Text('Invoices'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: _pages[_selectedIndex],
                      ),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _titles[_selectedIndex],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.notifications_none),
              SizedBox(width: 20),
              // CircleAvatar(
              //   child: IconButton(onPressed: (){}, icon: Icon(Icons.person)),
              // ),
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                  backgroundColor: Colors.blueAccent,
                ),
                onSelected: (value) async {
                  if (value == 'profile') {
                    // Navigate to profile page

                  } else if (value == 'logout') {
                    await _handleLogout();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
              )

            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickBooksFlow() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryTitle("VENDORS"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlowItem(label: "Purchase Orders", icon: Icons.shopping_cart),
              SizedBox(width: 40),
              FlowItem(label: "Receive Inventory", icon: Icons.inventory),
              SizedBox(width: 40),
              FlowItem(label: "Enter Bills", icon: Icons.receipt),
              SizedBox(width: 40),
              FlowItem(label: "Pay Bills", icon: Icons.payment),
            ],
          ),
          SizedBox(height: 40),
          _buildCategoryTitle("CUSTOMERS"),
          Row(
            children: [
              FlowItem(label: "Manage Customers", icon: Icons.edit_document,onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerPage()));},),
              SizedBox(width: 40),
              FlowItem(label: "Quotes", icon: Icons.edit_document, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => quoteScreen()));
              },),
              SizedBox(width: 40),
              FlowItem(label: "Create Invoices", icon: Icons.receipt_long),
              SizedBox(width: 40),
              FlowItem(label: "Receive Payments", icon: Icons.attach_money),
              SizedBox(width: 40),
              FlowItem(label: "Record Deposits", icon: Icons.account_balance_wallet),
            ],
          ),
          // Continue adding other sections like EMPLOYEES, BANKING, COMPANY...
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

}
