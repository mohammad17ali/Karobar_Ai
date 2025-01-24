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
        automaticallyImplyLeading: false,
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
            padding: const EdgeInsets.only(right: 30.0,bottom: 10),
            child: Container(
              padding: EdgeInsets.all(5),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.white,
                    ),
                    child: const Text(
                      "Menu",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shadowColor: Colors.white,
                    ),
                    child: const Text(
                      "Dash",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            )
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

          // Ledger Content
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
