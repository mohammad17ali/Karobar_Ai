import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:karobar/Tab_bar/edit.dart';

class snacks extends StatefulWidget {
  const snacks({Key? key}) : super(key: key);

  @override
  State<snacks> createState() => _snacksState();
}

class _snacksState extends State<snacks> {
  List<snacksItem> allRecords = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<snacksItem> fetchedItems = (data['records'] as List)
          .map((record) => snacksItem.fromJson(record))
          .toList();

      setState(() {
        allRecords = fetchedItems;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updateItem(snacksItem updatedItem) {
    setState(() {
      int index = allRecords.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        allRecords[index] = updatedItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA3D9FF).withOpacity(0.5),
      body: allRecords.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: allRecords.length,
              itemBuilder: (context, index) {
                final item = allRecords[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0), // Added vertical padding between cards
                  child: _buildsnacksCard(
                    item: item,
                    onUpdate: updateItem,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildsnacksCard({
    required snacksItem item,
    required Function(snacksItem) onUpdate,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF195DAD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(item.itemName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                        color: Colors.white)),
              ),
            ),
            Container(
              color: Color(0xFFA3D9FF),
              child: Row(
                children: [
                  Expanded(
                    flex: isSmallScreen ? 3 : 3,
                    child: Image.network(
                      item.pictureUrl,
                      height: 200,
                      width: 400,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 45),
                  Expanded(
                    flex: isSmallScreen ? 5 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Price', '${item.price}'),
                        _buildInfoRow('Quantity', item.quantity.toString()),
                        _buildInfoRow(
                            'Remaining',
                            item.quantity
                                .toString()), // Assuming remaining is the same as quantity
                        _buildInfoRow('Popularity',
                            '4.5'), // Replace with actual popularity if available
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFCDCDCD).withOpacity(0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Rs. ${item.price}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditsnacksItem(item: item, onUpdate: onUpdate),
                        ),
                      );
                      if (result != null && result is snacksItem) {
                        onUpdate(result);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF195DAD)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('Edit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Row(
          children: [
            Text(
              '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: snacks(),
  ));
}

class snacksItem {
  final String id;
  final String pictureUrl;
  final String itemName;
  final int price;
  final int quantity;
  final String category;
  final String itemID;

  snacksItem({
    required this.id,
    required this.pictureUrl,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.itemID,
  });

  factory snacksItem.fromJson(Map<String, dynamic> json) {
    return snacksItem(
      id: json['id'],
      pictureUrl: json['fields']['Picture'][0]['url'],
      itemName: json['fields']['Item Name'],
      price: json['fields']['Price'],
      quantity: json['fields']['Quantity'],
      category: json['fields']['Category'],
      itemID: json['fields']['ItemID'],
    );
  }
}
