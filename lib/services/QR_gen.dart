import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;

  // UPI ID for the payment
  final String upiId = "1234567899@abcupi";

  PaymentPage({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    // UPI Payment URI generation
    String upiUrl = generateUpiUrl(upiId, totalAmount);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003366),
        title: Text(
          'Payment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pay ₹${totalAmount.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // QR Code Display
            QrImage(
              data: upiUrl,
              size: 250.0,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
            SizedBox(height: 16),
            Text(
              "Scan the QR Code to pay",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF003366),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                // Go back or perform any additional logic
                Navigator.pop(context);
              },
              child: Text(
                "Done",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate the UPI payment URL
  String generateUpiUrl(String upiId, double amount) {
    return "upi://pay?pa=$upiId&pn=Karobar&am=${amount.toStringAsFixed(2)}&cu=INR";
  }
}

