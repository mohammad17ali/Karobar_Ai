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
  late TextEditingController categoryController;
  File? _imageFile;
  final picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController();
    priceController = TextEditingController();
    quantityController = TextEditingController();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    categoryController.dispose();
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
      // Handle the case where no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select an image for the item.'),
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
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Prepare data to send to API
    final base64Image = base64Encode(_imageFile!.readAsBytesSync());
    final url = Uri.parse(
        'https://api.airtable.com/v0/appgAln53ifPLiXNu/Items'); // Replace with your API endpoint

    // Prepare headers and body
    final headers = {
      'Authorization':
          'Bearer patXmwDbTcQr2K1lJ.de9224db382239bd6b93f162a21d6b0db884233ee5f59ab1458e5851b6764451+', // Replace with your API key
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'itemName': itemNameController.text,
      'price': double.parse(priceController.text),
      'quantity': int.parse(quantityController.text),
      'category': categoryController.text,
      'image': 'data:image/jpeg;base64,$base64Image',
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Item added successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Item added successfully.'),
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
      } else {
        // Handle error
        print('Failed to add item');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add item. Please try again later.'),
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
    } on SocketException catch (e) {
      print('Network error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Network Error'),
            content: Text(
                'Failed to connect to the server. Please check your network connection and try again.'),
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
    } catch (e) {
      print('Unexpected error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An unexpected error occurred. Please try again.'),
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color(0xFFA3D9FF).withOpacity(0.5),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 40),
              child: Center(
                child: Container(
                  color: Color(0xFFA3D9FF),
                  margin: EdgeInsets.all(50),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: itemNameController,
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 20 : 30,
                              color: Colors.black,
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
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 20 : 30,
                              color: Colors.black,
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
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 20 : 30,
                              color: Colors.black,
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
                          controller: categoryController,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                              fontSize: isSmallScreen ? 20 : 30,
                              color: Colors.black,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Color(0xFF195DAD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        _imageFile == null
                            ? GestureDetector(
                                onTap: () {
                                  _showImageSourceSelection(context);
                                },
                                child: Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.add_a_photo, size: 50),
                                ),
                              )
                            : Image.file(
                                _imageFile!,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(height: isSmallScreen ? 10 : 20),
                        ElevatedButton(
                          onPressed: _addItem,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF195DAD)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14.0 : 20.0,
                                  horizontal: 50.0),
                            ),
                          ),
                          child: Text(
                            'Add Item',
                            style: TextStyle(fontSize: isSmallScreen ? 16 : 20),
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
