import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ActiveOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  
  const ActiveOrderTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.gridTileDecoration(context),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Order No.",
            style: const TextStyle(
              fontSize: 8,
              color: AppColors.accent,
              //fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${order['OrderNum']}",
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${order['Amount']} Rs.",
            style: AppTextStyles.priceText,
          ),
        ],
      ),
    );
  }
}
