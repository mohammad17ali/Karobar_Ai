import 'package:flutter/material.dart';
import '../services/functions.dart';
import '../services/dummyorders.dart';
import '../services/dummylist.dart';
import '../services/fetchOrders.dart';
import '../services/postOrder.dart';
import '../services/fetchItems.dart';



class Sidebar extends StatefulWidget {
  final List<Map<String, dynamic>> ordersList;
  final List<Map<String, dynamic>> cartList;


  Sidebar({required this.ordersList, required List<Map<String, dynamic>> cartList})
      : cartList = cartList;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<Map<String, dynamic>> ordersList = [];
  late List<Map<String, dynamic>> _cartList;
  
  bool _isLoading = true;
  List<bool> _isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _cartList = widget.cartList;
  }
  void postOrder() async {
    const String userId = "user9123456789"; // Replace with actual user ID
    const String outletId = "out9987654321"; // Replace with actual outlet ID

    try {
      await OrderService.postOrders(widget.cartList, userId, outletId);
      print("Order posted successfully!");
    } catch (e) {
      print("Error posting order: $e");
    }
  }

  Future<void> _fetchOrders() async {
    try {
      final fetchedOrders = await FetchOrders.fetchOrders();
      setState(() {
        ordersList = fetchedOrders;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Orders: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height,
      color: Colors.deepPurple[800],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'lib/assets/logoR.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF532EC3),
                width: 1,
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Active Orders",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 5 / 2,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5 / 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ordersList.where((order) => order['Status'] == 'Active').length,
                    itemBuilder: (context, index) {
                      final activeOrders = ordersList.where((order) => order['Status'] == 'Active').toList();
                      final order = activeOrders[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Order No.\n",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 8,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${order['OrderNum']}\n",
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${order['Amount']} Rs.",
                                    style: const TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF532EC3),
                width: 1,
              )
            ),
            height: 350,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${ordersList.isNotEmpty ? ordersList.last['OrderNum'] + 1 : 1}",
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                        "Total: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${_cartList.fold<int>(0, (sum, item) => sum + (item['quantity'] * item['price'] as int))} Rs.",
                
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
                      onPressed: ()  {
                        postOrder();
                      },
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
                        backgroundColor: Colors.pinkAccent,
                      ),
                      child: const Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
