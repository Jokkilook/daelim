import 'dart:convert';
import 'dart:io';

import 'package:daelim/common/typedef/app_typedef.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:daelim/models/auth_data.dart';
import 'package:daelim/models/message_data.dart';
import 'package:daelim/models/user_data.dart';
import 'package:daelim/routes/app_router.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  //GET
  static Future<http.Response> get(String url) {
    final authData = StorageHelper.authData!;

    return http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader:
            "${authData.tokenType} ${authData.token}"
      },
    );
  }

  //POST
  static Future<http.Response> post(String url, {Map<String, dynamic>? body}) {
    final authData = StorageHelper.authData;

    return http.post(
      Uri.parse(url),
      headers: authData != null
          ? {
              HttpHeaders.authorizationHeader:
                  "${authData.tokenType} ${authData.token}"
            }
          : null,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<AuthData?> signIn(
      {required String email, required String pw}) async {
    final loginData = {
      "email": email,
      "password": pw,
    };

    final response = await post(Config.api.getToken, body: loginData);

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

  static Future signOut(BuildContext context) async {
    await StorageHelper.removeAuthData();

    if (!context.mounted) {
      return;
    }

    appRouter.goNamed(AppScreen.login.name);
  }

  static Future<Result> changePassword(String newPassword) async {
    final response =
        await post(Config.api.changePassword, body: {"password": newPassword});

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return (false, body);

    return (true, "");
  }

  static Future<List<UserData>> fetchUseList() async {
    List<UserData> userLists = [];

    final response = await get(Config.api.getUserList);

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

  //채팅방 생성 API
  ///-[targetId] 상대방 ID
  static Future<ResultWithCode> createChatRoom(String targetId) async {
    final response = await post(
      Config.api.createRoom,
      body: {"user_id": targetId},
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      return (statusCode, body);
    }

    final bodyJson = jsonDecode(body);
    final int code = bodyJson['code'] ?? 404;
    final Map<String, dynamic> message = bodyJson['message'] ?? {};
    final String roomId = message["room_id"] ?? "";
    final String joinedAt = message["joined_at"] ?? "";

    Log.green("끼룩: $message");

    return (code, roomId);
  }
}
