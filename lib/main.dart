import 'package:flutter/material.dart';
import 'package:karobar/SplashScreen.dart';
import 'package:karobar/conexnav.dart';
import 'package:karobar/nav_bar/cart_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash', // Initial route to Sp lashScreen x
      routes: {
        '/splash': (context) => SplashScreen(), // SplashScreen as initial route
        '/nav': (context) => ConvexNavBar(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
