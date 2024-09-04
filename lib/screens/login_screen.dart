import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daelim/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//https://daelim-api.fleecy.dev

class _LoginScreenState extends State<LoginScreen> {
  final body = {
    'email': '202030330@daelim.ac.kr',
    'password': '202030330',
  };

  void _onFetchedAPI() async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {},
      body: jsonEncode(body),
    );

    print("${response.statusCode} / ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: ElevatedButton(
                onPressed: _onFetchedAPI, child: const Text("API 호출"))),
      ),
    );
  }
}
