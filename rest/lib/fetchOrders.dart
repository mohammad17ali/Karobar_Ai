import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchOrders {
  static const String apiUrl =
      "https://api.airtable.com/v0/appWaAdFLtWA1IAZM/Orders";
  static const String apiKey = "API_KEY";

  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    List<Map<String, dynamic>> ordersList = [];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        for (var record in data['records']) {
          final fields = record['fields'];

          ordersList.add({
            'OrderNum': fields['OrderNum'] ?? '1',
            'Amount': fields['Amount'] ?? '0',
            'Status': fields['Status'] ?? 'Active',
            'OrderID': fields['OrderID'] ?? ['user123'],
          });
        }
      } else {
        print('Failed to fetch Orders: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error: $e');
    }

    return ordersList;
  }
}
