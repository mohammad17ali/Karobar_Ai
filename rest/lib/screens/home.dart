import 'package:flutter/material.dart';
import 'dummylist.dart';

class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
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

  final Map<int, int> _cart = {};
  final List<Map<String, dynamic>> _cartList = [];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All'
        ? foodItems
        : foodItems
            .where((item) => item['category'].contains(_selectedCategory))
            .toList();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.deepPurple[800],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "The Zaika Restaurant",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ghansoli, Navi Mumbai\n2nd November 2024\nFriday",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Active Orders",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 8, // Dummy active orders
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Order No.\n${index + 23}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Order Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartList.length,
                    itemBuilder: (context, index) {
                      final item = _cartList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "${item['quantity']} x ${item['price']} Rs.",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "${item['quantity'] * item['price']} Rs.",
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white70),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${_cartList.fold(0, (int sum, item) => sum + (item['quantity'] as int) * (item['price'] as int))} Rs.",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: const Text(
                        "Pay",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 40,
                  color: Colors.deepPurple[700],
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Menu Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

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
                 

                // Body: Menu items
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
                        final isAdded = _cart.containsKey(index);
                        final quantity = _cart[index] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!_cart.containsKey(index)) {
                                _cart[index] = 1;
                                _cartList.add({
                                  'name': item['name'],
                                  'price': item['price'],
                                  'quantity': 1,
                                });
                              } else {
                                _cart[index] = quantity + 1;
                                _cartList.firstWhere((cartItem) =>
                                    cartItem['name'] ==
                                    item['name'])['quantity']++;
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                color: isAdded ? Colors.red[100] : Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.vertical(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      quantity.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          _cart[index] = quantity - 1;
                                          _cartList.firstWhere((cartItem) =>
                                              cartItem['name'] ==
                                              item['name'])['quantity']--;
                                        } else {
                                          _cart.remove(index);
                                          _cartList.removeWhere((cartItem) =>
                                              cartItem['name'] == item['name']);
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        quantity > 1
                                            ? Icons.remove
                                            : Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
            color: _selectedCategory == title ? Colors.white : Colors.deepPurple,
          ),
        ),
      ),
    );
  }

}
