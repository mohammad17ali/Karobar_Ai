import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ledger extends StatefulWidget {
  const Ledger({Key? key}) : super(key: key);

  @override
  State<Ledger> createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {
  List<Map<String, dynamic>> _ledgerData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/tbludpgCbOeguELiy');
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _ledgerData = jsonData['records']
            .map<Map<String, dynamic>>((entry) => {
                  'date': entry['fields']['Date'],
                  'totalSales': entry['fields']['Total Sales'],
                  'items': entry['fields']['Items'],
                  'noOfOrders': entry['fields']['No. of Orders'],
                })
            .toList();
        _isLoading = false;
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA3D9FF).withOpacity(0.5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                // color: Colors.white,
              ),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xFF075D9B)),
                      columns: [
                        DataColumn(
                          label: Text('Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text('Total Sales',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text('Items',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text('No. of Orders',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white)),
                        ),
                      ],
                      rows: _ledgerData.map<DataRow>((entry) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  entry['date'] ?? '',
                                  style: TextStyle(
                                    fontSize: 20, // Adjust text size here
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  entry['totalSales'] != null
                                      ? '\$${entry['totalSales'].toString()}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 20, // Adjust text size here
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  entry['items'] != null
                                      ? entry['items'].join(', ')
                                      : '',
                                  style: TextStyle(
                                    fontSize: 20, // Adjust text size here
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  entry['noOfOrders'] != null
                                      ? entry['noOfOrders'].toString()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 20, // Adjust text size here
                                    color: Colors.black, // Text color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Ledger(),
  ));
}
