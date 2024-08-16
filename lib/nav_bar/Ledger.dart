import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';

class Ledger extends StatefulWidget {
  const Ledger({Key? key}) : super(key: key);

  @override
  _LedgerState createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {
  List<Map<String, dynamic>> _ledgerData = [];
  bool _isLoading = false;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedStartDate && isStart) {
      setState(() {
        _selectedStartDate = picked;
      });
    } else if (picked != null && picked != _selectedEndDate && !isStart) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/tbludpgCbOeguELiy?filterByFormula=AND(IS_AFTER({Date}, "${DateFormat('yyyy-MM-dd').format(_selectedStartDate)}"), IS_BEFORE({Date}, "${DateFormat('yyyy-MM-dd').format(_selectedEndDate)}"))');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY',
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
        backgroundColor: Color(0xff043F84),
        title: Container(
          width: double.infinity,
          height: 80,
          child: Center(
            child: Text(
              'Ledger',
              style: TextStyle(fontSize: 30, color: Color(0xffFFFFFF)),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'From',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: Colors.blue),
                          onPressed: () => _selectDate(context, true),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedStartDate),
                          style: TextStyle(fontSize: 25, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    'To',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: Colors.blue),
                          onPressed: () => _selectDate(context, false),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedEndDate),
                          style: TextStyle(fontSize: 30, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
                height: 100,
              ),
              ElevatedButton(
                onPressed: fetchData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                child: Text(
                  'Get Data',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      columns: [
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total Sales',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Items',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'No. of Orders',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      rows: _ledgerData.map<DataRow>((entry) {
                        return DataRow(
                          cells: [
                            DataCell(Text(entry['date'] ?? '',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                            DataCell(Text(
                                entry['totalSales'] != null
                                    ? '\$${entry['totalSales'].toString()}'
                                    : '',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                            DataCell(Text(
                                entry['items'] != null
                                    ? entry['items'].join(', ')
                                    : '',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                            DataCell(Text(
                                entry['noOfOrders'] != null
                                    ? entry['noOfOrders'].toString()
                                    : '',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
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
