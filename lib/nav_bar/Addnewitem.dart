import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddNewItemPage extends StatefulWidget {
  const AddNewItemPage({Key? key}) : super(key: key);

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  late TextEditingController itemNameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  String? _selectedCategory;
  File? _imageFile;
  final picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController();
    priceController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addItem() async {
    if (_imageFile == null) {
      _showAlertDialog('Error', 'Please select an image for the item.');
      return;
    }

    if (itemNameController.text.isEmpty) {
      _showAlertDialog('Error', 'Please enter the item name.');
      return;
    }

    if (priceController.text.isEmpty) {
      _showAlertDialog('Error', 'Please enter the price.');
      return;
    }

    if (quantityController.text.isEmpty) {
      _showAlertDialog('Error', 'Please enter the quantity.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final base64Image = base64Encode(_imageFile!.readAsBytesSync());
    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/Items'); // Replace with your API endpoint

    final headers = {
      'Authorization': 'Bearer YOUR_API_KEY', // Replace with your API key
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'itemName': itemNameController.text,
      'price': double.parse(priceController.text),
      'quantity': int.parse(quantityController.text),
      'category': _selectedCategory,
      'image': 'data:image/jpeg;base64,$base64Image',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        _showAlertDialog('Success', 'Item added successfully.');
      } else {
        _showAlertDialog(
            'Error', 'Failed to add item. Please try again later.');
      }
    } on SocketException catch (e) {
      _showAlertDialog('Network Error',
          'Failed to connect to the server. Please check your network connection and try again.');
    } catch (e) {
      _showAlertDialog(
          'Error', 'An unexpected error occurred. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF043F84),
        title: Text(
          'Add New Item',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 40),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9EFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: itemNameController,
                          decoration: InputDecoration(
                            labelText: 'Name of Item',
                            hintText: 'e.g., Kurkure',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: isSmallScreen ? 14 : 18,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Price (Rs.)',
                            hintText: 'e.g., 20',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: isSmallScreen ? 14 : 18,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        TextField(
                          controller: quantityController,
                          decoration: InputDecoration(
                            labelText: 'Quantity in stock',
                            hintText: 'e.g., 200',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: isSmallScreen ? 14 : 18,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              color: Colors.black,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              child: Text('Snacks'),
                              value: 'Snacks',
                            ),
                            DropdownMenuItem(
                              child: Text('Beverages'),
                              value: 'Beverages',
                            ),
                            DropdownMenuItem(
                              child: Text('Fast Food'),
                              value: 'Fast Food',
                            ),
                            DropdownMenuItem(
                              child: Text('Others'),
                              value: 'Others',
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        GestureDetector(
                          onTap: () {
                            _showImageSourceSelection(context);
                          },
                          child: Container(
                            height: 300,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _imageFile == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Click on the picture',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      _imageFile!,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        ElevatedButton(
                          onPressed: _addItem,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF195DAD)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 14.0 : 20.0,
                                horizontal: 50.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF195DAD),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showImageSourceSelection(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _captureImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
