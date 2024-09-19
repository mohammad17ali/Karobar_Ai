import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Record {
  final String id;
  final String pictureUrl;
  final int price;
  final String itemName;
  final String category;
  int quantity;
  String? orderItemId;
  bool isInOrderSummary;

  Record({
    required this.id,
    required this.pictureUrl,
    required this.price,
    required this.itemName,
    required this.category,
    this.quantity = 0,
    this.orderItemId,
    this.isInOrderSummary = false,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] ?? {};
    final pictureList = fields['Picture'] as List? ?? [];
    final pictureUrl =
        pictureList.isNotEmpty ? pictureList[0]['url'] ?? '' : '';
    final price = fields['Price'] ?? 0;
    final itemName = fields['Item Name'] ?? 'Unknown Item';
    final category = fields['Category'] ?? 'Unknown';

    final id = json['id'] ?? '';

    return Record(
      id: id,
      pictureUrl: pictureUrl,
      price: price,
      itemName: itemName,
      category: category,
    );
  }
}

class ShopSnacks extends StatefulWidget {
  const ShopSnacks({Key? key}) : super(key: key);

  @override
  State<ShopSnacks> createState() => _ShopSnacksState();
}

class _ShopSnacksState extends State<ShopSnacks> {
  late Future<List<Record>> records;

  @override
  void initState() {
    super.initState();
    records = fetchRecords();
  }

  Future<List<Record>> fetchRecords() async {
    final recordsResponse = await http.get(
      Uri.parse(
          'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    final ordersResponse = await http.get(
      Uri.parse('https://api.airtable.com/v0/appgAln53ifPLiXNu/OrderItems'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    if (recordsResponse.statusCode == 200 && ordersResponse.statusCode == 200) {
      Map<String, dynamic> recordsJson = jsonDecode(recordsResponse.body);
      Map<String, dynamic> ordersJson = jsonDecode(ordersResponse.body);

      List<Record> allRecords = (recordsJson['records'] as List).map((data) {
        return Record.fromJson(data);
      }).toList();

      List<dynamic> orderItems = ordersJson['records'];

      // Create a map of item ID to quantity
      Map<String, dynamic> orderSummaryMap = {};
      for (var orderItem in orderItems) {
        final fields = orderItem['fields'];
        final itemId = fields['ItemID'];
        final quantity = fields['Quantity'];
        orderSummaryMap[itemId] = {
          'quantity': quantity,
          'orderItemId': orderItem['id'],
        };
      }

      // Set quantity for items in the order summary
      List<Record> snackRecords = allRecords.where((record) {
        if (record.category == "Snacks") {
          if (orderSummaryMap.containsKey(record.id)) {
            record.quantity = orderSummaryMap[record.id]['quantity'];
            record.orderItemId = orderSummaryMap[record.id]['orderItemId'];
            record.isInOrderSummary = true;
          }
          return true;
        }
        return false;
      }).toList();

      return snackRecords;
    } else {
      throw Exception('Failed to load records or order items');
    }
  }

  Future<void> addItemToOrder({
    required Record record,
  }) async {
    final String url =
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/OrderItems';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "records": [
            {
              "fields": {
                "OrderItemID": record.id,
                "OrderID": "Some Order ID", // Replace with actual OrderID
                "ItemID": record.id,
                "Item Name": record.itemName,
                "Quantity": record.quantity,
                "ItemPrice": record.price,
                "Status": "Pending",
              }
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String newOrderItemId = responseData['records'][0]['id'];
        setState(() {
          record.orderItemId = newOrderItemId;
          record.isInOrderSummary = true;
        });
      } else {
        throw Exception('Failed to add item to order');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error occurred while adding item to order.')),
      );
    }
  }

  Future<void> updateItemQuantity({
    required Record record,
  }) async {
    final String url =
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/OrderItems';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "records": [
            {
              "id": record.orderItemId,
              "fields": {
                "Quantity": record.quantity,
              }
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update item quantity');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error occurred while updating quantity.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FF),
      body: FutureBuilder<List<Record>>(
        future: records,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No records found.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(35.0),
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 30.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final record = snapshot.data![index];
                  return _buildInventoryCard(record: record);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInventoryCard({required Record record}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF195DAD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                record.itemName,
                style: const TextStyle(
                  fontSize: 20,
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
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  record.pictureUrl,
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
                  'Rs. ${record.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF195DAD),
                  ),
                ),
                SizedBox(
                  width: 110,
                  height: 40,
                  child: record.isInOrderSummary
                      ? _buildQuantitySelector(record)
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              record.quantity = 1;
                            });
                            addItemToOrder(record: record);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF195DAD),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(Record record) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (record.quantity > 0) {
                  record.quantity--;
                  if (record.orderItemId != null) {
                    updateItemQuantity(record: record);
                  }
                }
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: const Text(
                '-',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF195DAD),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              record.quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF195DAD),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                record.quantity++;
                if (record.orderItemId != null) {
                  updateItemQuantity(record: record);
                }
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: const Text(
                '+',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF195DAD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
