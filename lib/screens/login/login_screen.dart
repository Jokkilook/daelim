import 'dart:convert';

import 'package:daelim/helpers/api_helper.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:daelim/enums/sso_enum.dart';
import 'package:daelim/extensions/context_extension.dart';
import 'package:daelim/common/widgets/gradient_divider.dart';
import 'package:daelim/routes/app_router.dart';
import 'package:daelim/routes/app_screen.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = "202030330@daelim.ac.kr";
    _pwController.text = "202030330";
  }

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
      Uri.parse(getTokenUrl),
      headers: {},
      body: jsonEncode(body),
    );

    Log.red("${response.statusCode} / ${response.body}");
  }

  //패스워드 재설정
  void _onRecoveryPassword() {}

  //로그인 버튼
  void _onSignIn() async {
    final email = _emailController.value.text;
    final pw = _pwController.value.text;

    var authData = await ApiHelper.signIn(email: email, pw: pw);

    if (authData == null) {
      if (mounted) {
        context.showSnackBar(message: "로그인을 실패했습니다.");
      }
      return;
    } else {
      await StorageHelper.setAuthData(authData);

      mounted ? appRouter.goNamed(AppScreen.users.name) : null;
    }
  }

  //SSO 로그인 버튼
  void _onSsoSignIn(SsoEnum type) {
    switch (type) {
      case SsoEnum.google:
        context.showSnackBar(message: "준비 중인 기능입니다.");
        break;

      case SsoEnum.apple:
        context.showSnackBar(message: "준비 중인 기능입니다.");
        break;

      case SsoEnum.github:
        context.showSnackBar(message: "준비 중인 기능입니다.");
        break;
    }
  }

  //타이틑 텍스트 위젯
  List<Widget> _buildTitleText() => [
        const Text(
          "Hello Again!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        15.heightBox,
        const Text(
          "Wellcom back you've\nbeen missed!",
          textAlign: TextAlign.center,
          style: TextStyle(
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
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none);

    return TextField(
      controller: controller,
      obscureText: obsecure ?? false,
      decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.white,
          enabledBorder: border,
          focusedBorder: border,
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

  Widget _buildSSOButton({
    required String iconUrl,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.network(iconUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEDEE2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                  color: context.textTheme.bodyMedium?.color),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          child: const Text(
                            "Recovery Password",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      16.heightBox,
                      //Sign in Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _onSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE46A61),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              shadowColor: const Color(0xFFE46A61),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),

                      40.heightBox,

                      //Or continue with
                      Row(
                        children: [
                          const Expanded(child: GradientDivider()),
                          15.widthBox,
                          const Text(
                            "Or continue with",
                          ),
                          15.widthBox,
                          const Expanded(child: GradientDivider(reverse: true)),
                        ],
                      ),

                      40.heightBox,

                      //SSO Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSSOButton(
                              iconUrl: icGoogle,
                              onTap: () => _onSsoSignIn(SsoEnum.google)),
                          _buildSSOButton(
                              iconUrl: icGithub,
                              onTap: () => _onSsoSignIn(SsoEnum.github)),
                          _buildSSOButton(
                              iconUrl: icApple,
                              onTap: () => _onSsoSignIn(SsoEnum.apple)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
