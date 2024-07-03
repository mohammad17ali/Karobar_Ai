import 'package:flutter/material.dart';

class Ledger extends StatefulWidget {
  const Ledger({Key? key}) : super(key: key);

  @override
  State<Ledger> createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100), // Add space above the table
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.blue[200]!), // Color of the header row
                columns: [
                  DataColumn(
                    label: Text('Date',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Total Sales',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Items Sold',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('2024-07-01')),
                    DataCell(Text('\$500')),
                    DataCell(Text('20')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('2024-06-30')),
                    DataCell(Text('\$700')),
                    DataCell(Text('30')),
                  ]),
                  // Add more DataRow widgets as needed
                ],
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
