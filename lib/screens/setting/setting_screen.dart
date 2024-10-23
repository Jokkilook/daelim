import 'dart:convert';
import 'dart:io';

import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helpers/StorageHelper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? _userName;
  String? _userStudentNumder;
  String? _userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  //설정 페이지 로그인 된 유저 정보 가져오기 ( 토큰으로 유저 정보를 요청하는 api 사용 )
  Future<void> _fetchUserData() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.token;

    final response = await http.get(
      Uri.parse(getUserDataUrl),
      headers: {HttpHeaders.authorizationHeader: "$tokenType $token"},
    );

    final body = utf8.decode(response.bodyBytes);

    await Future.delayed(const Duration(seconds: 2));

    if (response.statusCode != 200) {
      //throw Exception(response.body);
      _userName = "데이터를 불러올 수 없습니다.";
      _userStudentNumder = body;
      _userProfileImageUrl = "";
    }

    final userData = jsonDecode(body);

    setState(() {
      _userName = userData?["name"] ?? "";
      _userStudentNumder = userData?["student_number"] ?? "";
      _userProfileImageUrl = userData?["profile_image"] ??
          "https://daelim-server.fleecy.dev/storage/v1/object/public/icons/user.png";
    });
  }

  //프로필 이미지 업로드
  Future<void> _uploadProfileImage() async {
    if (_userProfileImageUrl == null || _userProfileImageUrl?.isEmpty == true) {
      return;
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      final token = StorageHelper.authData!.token;
      final imagePath = result.files.single.path;
      // final imageBytes = imageFile.bytes;

      if (imagePath == null) return;

      final uploadRequest = http.MultipartRequest(
        "POST",
        Uri.parse(setProfileImageUrl),
      )
        ..headers.addAll({HttpHeaders.authorizationHeader: "Bearer $token"})
        ..files.add(await http.MultipartFile.fromPath("image", imagePath));

      final response = await uploadRequest.send();

      if (response.statusCode != 200) {
        Log.red("프로필 이미지 업로드 에러 : ${response.statusCode}");
        return;
      }

      _fetchUserData();
    } else {
      // User canceled the picker
    }

    Log.cyan("야스");
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.setting,
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () async {
                await _uploadProfileImage();
              },
              child: CircleAvatar(
                backgroundImage: _userProfileImageUrl != null
                    ? _userProfileImageUrl!.isNotEmpty
                        ? NetworkImage(_userProfileImageUrl!)
                        : null
                    : null,
                child: _userProfileImageUrl != null
                    ? _userProfileImageUrl!.isEmpty
                        ? const Icon(Icons.cancel)
                        : null
                    : const CircularProgressIndicator(),
              ),
            ),
            title: Text(_userName ?? "데이터 로딩 중..."),
            subtitle: _userStudentNumder != null
                ? Text(
                    _userStudentNumder!,
                    maxLines: 1,
                  )
                : null,
          )
        ],
      ),
    );
  }
}
