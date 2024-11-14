import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:karobar/nav_bar/edititem.dart';
import '../recordid.dart'; // Correct path to your Record model

class Snacks extends StatefulWidget {
  const Snacks({Key? key}) : super(key: key);

  @override
  State<Snacks> createState() => _SnacksState();
}

class _SnacksState extends State<Snacks> {
  List<Record>? records;
  bool isLoading = false;
  bool isFetched = false; // Track if data has been fetched

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
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
        List<Record> recordsList = (json['records'] as List)
            .map((data) => Record.fromJson(data))
            .where(
                (record) => record.category == "Snacks") // Filter by "Snacks"
            .toList();
        setState(() {
          records = recordsList;
          isFetched = true; // Mark data as fetched
        });
      } else {
        throw Exception('Failed to load records');
      }
    } catch (e) {
      // Handle error
      setState(() {
        records = [];
        isFetched = true; // Mark as fetched to avoid retries
      });
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFEEFFFF),
        child: isLoading && !isFetched
            ? const Center(child: CircularProgressIndicator())
            : records == null || records!.isEmpty
                ? const Center(child: Text('No records found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(30.0),
                    itemCount: records!.length,
                    itemBuilder: (context, index) {
                      final record = records![index];
                      return _buildInventoryCard(
                        itemName: record.itemName,
                        imageUrl: record.pictureUrl,
                        price: record.price,
                        quantity: record.quantity,
                        remaining: 350, // Replace with actual remaining value
                        popularity: 3, // Replace with actual popularity value
                        record: record,
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildInventoryCard({
    required String itemName,
    required String imageUrl,
    required int price,
    required int quantity,
    required int remaining,
    required double popularity,
    required Record record,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Center(
      child: Card(
        elevation: 6,
        child: Container(
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF195DAD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    itemName,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFFA5CEFF),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        imageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Price', '₹$price'),
                          _buildInfoRow('Quantity', quantity.toString()),
                          _buildInfoRow('Remaining', remaining.toString()),
                          _buildInfoRow('Popularity', popularity.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '₹$price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedRecord = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Edititem(record: record),
                          ),
                        );

                        if (updatedRecord != null) {
                          setState(() {
                            // Update specific record after editing
                            final index = records!
                                .indexWhere((r) => r.id == updatedRecord.id);
                            if (index != -1) {
                              records![index] = updatedRecord;
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF195DAD)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Edit', style: TextStyle(fontSize: 25)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}