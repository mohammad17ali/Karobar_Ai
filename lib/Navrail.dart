import 'package:flutter/material.dart';
import 'package:karobar/Tab_bar/tabbar.dart';
import 'package:karobar/nav_bar/Addnewitem.dart';
import 'package:karobar/nav_bar/Ledger.dart';
import 'package:karobar/nav_bar/Shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const Navrail(),
    );
  }
}

class Navrail extends StatefulWidget {
  const Navrail({Key? key}) : super(key: key);

  @override
  _NavrailState createState() => _NavrailState();
}

class _NavrailState extends State<Navrail> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(),
        backgroundColor: Color(0xFF195DAD),
        titleTextStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  TabbarWidget(),
                  shop(),
                  Ledger(),
                  SnackBarWidget(),
                  SnackBarWidget(),
                  AddNewItemPage(),
                ],
              ),
            ),
            Container(
              width: 110, // Adjust the width as needed
              child: NavigationRail(
                backgroundColor: Color(0xFF0195FF),
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onNavItemTapped,
                labelType: NavigationRailLabelType.all,
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.teal,
                ),
                unselectedLabelTextStyle: const TextStyle(),
                destinations: [
                  _buildNavigationRailDestination(
                      Icons.store_sharp, 'Inventory', 0),
                  _buildNavigationRailDestination(
                      Icons.shopping_cart, 'Shop', 1),
                  _buildNavigationRailDestination(Icons.menu_book, 'Ledger', 2),
                  _buildNavigationRailDestination(
                      Icons.data_thresholding_outlined, 'Dash Board', 3),
                  _buildNavigationRailDestination(
                      Icons.arrow_circle_right_sharp, 'Place Order', 4),
                  _buildNavigationRailDestination(
                      Icons.add_circle, 'Add Item', 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  NavigationRailDestination _buildNavigationRailDestination(
      IconData icon, String label, int index) {
    return NavigationRailDestination(
      icon: Padding(
        padding: const EdgeInsets.all(15.0), // Padding around the icon
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, size: 32, color: Colors.black),
              ),
            ),
            SizedBox(height: 10), // Adjust spacing between icon and label
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
              ),
            ),
          ],
        ),
      ),
      selectedIcon: Padding(
        padding: const EdgeInsets.all(6.0), // Padding around the icon
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change color as needed
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Icon(icon, size: 45, color: Colors.black),
                  ),
                ),
                Positioned(
                  bottom: -8.0,
                  child: Container(
                    height: 4.0,
                    width: 70.0,
                    color: Colors.teal, // Color of the selected indicator line
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Adjust spacing between icon and label
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
              ),
            ),
          ],
        ),
      ),
      label: SizedBox.shrink(), // Hide label in the default state
    );
  }

  Widget _appBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return Text('Inventory');
      case 1:
        return Text('Shop');
      case 2:
        return Text('Ledger');
      case 3:
        return Text('DashBoard');
      case 4:
        return Text('Place Order');
      case 5:
        return Text('Add Item');
      default:
        return Text('App Bar Title');
    }
  }
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Image Page Content'),
    );
  }
}

class SnackBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('SnackBar Page Content'),
    );
  }
}
