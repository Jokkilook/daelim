import 'dart:convert';

import 'package:daelim/config.dart';
import 'package:daelim/models/auth_data.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<AuthData?> signIn(
      {required String email, required String pw}) async {
    final loginData = {
      "email": email,
      "password": pw,
    };

    final response = await http.post(
      Uri.parse(getTokenUrl),
      body: jsonEncode(loginData),
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return null;

    final bodyJson = jsonDecode(body) as Map<String, dynamic>;
    bodyJson.addAll({'email': email});

    try {
      return AuthData.fromMap(bodyJson);
    } catch (e, stackTrace) {
      Log.cyan("유저 정보 파싱 에러: $e\n$stackTrace");
      return null;
    }
  }

  static Future<bool> changePassword(String newPassword) async {
    return false;
  }
}
