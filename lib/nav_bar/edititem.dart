import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../recordid.dart'; // Adjust the path to your Record model

class Edititem extends StatefulWidget {
  final Record record;

  const Edititem({Key? key, required this.record}) : super(key: key);

  @override
  State<Edititem> createState() => _EdititemState();
}

class _EdititemState extends State<Edititem> {
  late TextEditingController _itemNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late String _selectedCategory;
  List<String> _categories = ['Snacks', 'Fast Food', 'Beverages', 'Others'];

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.record.itemName);
    _priceController =
        TextEditingController(text: widget.record.price.toString());
    _quantityController =
        TextEditingController(text: widget.record.quantity.toString());
    _selectedCategory = widget.record.category;
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
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/tblvBQeCreDaryIPs/${widget.record.id}');
    final response = await http.patch(
      url,
      headers: {
        'Authorization':
            'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451', // Replace with your actual API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "fields": {
          "Item Name": _itemNameController.text,
          "Price": int.parse(_priceController.text),
          "Picture": [
            {"url": widget.record.pictureUrl}
          ],
          "Quantity": int.parse(_quantityController.text),
          "Category": _selectedCategory,
          "ItemID": widget.record.itemID, // Ensure this is included if needed
        }
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      // Handle error
      print('Failed to update item: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Item',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Color(0xFF195DAD),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Color(0xFFD9EFFF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                _buildTextField(
                    _itemNameController, 'Name of Item', 'e.g. Kurkure'),
                SizedBox(height: 20),
                _buildTextField(_priceController, 'Price (Rs.)', 'e.g. 20',
                    isNumber: true),
                SizedBox(height: 20),
                _buildTextField(
                    _quantityController, 'Quantity in stock', 'e.g. 200',
                    isNumber: true),
                SizedBox(height: 20),
                _buildCategoryDropdown(),
                SizedBox(height: 20),
                _buildImageSection(),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text(
                    'Update Item',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF195DAD),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(fontSize: 25),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF195DAD),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                    side: BorderSide(color: Color(0xFF195DAD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, String hintText,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        border: UnderlineInputBorder(),
      ),
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        border: UnderlineInputBorder(),
      ),
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      items: _categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(
            category,
            style: TextStyle(
              color:
                  _selectedCategory == category ? Colors.black : Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue!;
        });
      },
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: Color(0xFFA5CEFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.record.pictureUrl.isEmpty
              ? Center(
                  child: Text(
                  'Picture Not Found',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ))
              : Image.network(
                  widget.record.pictureUrl,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(height: 10),
        Text(
          'Click on the picture',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}
