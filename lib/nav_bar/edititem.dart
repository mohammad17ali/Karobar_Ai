import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Record {
  final String id;
  final String pictureUrl;
  final String itemName;
  final int price;
  final int quantity;
  final String category;
  final String itemID;

  Record({
    required this.id,
    required this.pictureUrl,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.itemID,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'];
    return Record(
      id: json['id'],
      pictureUrl: fields['Picture']?.first['url'] ?? '',
      itemName: fields['Item Name'] ?? '',
      price: fields['Price'] ?? 0,
      quantity: fields['Quantity'] ?? 0,
      category: fields['Category'] ?? '',
      itemID: fields['ItemID'] ?? '',
    );
  }
}

class Edititem extends StatefulWidget {
  final Record record;

  const Edititem({Key? key, required this.record}) : super(key: key);

  @override
  State<Edititem> createState() => _EditSnackPageState();
}

class _EditSnackPageState extends State<Edititem> {
  late TextEditingController _itemNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.record.itemName);
    _priceController =
        TextEditingController(text: widget.record.price.toString());
    _quantityController =
        TextEditingController(text: widget.record.quantity.toString());
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/Items/${widget.record.itemID}');

    final updatedFields = {
      'fields': {
        'Item Name': _itemNameController.text,
        'Price': int.tryParse(_priceController.text) ?? 0,
        'Quantity': int.tryParse(_quantityController.text) ?? 0,
      }
    };

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization':
              'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedFields),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        print('Update successful');
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Handle the error
        print('Failed to update record: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while updating record: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Snack'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
