import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderItems();
  }

  Future<void> fetchOrderItems() async {
    final response = await http.get(
      Uri.parse(
          'https://api.airtable.com/v0/appgAln53ifPLiXNu/OrderItems?filterByFormula={Status}="Pending"'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        items = data['records'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load order items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.blue[800],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // List of order items
                        ListView.builder(
                          shrinkWrap:
                              true, // Makes sure the list doesn't expand infinitely
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index]['fields'];
                            final imageUrl =
                                'https://example.com/images/${item['ItemID']}.png'; // Example URL, replace with actual
                            return Card(
                              color: Colors.blue[100],
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Image from API
                                    Image.network(
                                      imageUrl,
                                      height: 50,
                                      width: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.broken_image,
                                            color: Colors.grey, size: 50);
                                      },
                                    ),
                                    const SizedBox(width: 5),

                                    // Name
                                    Text(
                                      item['Item Name'] ?? 'No Name',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 40),

                                    // Price
                                    Text(
                                      '${item['ItemPrice'] ?? '0'}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const Spacer(),

                                    // Quantity Controls
                                    Row(
                                      children: [
                                        _buildQuantityButton(Icons.remove, () {
                                          setState(() {
                                            if (item['Quantity'] > 1) {
                                              item['Quantity']--;
                                              item['TotalPrice'] =
                                                  item['Quantity'] *
                                                      item['ItemPrice'];
                                            }
                                          });
                                        }),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            '${item['Quantity'] ?? '0'}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        _buildQuantityButton(Icons.add, () {
                                          setState(() {
                                            item['Quantity']++;
                                            item['TotalPrice'] =
                                                item['Quantity'] *
                                                    item['ItemPrice'];
                                          });
                                        }),
                                      ],
                                    ),

                                    // Total Amount
                                    const SizedBox(width: 16),
                                    Text(
                                      '${item['Quantity'] * item['ItemPrice']}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed Quantity Button Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // First Column: 2x2 Grid of Curved Amount Buttons
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildCurvedAmountButton(5),
                              const SizedBox(width: 10),
                              _buildCurvedAmountButton(10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildCurvedAmountButton(18),
                              const SizedBox(width: 10),
                              _buildCurvedAmountButton(20),
                            ],
                          ),
                        ],
                      ),

                      // Second Column: Add Amount Section with TextField constrained
                      _buildAddAmountButton(),

                      // Third Column: Cash and UPI Buttons
                      Column(
                        children: [
                          _buildPaymentButton('Cash', Icons.money),
                          const SizedBox(height: 10),
                          _buildPaymentButton('UPI', Icons.qr_code_scanner),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCurvedAmountButton(int amount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          '$amount',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddAmountButton() {
    return Column(
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontSize: 28, color: Color.fromARGB(255, 18, 22, 26)),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Colors.blue),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                // Handle input if needed
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Add Amount',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[100],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      icon: Icon(icon, color: const Color.fromARGB(255, 4, 115, 243)),
      label: Text(
        label,
        style: const TextStyle(
            color: Color.fromARGB(255, 4, 115, 243),
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }
}
