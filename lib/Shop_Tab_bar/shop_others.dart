import 'package:flutter/material.dart';

class shopothers extends StatefulWidget {
  const shopothers({Key? key}) : super(key: key);

  @override
  State<shopothers> createState() => _ShopSnacksState();
}

class _ShopSnacksState extends State<shopothers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 30.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildInventoryCard(
                  itemName: 'Bannana',
                  imageUrl:
                      'https://www.google.com/imgres?q=bannnana&imgurl=https%3A%2F%2Fimages.immediat',
                  price: 20,
                ),
                _buildInventoryCard(
                  itemName: 'Cookies',
                  imageUrl:
                      'https://images.unsplash.com/photo-1548365328-85c4e2d9f641',
                  price: 30,
                ),
                _buildInventoryCard(
                  itemName: 'Candy',
                  imageUrl:
                      'https://images.unsplash.com/photo-1570197780059-eae0f9c7e93b',
                  price: 10,
                ),
                _buildInventoryCard(
                  itemName: 'Soda',
                  imageUrl:
                      'https://images.unsplash.com/photo-1586201375761-83865001b9ee',
                  price: 15,
                ),
                _buildInventoryCard(
                  itemName: 'Juice',
                  imageUrl:
                      'https://images.unsplash.com/photo-1584287230664-3851d5961164',
                  price: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard({
    required String itemName,
    required String imageUrl,
    required int price,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(.0),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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

void main() => runApp(MaterialApp(
      home: shopothers(),
    ));
