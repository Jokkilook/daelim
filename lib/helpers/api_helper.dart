import 'dart:convert';
import 'dart:io';

import 'package:daelim/config.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:daelim/models/auth_data.dart';
import 'package:daelim/models/user_data.dart';
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
      Uri.parse(Config.api.getToken),
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

  static Future<({bool success, String error})> changePassword(
      String newPassword) async {
    final authData = StorageHelper.authData!;

    final response = await http.post(
      Uri.parse(Config.api.changePassword),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${authData.token}"},
      body: jsonEncode({"password": newPassword}),
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return (success: false, error: body);

    return (success: true, error: "");
  }

  static Future<List<UserData>> fetchUseList() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.token;
    List<UserData> userLists = [];

    final response = await http.get(
      Uri.parse(Config.api.getUserList),
      headers: {HttpHeaders.authorizationHeader: "$tokenType $token"},
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    await Future.delayed(const Duration(seconds: 2));

    if (statusCode != 200) {
      return userLists;
    }

    final userData = jsonDecode(body);
    Log.black(userData);

    final List<dynamic> userListJson = userData['data'];
    userLists = userListJson.map((json) => UserData.fromMap(json)).toList();

    return userLists;
  }
}
