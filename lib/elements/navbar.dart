// File: lib/widgets/custom_nav_bar.dart

import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final VoidCallback onVoicePressed;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.onVoicePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Height including the extruding part
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: 800,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Color(0xFF1A237E), // Dark blue color
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Cart',
                    isSelected: selectedIndex == 0,
                    onTap: () => onIndexChanged(0),
                  ),
                  // Spacer for center button
                  SizedBox(width: 100),
                  _buildNavItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isSelected: selectedIndex == 1,
                    onTap: () => onIndexChanged(1),
                  ),
                ],
              ),
            ),
          ),
          // Center floating voice button
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF4081),
                      Color(0xFFFF1744),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF4081).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: MaterialButton(
                  onPressed: onVoicePressed,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white,
            // Change color based on selection
            size: 30,
          ),
          SizedBox(width: 8), // Space between icon and text
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
              // Change color based on selection
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
