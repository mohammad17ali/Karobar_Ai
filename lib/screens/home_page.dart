import 'package:flutter/material.dart';
import 'package:karobar/services/voice_input_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karobar/elements/navbar.dart';
import 'package:karobar/elements/topbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VoiceInputPage _VoiceInputPage = VoiceInputPage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TopBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Category List
            Container(
              height: screenHeight * 0.13,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategory('Snacks', 'assets/bagu.png'),
                  _buildCategory('Drinks', 'assets/bagu.png'),
                  _buildCategory('Dairy', 'assets/bagu.png', isSelected: true),
                  _buildCategory('Biscuits', 'assets/bagu.png'),
                  _buildCategory('Health', 'assets/bagu.png'),
                  _buildCategory('Kitchen', 'assets/bagu.png'),
                  _buildCategory('Bakery', 'assets/bagu.png'),
                  _buildCategory('Cosmetics', 'assets/bagu.png'),
                ],
              ),
            ),
            // Product Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(20),
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9, // Adjusted for better layout
                children: [
                  _buildItem('Egg', 20, 'assets/egg.png', screenWidth),
                  _buildItem('Milk', 20, 'assets/milk.png', screenWidth),
                  _buildItem('Orange Soda', 20, 'assets/can.png', screenWidth),
                  _buildItem('Bread', 20, 'assets/bread.png', screenWidth),
                  _buildItem('Baguette', 20, 'assets/bagu.png', screenWidth),
                  _buildItem('Ice Cream', 20, 'assets/icecream.png', screenWidth),
                  _buildItem('Ice 1', 23, 'assets/bagu.png', screenWidth),
                  _buildItem('Ice 2', 34, 'assets/bagu.png', screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0, // Default index
        onIndexChanged: (index) {
          // Handle navigation
          if (index == 0) {
            // Navigate to Cart page
            Navigator.pushNamed(context, '/cart');
          } else if (index == 1) {
            // Navigate to Dashboard page
            Navigator.pushNamed(context, '/dashboard');
          }
        },
        onVoicePressed: () {
          // Navigate to Voice Input Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VoiceInputPage()),
          );
        },
      ),
    );
  }

  // Category Widget
  Widget _buildCategory(String title, String iconPath, {bool isSelected = false}) {
    return Container(
      width: 90,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFFF4081) : Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(iconPath, width: 40, height: 40), // Resized for better fit
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // Adjusted font size
              color: isSelected ? Color(0xFFFF4081) : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Product Item Widget
  Widget _buildItem(String title, int price, String imagePath, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(imagePath, width: screenWidth*0.6, height: screenWidth*0.6), // Scaled for container
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. $price',
                  style: TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Navigation Bar Item
  Widget _buildNavItem(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Color(0xFF1A237E), size: 28),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
