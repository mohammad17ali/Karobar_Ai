import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchItems {
  static const String apiUrl =
      "https://api.airtable.com/v0/appWaAdFLtWA1IAZM/Products?maxRecords=3&view=Grid%20view";
  static const String apiKey = "YOUR_SECRET_API_TOKEN";

  static Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    List<Map<String, dynamic>> foodItems = [];

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

          foodItems.add({
            'ItemID': fields['Product_ID'] ?? '',
            'name': fields['Name'] ?? '',
            'price': fields['Price'] ?? 0,
            'image': fields['Image'] != null && fields['Image'].isNotEmpty
                ? fields['Image'][0]['url']
                : 'lib/assets/placeholder.png', 
            'category': fields['category'] ?? [],
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error: $e');
    }

    return foodItems;
  }
}
