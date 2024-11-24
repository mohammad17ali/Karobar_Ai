import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';
import 'screens/home_page.dart';
import 'screens/cart_page.dart';
import 'screens/payment_page.dart';
import 'screens/payment_confirmation_page.dart';
import 'screens/dashboard_page.dart';
import 'utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karobar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.launchScreen,
      routes: {
        AppRoutes.launchScreen: (context) => LaunchScreen(),
        AppRoutes.homePage: (context) => HomePage(),
        AppRoutes.cartPage: (context) => CartPage(),
        AppRoutes.paymentPage: (context) => PaymentPage(),
        AppRoutes.paymentConfirmationPage: (context) => PaymentConfirmationPage(),
        AppRoutes.dashboardPage: (context) => DashboardPage(),
        '/cart': (context) => CartPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}
