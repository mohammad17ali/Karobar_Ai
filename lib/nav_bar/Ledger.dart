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
    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/Ledger?view=Grid%20view&filterByFormula=AND(IS_AFTER({Date}, "${DateFormat('yyyy-MM-dd').format(_selectedStartDate)}"), IS_BEFORE({Date}, "${DateFormat('yyyy-MM-dd').format(_selectedEndDate)}"))');

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
        backgroundColor: const Color(0xff043F84),
        title: const Text(
          'Ledger',
          style: TextStyle(fontSize: 24, color: Color(0xffFFFFFF)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffE0E7FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              onPressed: () => _selectDate(context, true),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(_selectedStartDate),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'To',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffE0E7FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              onPressed: () => _selectDate(context, false),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd').format(_selectedEndDate),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: fetchData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00A4E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  child: const Text(
                    'Get Data',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xff043F84), width: 2),
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xff043F84)),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Highest Selling',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Items Sold',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total Sales',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        rows: _ledgerData.map<DataRow>((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color(0xffFFDDDD),
                                child: Text(entry['date'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                              DataCell(Text(
                                  entry['items'] != null
                                      ? entry['items'].join(', ')
                                      : '',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black))),
                              DataCell(Text(
                                  entry['noOfOrders'] != null
                                      ? entry['noOfOrders'].toString()
                                      : '',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black))),
                              DataCell(Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color(0xffEEDCFF),
                                child: Text(
                                    entry['totalSales'] != null
                                        ? '\$${entry['totalSales'].toString()}'
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
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
