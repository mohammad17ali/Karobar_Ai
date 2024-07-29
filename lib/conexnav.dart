import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:karobar/nav_bar/Inventory.dart';
import 'package:karobar/nav_bar/Ledger.dart';
import 'package:karobar/nav_bar/Shop.dart';

class ConvexNavBar extends StatefulWidget {
  @override
  _ConvexNavBarState createState() => _ConvexNavBarState();
}

class _ConvexNavBarState extends State<ConvexNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    InventoryPage(),
    shop(),
    Ledger(),
    Center(child: Text('Ledger Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.blue,
        height: 80, // Adjust the height value as needed
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
