import 'package:flutter/material.dart';
import 'package:karobar_v2/screens/home.dart';
import '../services/fetchLedger.dart';
import '../components/sidebar.dart'; 
import '../services/dummyorders.dart'; 
import '../services/dummylist.dart'; 

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  final LedgerService _ledgerService = LedgerService();
  late Future<List<Map<String, dynamic>>> _ledgerData;
  int _toggleIndex = 1;

  @override
  void initState() {
    super.initState();
    _ledgerData = _ledgerService.fetchLedgerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "The Zaika Restaurant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple[800],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: ToggleButtons(
              isSelected: [_toggleIndex == 0, _toggleIndex == 1],
              onPressed: (int index) {
                setState(() {
                  _toggleIndex = index;
                  if (_toggleIndex == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                });
              },
              borderRadius: BorderRadius.circular(16.0),
              selectedBorderColor: Colors.white12,
              borderColor: Colors.white12,
              selectedColor: Colors.white,
              fillColor: Colors.deepPurple[300],
              color: Colors.deepPurple[100],
              constraints: const BoxConstraints(
                minWidth: 100.0,
                minHeight: 40.0,
              ),
              children: const [
                Text('Menu', style: TextStyle(fontSize: 14)),
                Text('Dashboard', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            ordersList: [],
            cartList: [],
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ledgerData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No ledger data available.'),
                  );
                }

                final ledgerData = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: DataTable(
                      columnSpacing: 20.0,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total Sales (₹)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                      rows: ledgerData.map((entry) {
                        return DataRow(
                          cells: [
                            //DataCell(Text(entry['dayNum'])),
                            DataCell(Text(entry['date'])),
                            DataCell(Text(entry['totalSales'].toString())),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
