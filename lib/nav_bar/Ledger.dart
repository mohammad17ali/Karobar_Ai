import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:karobar/nav_bar/Addnewitem.dart';

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
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.book, size: 40), // Add ledger icon
                  SizedBox(width: 10), // Space between icon and text
                  Text('Ledger',
                      style: TextStyle(fontSize: 30)), // Add Ledger text
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'Go to shop',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100], // Background color
                borderRadius: BorderRadius.circular(20), // Curved border
                border:
                    Border.all(color: Colors.blue, width: 2), // Border outline
              ),
              padding: EdgeInsets.all(10),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
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
                                      fontSize: 20, color: Colors.black),
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
                                      fontSize: 20, color: Colors.black),
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
                                      fontSize: 20, color: Colors.black),
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
                                      fontSize: 20, color: Colors.black),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewItemPage()),
                );
              },
              icon: Icon(Icons.add_circle_outline_outlined,
                  color: Colors.white, size: 40),
              label:
                  Text('Add new item', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontSize: 30),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, size: 60.0, color: Colors.white),
                      Text(
                        'Record',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Ledger(),
  ));
}
