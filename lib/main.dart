import 'package:flutter/material.dart';
import 'package:karobar/SplashScreen.dart';
import 'package:karobar/conexnav.dart';

void main() {
  runApp(MyApp());
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
      },
    );
  }
}
