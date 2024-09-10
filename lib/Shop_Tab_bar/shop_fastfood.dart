import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Record {
  final String id;
  final String pictureUrl;
  int price; // Changed to be mutable
  String itemName; // Changed to be mutable
  final String category;
  int quantity;
  String? orderItemId;

  Record({
    required this.id,
    required this.pictureUrl,
    required this.price,
    required this.itemName,
    required this.category,
    this.quantity = 0,
    this.orderItemId,
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

class ShopFastFood extends StatefulWidget {
  const ShopFastFood({Key? key}) : super(key: key);

  @override
  State<ShopFastFood> createState() => _ShopFastFoodState();
}

class _ShopFastFoodState extends State<ShopFastFood> {
  late Future<List<Record>> records;

  @override
  void initState() {
    super.initState();
    records = fetchRecords();
  }

  Future<List<Record>> fetchRecords() async {
    final response = await http.get(
      Uri.parse(
          'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<Record> allRecords = (json['records'] as List).map((data) {
        return Record.fromJson(data);
      }).toList();

      // Filter the records to include only those in the "Fast Food" category
      List<Record> fastFoodRecords = allRecords.where((record) {
        return record.category == "Fast Food";
      }).toList();

      return fastFoodRecords;
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<void> editItem({required Record record}) async {
    TextEditingController nameController =
        TextEditingController(text: record.itemName);
    TextEditingController priceController =
        TextEditingController(text: record.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String updatedName = nameController.text;
                final int updatedPrice = int.parse(priceController.text);

                await updateRecordDetails(
                    record: record,
                    updatedName: updatedName,
                    updatedPrice: updatedPrice);

                setState(() {
                  record.itemName = updatedName;
                  record.price = updatedPrice;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateRecordDetails({
    required Record record,
    required String updatedName,
    required int updatedPrice,
  }) async {
    final String url =
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs/${record.id}';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "fields": {
            "Item Name": updatedName,
            "Price": updatedPrice,
          }
        }),
      );

      print('Update Item Response status: ${response.statusCode}');
      print('Update Item Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update item details');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error occurred while updating item details.')),
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
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editItem(record: record);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
      home: ShopFastFood(),
    ));
