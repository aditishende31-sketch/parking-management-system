import 'package:flutter/material.dart';
import 'screens/login_screen.dart';


void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Parking Allotment System',

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const LoginScreen(),
    );
  }
}