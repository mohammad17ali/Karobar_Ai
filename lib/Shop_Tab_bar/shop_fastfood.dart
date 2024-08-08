import 'package:flutter/material.dart';

class ShopFastFood extends StatefulWidget {
  const ShopFastFood({Key? key}) : super(key: key);

  @override
  State<ShopFastFood> createState() => _ShopFastFoodState();
}

class _ShopFastFoodState extends State<ShopFastFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 30.0,
          children: [
            _buildInventoryCard(
              itemName: 'Pani Puri',
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfLf40t2rOzTqiIY0Br3Pnmm3WmSP9e09ggA&s',
              price: 10,
              quantity: 5,
              remaining: 10,
              popularity: 4.5,
            ),
            _buildInventoryCard(
              itemName: 'Kalan',
              imageUrl:
                  'https://www.jinooskitchen.com/wp-content/uploads/2020/04/roadside-kalan-manchurian-recipe.jpg',
              price: 20,
              quantity: 3,
              remaining: 7,
              popularity: 4.2,
            ),
            _buildInventoryCard(
              itemName: 'Chicken Rice',
              imageUrl:
                  'https://www.kannammacooks.com/wp-content/uploads/street-style-chicken-rice-recipe-1-3.jpg',
              price: 60,
              quantity: 3,
              remaining: 7,
              popularity: 4.2,
            ),
            // Add more cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard({
    required String itemName,
    required String imageUrl,
    required int price,
    required int quantity,
    required int remaining,
    required double popularity,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF195DAD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                itemName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Container to ensure the image fits within the card
          Container(
            height: 150.0, // Adjust the height as needed
            width: double.infinity,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. $price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF195DAD),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement add functionality
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF195DAD)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text('Add', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShopFastFood(),
  ));
}
