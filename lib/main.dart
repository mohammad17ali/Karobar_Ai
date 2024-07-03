import 'package:flutter/material.dart';
import 'package:karobar/Navrail.dart';
import 'package:karobar/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash', // Initial route to SplashScreen
      routes: {
        '/splash': (context) => SplashScreen(), // SplashScreen as initial route
        '/nav': (context) => Navrail(),
      },
    );
  }
}
