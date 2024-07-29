import 'package:flutter/material.dart';

class FastFood extends StatefulWidget {
  const FastFood({Key? key}) : super(key: key);

  @override
  State<FastFood> createState() => _FastFoodState();
}

class _FastFoodState extends State<FastFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(30.0),
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Center(
      child: Card(
        elevation: 6,
        child: Container(
          width: screenWidth * 0.8,
          padding: EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF195DAD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    itemName,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                color: Color(0xFFA3D9FF),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        imageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Price', '$price'),
                          _buildInfoRow('Quantity', quantity.toString()),
                          _buildInfoRow('Remaining', remaining.toString()),
                          _buildInfoRow('Popularity', popularity.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '₹$price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement edit functionality
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF195DAD)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('Edit', style: TextStyle(fontSize: 25)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FastFood(),
  ));
}
