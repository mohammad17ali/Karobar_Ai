import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dummylist.dart';
import 'dummyorders.dart';
import '../components/sidebar.dart';

class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'karobar',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, int> _cart = {}; // Tracks itemID and quantities in the cart
  final List<Map<String, dynamic>> _cartList = []; // Stores detailed cart items
  String _selectedCategory = 'All'; // Tracks the selected category for filtering

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All'
        ? foodItems
        : foodItems
            .where((item) => item['category'].contains(_selectedCategory))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "The Zaika Restaurant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple[800],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0), 
            child: Image.asset(
              'assets/logoR.png', 
              height: 40,       
              fit: BoxFit.contain, 
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Sidebar(ordersList: ordersList, cartList: _cartList),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Category bar
                Container(
                  height: 50,
                  color: Colors.deepPurple[600],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryButton("All"),
                      ...[
                        "Starters",
                        "Main Course",
                        "Chinese",
                        "Indian",
                        "Continental"
                      ].map((category) {
                        return _buildCategoryButton(category);
                      }).toList(),
                    ],
                  ),
                ),

                // Menu items
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemID = item['ItemID'];
                        final isAdded = _cart.containsKey(itemID); // Check cart state
                        final quantity = _cart[itemID] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!_cart.containsKey(itemID)) {
                                // If item is not in the cart, add it
                                _cart[itemID] = 1;
                                _cartList.add({
                                  'itemID': itemID,
                                  'name': item['name'],
                                  'price': item['price'],
                                  'quantity': 1,
                                });
                              } else {
                                // If item is in the cart, increment quantity
                                _cart[itemID] = (_cart[itemID]! + 1);
                                _cartList.firstWhere((cartItem) =>
                                    cartItem['itemID'] == itemID)['quantity']++;
                              }
                            });
                          },
                          child: buildCard(item, isAdded, quantity),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the sidebar for orders and cart details
  Widget buildSidebar() {
    return Container(
      width: 300,
      color: Colors.deepPurple[800],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add components for sidebar here (order details, total price, etc.)
        ],
      ),
    );
  }

  // Builds the category bar for filtering items
  Widget buildCategoryBar() {
    return Container(
      height: 50,
      color: Colors.deepPurple[600],
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryButton("All"),
          ...["Starters", "Main Course", "Chinese", "Indian", "Continental"]
              .map((category) => _buildCategoryButton(category))
              .toList(),
        ],
      ),
    );
  }

  // Builds a category button
  Widget _buildCategoryButton(String title) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedCategory == title
              ? Colors.deepPurple
              : Colors.deepPurple[50],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color:
                _selectedCategory == title ? Colors.white : Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  // Builds a menu item card with two states
  Widget buildCard(Map<String, dynamic> item, bool isAdded, int quantity) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          color: isAdded ? Colors.red[100] : Colors.white, // Change based on state
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item['price']} Rs.",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isAdded) ...[
          // Quantity circle
          Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Text(
                quantity.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Subtract/delete button
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (quantity > 1) {
                    _cart[item['ItemID']] = quantity - 1;
                    _cartList.firstWhere((cartItem) =>
                        cartItem['itemID'] == item['ItemID'])['quantity']--;
                  } else {
                    _cart.remove(item['ItemID']);
                    _cartList.removeWhere(
                        (cartItem) => cartItem['itemID'] == item['ItemID']);
                  }
                });
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.red,
                child: Icon(
                  quantity > 1 ? Icons.remove : Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
