import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:karobar/nav_bar/Inventory.dart';
import 'package:karobar/nav_bar/Ledger.dart';
import 'package:karobar/Shop_Tab_bar/Shop.dart';

class ConvexNavBar extends StatefulWidget {
  @override
  _ConvexNavBarState createState() => _ConvexNavBarState();
}

class _ConvexNavBarState extends State<ConvexNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize InventoryPage with callback
    _pages[0] = InventoryPage(onGoToShop: _goToShop);
  }

  // List of pages
  final List<Widget> _pages = [
    SizedBox
        .shrink(), // Placeholder; will be replaced by InventoryPage with callback
    Shop(),
    Ledger(),
    Center(child: Text('Dashboard Page')),
  ];

  // Callback function to change the selected index to Shop
  void _goToShop() {
    setState(() {
      _selectedIndex = 1; // Change to the Shop tab
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Change to the selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xff043F84),
        height: 80,
        items: [
          TabItem(icon: Icons.home, title: 'Inventory'),
          TabItem(icon: Icons.shopping_bag, title: 'Shop'),
          TabItem(icon: Icons.book, title: 'Ledger'),
          TabItem(icon: Icons.dashboard, title: 'Dashboard'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
