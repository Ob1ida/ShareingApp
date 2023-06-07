import 'package:flutter/material.dart';

void main() {
  runApp(
    // ignore: prefer_const_constructors
    MyApp(),
  );
}
 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.cyan,
      body: Container(),
     ),


   );
  }
}