import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model class for the data
class Record {
  final String pictureUrl;
  final int price;

  Record({required this.pictureUrl, required this.price});

  factory Record.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] ?? {};
    final pictureList = fields['Picture'] as List? ?? [];
    final pictureUrl =
        pictureList.isNotEmpty ? pictureList[0]['url'] ?? '' : '';
    final price = fields['Price'] ?? 0;

    return Record(
      pictureUrl: pictureUrl,
      price: price,
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
      // Debugging print statement
      print(json);

      List<Record> records = (json['records'] as List).map((data) {
        // Debugging print statement
        print(data);
        return Record.fromJson(data);
      }).toList();
      return records;
    } else {
      throw Exception('Failed to load records');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FF),
      body: FutureBuilder<List<Record>>(
        future: records,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(35.0),
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 30.0,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final record = snapshot.data![index];
                  return _buildInventoryCard(
                    imageUrl: record.pictureUrl,
                    price: record.price,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInventoryCard({
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
                'Item', // Placeholder, you may want to add more details if needed
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
                borderRadius: BorderRadius.circular(8.0),
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
