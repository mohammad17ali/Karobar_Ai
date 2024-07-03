import 'package:flutter/material.dart';
import 'package:karobar/Tab_bar/tabbar.dart';
import 'package:karobar/nav_bar/Inventory.dart';
import 'package:karobar/nav_bar/Ledger.dart';

class Navrail extends StatefulWidget {
  const Navrail({Key? key}) : super(key: key);

  @override
  _NavrailState createState() => _NavrailState();
}

class _NavrailState extends State<Navrail> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
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
        titleTextStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                  ImageWidget(),
                  Ledger(),
                  SnackBarWidget(),
                  DismissableListWidget(),
                ],
              ),
            ),
            Container(
              width: 100, // Adjust the width as needed
              child: NavigationRail(
                backgroundColor: Color(0xFF0195FF),
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onNavItemTapped,
                labelType: NavigationRailLabelType.selected,
                destinations: [
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.store_sharp, size: 35),
                    ),
                    selectedIcon: Icon(Icons.store_outlined,
                        size: 32, color: Colors.black),
                    label: Text('Inventory'),
                  ),
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.shopping_cart, size: 35),
                    ),
                    selectedIcon: Icon(Icons.shopping_cart_checkout_outlined,
                        size: 32, color: Colors.black),
                    label: Text('Shop'),
                  ),
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.menu_book, size: 35),
                    ),
                    selectedIcon: Icon(Icons.menu_book_outlined,
                        size: 32, color: Colors.black),
                    label: Text('Ledger'),
                  ),
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.data_thresholding_outlined, size: 35),
                    ),
                    selectedIcon: Icon(Icons.data_thresholding,
                        size: 32, color: Colors.black),
                    label: Text('Dash  Board'),
                  ),
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.arrow_circle_right_sharp, size: 35),
                    ),
                    selectedIcon: Icon(Icons.arrow_circle_right,
                        size: 32, color: Colors.black),
                    label: Text('Place Order'),
                  ),
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.all(29),
                      child: Icon(Icons.add_circle, size: 35),
                    ),
                    selectedIcon: Icon(Icons.add_circle_rounded,
                        size: 32, color: Colors.black),
                    label: Text('Add Item'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Drawer Page Content'),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Image Page Content'),
      ),
    );
  }
}

class SnackBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('SnackBar Page Content'),
      ),
    );
  }
}

class DismissableListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dismissable List Page Content'),
      ),
    );
  }
}
