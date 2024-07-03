import 'package:flutter/material.dart';
import 'package:karobar/Tab_bar/Snacks.dart';
import 'package:karobar/Tab_bar/beverges.dart';
import 'package:karobar/Tab_bar/fast_foot.dart';
import 'package:karobar/Tab_bar/others.dart';
import 'package:karobar/nav_bar/Inventory.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF98D9FF),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20), // Adjust the height as needed
            child: TabBar(
              indicatorWeight: 6,
              indicatorColor: Color(0xFF195DAD),
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF195DAD),
              ), // Style for selected text
              unselectedLabelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Color(0xFF195DAD),
              ), // Style for unselected text
              tabs: [
                Tab(
                  text: 'Snacks',
                ),
                Tab(
                  text: 'Beverges',
                ),
                Tab(
                  text: 'Fast Food',
                ),
                Tab(
                  text: 'Others',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [snacks(), beverges(), fast_food(), others()],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TabbarWidget(),
  ));
}
