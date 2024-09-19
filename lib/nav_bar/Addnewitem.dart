import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

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

    // This URL should be the URL where the image is hosted or the location it will be uploaded to.
    final String imageUrl =
        'https://your-image-hosting-service.com/path-to-image.jpg'; // Use actual URL here

    final url =
        Uri.parse('https://api.airtable.com/v0/appgAln53ifPLiXNu/Items');

    final headers = {
      'Authorization':
          'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451', // Replace with your actual API key
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "records": [
        {
          "fields": {
            "Item Name": itemNameController.text,
            "Price": double.parse(priceController.text),
            "Picture": [
              {
                "url": imageUrl, // Use the hosted image URL here
              }
            ],
            "Quantity": int.parse(quantityController.text),
            "Category": _selectedCategory
          }
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showAlertDialog('Success', 'Item added successfully.');
      } else {
        _showAlertDialog(
            'Error', 'Failed to add item. Error code: ${response.statusCode}');
      }
    } on SocketException {
      _showAlertDialog('Network Error',
          'Failed to connect to the server. Please check your network connection and try again.');
    } catch (e) {
      _showAlertDialog(
          'Error', 'An unexpected error occurred. Error details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                                          fontSize: isSmallScreen ? 16 : 20,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        'to add',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 20,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        ElevatedButton(
                          onPressed: _addItem,
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Color(0xFF043F84),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _showImageSourceSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _uploadImage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _captureImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
