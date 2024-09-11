import 'dart:convert';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:daelim/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//https://daelim-api.fleecy.dev

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  final body = {
    'email': '202030330@daelim.ac.kr',
    'password': '202030330',
  };

  //로그인 API 호출
  void _onFetchedAPI() async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {},
      body: jsonEncode(body),
    );

    Log.red("${response.statusCode} / ${response.body}");
  }

  //패스워드 재설정
  void _onRecoveryPassword() {}

  //로그인 버튼
  void _onSignIn() async {
    Log.cyan(_emailController.value.text);
    Log.cyan(_pwController.value.text);

    final response = await http.post(Uri.parse(authUrl),
        body: jsonEncode({
          "email": _emailController.value.text,
          "password": _pwController.value.text,
        }));

    if (response.statusCode == 200) {
      Log.green("SUCCESS");
      Log.green(response.body);
    } else {
      Log.red("FAILED");
      Log.red(response.body);
    }
  }

  //타이틑 텍스트 위젯
  List<Widget> _buildTitleText() => [
        Text(
          "Hello Again!",
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        15.heightBox,
        Text(
          "Wellcom back you've\nbeen missed!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
      ];

  //람다 예시
  bool noLambda() {
    return false;
  }

  bool Lambda() => false;

  bool get getLambda => false;

  //텍스트 입력 위젯들
  List<Widget> _buildTextFields() => [
        _buildTextField(
          controller: _emailController,
          hintText: "Enter email",
        ),
        10.heightBox,
        _buildTextField(
          onObscure: (down) {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          controller: _pwController,
          hintText: "Password",
          obsecure: _isObscure,
        ),
      ];

  //텍스트 입력 위젯
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool? obsecure,
    Function(bool down)? onObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obsecure ?? false,
      decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          suffixIcon: obsecure != null
              ? GestureDetector(
                  onTapDown: (details) => onObscure?.call(true),
                  onTapUp: (details) => onObscure?.call(false),
                  child: Icon(obsecure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                )
              : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEDEE2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              36.heightBox,
              ..._buildTitleText(),
              25.heightBox,
              ..._buildTextFields(),
              16.heightBox,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onRecoveryPassword,
                  child: Text(
                    "Recovery Password",
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ),
              16.heightBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE46A61),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.poppins(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
