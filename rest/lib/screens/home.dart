import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/fetchItems.dart';
import '../services/fetchOrders.dart';
import '../components/sidebar.dart';
import '../services/dummyorders.dart';
import '../services/dummylist.dart';
import 'ledger.dart';


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
  final Map<String, int> _cart = {};
  final List<Map<String, dynamic>> _cartList = [];
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _foodItems = [];
  List<Map<String, dynamic>> ordersList = [];
  bool _isLoading = true;
  int _toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      final fetchedItems = await FetchItems.fetchFoodItems();
      setState(() {
        _foodItems = fetchedItems;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching food items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All'
        ? _foodItems
        : _foodItems
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
              padding: const EdgeInsets.only(right: 30.0,bottom: 10),
              child: Container(
                  padding: EdgeInsets.all(5),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shadowColor: Colors.white,
                        ),
                        child: const Text(
                          "Menu",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LedgerPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.white,
                        ),
                        child: const Text(
                          "Dash",
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ),

                    ],
                  )
              )
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
        children: [
          // Sidebar
          Sidebar(ordersList: [], cartList: _cartList),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Category bar
                Container(
                  height: 50,
                  color: Colors.deepPurple[800],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryButton("All"),
                      ...["Starters", "Main Course", "Chinese", "Indian", "Continental"].map((category) {
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemID = item['ItemID'];
                        final isAdded = _cart.containsKey(itemID);
                        final quantity = _cart[itemID] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!_cart.containsKey(itemID)) {
                                _cart[itemID] = 1;
                                _cartList.add({
                                  'itemID': itemID,
                                  'name': item['name'],
                                  'price': item['price'],
                                  'quantity': 1,
                                });
                              } else {
                                _cart[itemID] = (_cart[itemID]! + 1);
                                _cartList.firstWhere((cartItem) => cartItem['itemID'] == itemID)['quantity']++;
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
          backgroundColor: _selectedCategory == title ? Colors.pinkAccent : Colors.deepPurple[50],
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

  Widget buildCard(Map<String, dynamic> item, bool isAdded, int quantity) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(2, 10, 10, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          color: isAdded ? Colors.pinkAccent[100] : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: NetworkImage(item['image']),
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
                        fontSize: 12,
                        color: const Color(0xFF2C176E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item['price']} Rs.",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
              radius: 20,
              backgroundColor: Colors.green,
              child: Text(
                quantity.toString(),
                style: const TextStyle(color: Colors.white),
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
                    _cart[item['ItemID']] = quantity - 1;
                    _cartList.firstWhere((cartItem) => cartItem['itemID'] == item['ItemID'])['quantity']--;
                  } else {
                    _cart.remove(item['ItemID']);
                    _cartList.removeWhere((cartItem) => cartItem['itemID'] == item['ItemID']);
                  }
                });
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(
                  quantity > 1 ? Icons.remove : Icons.delete,
                  color: Colors.pinkAccent,
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
