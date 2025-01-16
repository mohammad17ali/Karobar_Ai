import 'dart:convert';
import 'package:http/http.dart' as http;

class LedgerService {
  static const String _baseUrl =
      "https://api.airtable.com/v0/<xx>/Ledger";
  static const String _apiToken = "API_KEY";

  Future<List<Map<String, dynamic>>> fetchLedgerData() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {"Authorization": "Bearer $_apiToken"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List records = data['records'];

        return records.map((record) {
          final fields = record['fields'];
          return {
            "dayNum": fields['dayNum'],
            "date": fields['Date'],
            "totalSales": fields['TotalSales'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load ledger data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
