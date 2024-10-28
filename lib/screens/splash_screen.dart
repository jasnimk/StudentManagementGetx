import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_management_getx/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png'),
          const Text('Getx Method'),
        ],
      ),
    );
  }
}
