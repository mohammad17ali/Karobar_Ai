import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primaryDark = Colors.deepPurple;
  //static const primary = Color(0xFF311B92);
  static const primary = Color(0xFF4527A0);
  static const primaryLight = Colors.deepPurpleAccent;
  static const catNotSelectedBG = Color.fromARGB(255, 227, 216, 247);
  static const catNotSelectedTXT = Colors.deepPurple;

  // Accent colors
  static const accent = Colors.pinkAccent;
  static const accentLight = Color(0xFFFF80AB);

  // Functional colors
  static const success = Colors.green;
  static const warning = Colors.orange;
  static const error = Colors.red;

  // Neutral colors
  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Colors.grey;
  static const transparent = Colors.transparent;
}

class AppTextStyles {
  // Headings
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Body text
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.white,
  );

  static const TextStyle bodyTextDark = TextStyle(
    fontSize: 14,
    color: AppColors.primaryDark,
  );

  // Card text
  static const TextStyle cardTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: AppColors.primaryDark,
  );

  static const TextStyle priceText = TextStyle(
    color: AppColors.success,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  // Button text
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static const TextStyle priceTextLarge = TextStyle(
    color: AppColors.success,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}

class AppDecorations {
  // Container decorations
  static BoxDecoration sidebarContainer(BuildContext context) => BoxDecoration(
    color: Colors.deepPurple[700],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.primaryLight, width: 1),
  );

  static BoxDecoration mainContainer(BuildContext context) => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Card decorations
  static BoxDecoration gridTileDecoration(BuildContext context) => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration selectedItemDecoration = BoxDecoration(
    color: AppColors.accentLight.withOpacity(0.3),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.accent,
      width: 1.5,
    ),
  );

  // Button decorations
  static BoxDecoration primaryButton = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(30),
  );

  static BoxDecoration secondaryButton = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: AppColors.primary,
      width: 1.5,
    ),
  );
}

class AppShadows {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
