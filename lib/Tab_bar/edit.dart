import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:karobar/Tab_bar/Snacks.dart';

class EditsnacksItem extends StatefulWidget {
  final snacksItem item;
  final Function onUpdate;

  const EditsnacksItem({Key? key, required this.item, required this.onUpdate})
      : super(key: key);

  @override
  State<EditsnacksItem> createState() => _EditsnacksItemState();
}

class _EditsnacksItemState extends State<EditsnacksItem> {
  late TextEditingController itemNameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item.itemName);
    priceController = TextEditingController(text: widget.item.price.toString());
    quantityController =
        TextEditingController(text: widget.item.quantity.toString());
  }

  Future<void> _updateItem() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.patch(
      Uri.parse(
          'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs/${widget.item.id}'),
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'Item Name': itemNameController.text,
          'Price': int.parse(priceController.text),
          'Quantity': int.parse(quantityController.text),
        }
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final updatedItem = snacksItem.fromJson(json.decode(response.body));
      widget.onUpdate(updatedItem);
      Navigator.pop(context);
    } else {
      throw Exception('Failed to update item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        backgroundColor: Color(0xFF195DAD),
        titleTextStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFA3D9FF).withOpacity(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Color(0xFFA3D9FF),
                  margin: EdgeInsets.all(100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: itemNameController,
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.black, // Increased label text size
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF195DAD),
                            fontWeight:
                                FontWeight.bold, // Increased input text size
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.black, // Increased label text size
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 20, // Increased input text size
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: quantityController,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.black, // Increased label text size
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 20, // Increased input text size
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: _updateItem,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF195DAD)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // Text color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 50.0), // Adjust padding as needed
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                                fontSize:
                                    20), // Increase text size if necessary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
