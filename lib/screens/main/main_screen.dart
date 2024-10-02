import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Text(
          "Main Screen",
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}