import 'package:flutter/material.dart';
import 'package:karobar/Shop_Tab_bar/shop_beverages.dart';
import 'package:karobar/Shop_Tab_bar/shop_fastfood.dart';
import 'package:karobar/Shop_Tab_bar/shop_others.dart';
import 'package:karobar/Shop_Tab_bar/shop_snacks.dart';
import 'package:karobar/nav_bar/Addnewitem.dart';

class Shop extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<Shop> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Snacks',
    'Beverages',
    'Fast Food',
    'Others'
  ];

  final List<Widget> _categoryWidgets = [
    ShopSnacks(),
    ShopBeverages(),
    ShopFastFood(),
    shopothers()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.camera_alt, color: Colors.black),
                    SizedBox(width: 10),
                    Icon(Icons.mic, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(width: 120),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'Place Order',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_categories.length, (index) {
                  return _buildCategoryButton(_categories[index], index);
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Text('Shop', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: _categoryWidgets[_selectedCategoryIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewItemPage()),
                );
              },
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Colors.white,
                size: 40,
              ),
              label: Text(
                'Add new item',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontSize: 30),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, size: 60.0, color: Colors.white),
                      Text(
                        'Record',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategoryIndex == index
            ? Colors.blue
            : Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: Size(170, 50),
      ),
      onPressed: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
