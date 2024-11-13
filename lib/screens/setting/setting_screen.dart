import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helpers/storage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/setting/dialogs/change_password_dialog.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
      Uri.parse(Config.api.getUserData),
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
      final imageName = result.files.single.name;
      final imageMime = lookupMimeType(imageName) ?? "imgae/jpeg";
      // final imageBytes = imageFile.bytes;
      Uint8List? imageBytes;

      if (kIsWeb) {
        imageBytes = result.files.single.bytes;
      }

      if (imagePath == null) return;
      Log.blue(imageName);
      Log.red(imageMime);

      final uploadRequest = http.MultipartRequest(
        "POST",
        Uri.parse(Config.api.setProfileImage),
      )
        ..headers.addAll({HttpHeaders.authorizationHeader: "Bearer $token"})
        ..files.add(imageBytes != null
            ? http.MultipartFile.fromBytes(
                "image",
                imageBytes,
                filename: imageName,
                contentType: MediaType.parse(imageMime),
              )
            : await http.MultipartFile.fromPath(
                "image",
                imagePath,
                contentType: MediaType.parse(imageMime),
              ));

      final response = await uploadRequest.send();
      final uploadResult = await http.Response.fromStream(response);
      Log.green("${uploadResult.statusCode} : ${uploadResult.body}");

      if (response.statusCode != 200) {
        Log.red("프로필 이미지 업로드 에러 : ${uploadResult.body}");
        return;
      }

      _fetchUserData();
    } else {
      // User canceled the picker
    }
  }

  //비밀번호 변경 다이얼로그
  Future _changePasswordDialog() async {
    Log.black("눌렸지비");
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.setting,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("비밀번호 변경"),
                ElevatedButton(
                  onPressed: _changePasswordDialog,
                  child: const Text("변경하기"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
