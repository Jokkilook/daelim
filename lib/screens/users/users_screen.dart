import 'dart:convert';

import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helpers/StorageHelper.dart';
import 'package:daelim/models/user_data.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/users/user_item.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserData> userList = [];
  List<UserData> searchedList = [];

  final List<UserData> dummyList = List.generate(
    20,
    (index) {
      return UserData(
        id: "$index",
        name: "유저 $index",
        student_number: "$index",
        email: "$index@daelim.ac.kr",
        profile_image: defaultImageUrl,
      );
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUsers();
    // searchedList = userList;
  }

  void _onSearch(String value) {
    searchedList = [];
    if (value.isEmpty) {
      return;
    }
    setState(() {
      searchedList = userList
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });

    // for (var user in userList) {
    //   user.name.contains(value) ? searchedList.add(user) : null;
    // }
  }

  Future _fetchUsers() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.token;

    final response = await http.get(
      Uri.parse(getUserlist),
      headers: {HttpHeaders.authorizationHeader: "$tokenType $token"},
    );

    final body = utf8.decode(response.bodyBytes);

    await Future.delayed(const Duration(seconds: 2));

    if (response.statusCode != 200) {}

    final userData = jsonDecode(body);
    Log.black(userData);

    final List<dynamic> userListJson = userData['data'];
    List<UserData> userLists =
        userListJson.map((json) => UserData.fromMap(json)).toList();

    userList = userLists;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.users,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //유저 목록 타이틀
                const Text(
                  "유저 목록",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),

                const SizedBox(height: 15),

                //검색바
                TextField(
                  onChanged: (value) => _onSearch(value),
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFE4E4E7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFE4E4E7),
                      ),
                    ),
                    prefixIcon: const Icon(LucideIcons.search),
                    hintText: "유저 검색...",
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          searchedList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "검색 결과가 없습니다.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFA5A5A5),
                    ),
                  ))
              :

              //유저 목록
              // FutureBuilder(
              //   future: _fetchUsers(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Expanded(
              //           child: Center(child: CircularProgressIndicator()));
              //     }

              //     if (snapshot.connectionState == ConnectionState.done) {
              //       return
              Expanded(
                  child: ListView.separated(
                    itemCount: searchedList.isEmpty
                        ? userList.length
                        : searchedList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final user = searchedList.isEmpty
                          ? userList[index]
                          : searchedList[index];

                      return UserItem(
                          name: user.name,
                          stNum: user.student_number,
                          ImageUrl: user.profile_image ?? defaultImageUrl);
                    },
                  ),
                )
          //       ;
          //     } else {
          //       return const Expanded(
          //         child: Center(
          //           child: Text("유저가 없습니다."),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
