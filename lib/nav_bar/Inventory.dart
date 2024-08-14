import 'package:flutter/material.dart';
import 'package:karobar/Inventory_Tab_bar/Snacks.dart';
import 'package:karobar/Inventory_Tab_bar/beverges.dart';
import 'package:karobar/Inventory_Tab_bar/fast_foot.dart';
import 'package:karobar/Inventory_Tab_bar/others.dart';
import 'package:karobar/nav_bar/Addnewitem.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Snacks',
    'Beverages',
    'Fast Food',
    'Others'
  ];

  final List<Widget> _categoryWidgets = [
    Snacks(),
    Beverages(),
    FastFood(),
    Others(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              color: Color(0xff043F84),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Inventory',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xffFFFFFF))), // Add Inventory text
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50, // Adjust height
                        padding: EdgeInsets.symmetric(
                            horizontal: 30), // Adjust width
                        decoration: BoxDecoration(
                          color: const Color(0xFFA5CEFF),
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
                            SizedBox(
                                width:
                                    10), // Space between camera and mic icons
                            Icon(Icons.mic, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        width:
                            120), // Adjust space between search box and button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff043F84),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10), // Adjust padding
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text(
                            'Go to\nshop',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16), // Adjust font size
                          ),
                          SizedBox(
                            width: 50,
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
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_categories.length, (index) {
                  return _buildCategoryButton(_categories[index], index);
                }),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20.0), // Add padding above the content
        child: _categoryWidgets[_selectedCategoryIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            bottom: 60.0), // Adjust the value to position above the navbar
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
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15), // Increase button size
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontSize: 30), // Increase text size
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
        backgroundColor:
            _selectedCategoryIndex == index ? Color(0xff043F84) : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 15), // Adjust padding
        minimumSize: Size(170, 50), // Adjust width and height
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
          fontSize: 16, // Adjust font size if needed
        ),
      ),
    );
  }
}
