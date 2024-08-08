import 'package:flutter/material.dart';

class ShopBeverages extends StatefulWidget {
  const ShopBeverages({Key? key}) : super(key: key);

  @override
  State<ShopBeverages> createState() => _ShopBeveragesState();
}

class _ShopBeveragesState extends State<ShopBeverages> {
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
              itemName: 'Cola',
              imageUrl: 'https://example.com/cola.jpg',
              price: 20,
              quantity: 3,
              remaining: 7,
              popularity: 4.2,
            ),
            _buildInventoryCard(
              itemName: 'Juice',
              imageUrl: 'https://example.com/juice.jpg',
              price: 25,
              quantity: 5,
              remaining: 12,
              popularity: 4.5,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
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
    home: ShopBeverages(),
  ));
}
