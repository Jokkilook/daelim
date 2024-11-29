import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/extensions/context_extension.dart';
import 'package:daelim/helpers/api_helper.dart';
import 'package:daelim/models/user_data.dart';
import 'package:daelim/routes/app_router.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/api_error.dart';
import 'package:daelim/screens/users/user_item.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';

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
        profile_image: Config.image.defaultProfile,
      );
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserList();
    // searchedList = userList;
  }

  void _onSearch(String value) {
    setState(() {
      searchedList = userList
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future _fetchUserList() async {
    final userList = await ApiHelper.fetchUseList();
    setState(() {
      this.userList = userList;
      searchedList = userList;
    });
  }

  //채팅방 개설
  void _onCreateRoom(UserData userData) async {
    Log.green(userData.name);

    final (code, roomId) = await ApiHelper.createChatRoom(userData.id);

    switch (code) {
      case 200:
        //채팅방 개설 완료
        Log.red(roomId);
        break;
      case 1001:
        //상대방 ID 필수
        return context.showSnackBar(message: "상대방 ID는 필수입니다.");
      case 1002:
        //자기 자신
        return context.showSnackBar(message: "자신과 대화할 수 없습니다.");
      case 1003:
        //상대방 없음
        return context.showSnackBar(message: "상대방 검색에 실패했습니다.");
      case 1004:
        //오직 챗봇만 가능
        return context.showSnackBar(message: "챗봇만 대화가 가능합니다.");
      case 1005:
        //이미 있음
        Log.red("이미 있는 채팅방 : $roomId");
        appRouter
            .pushNamed(AppScreen.chat.name, pathParameters: {"roomId": roomId});
        return;
      default:
        return context.showSnackBar(message: "끼룩");
    }

    // if (code != 200) {
    //   return context.showSnackBar(message: error);
    // }

    // if (code == ApiError.createChatRomm.success) {
    //   //채팅방 개설 완료
    // } else if (code == ApiError.createChatRomm.requiredUserId) {
    //   //상대방 ID 필수
    // } else if (code == ApiError.createChatRomm.cannotMySelf) {
    //   //자기 자신
    // } else if (code == ApiError.createChatRomm.notFound) {
    //   //상대방 없음
    // } else if (code == ApiError.createChatRomm.onlyCnChatbot) {
    //   //오직 챗봇만 가능
    // } else if (code == ApiError.createChatRomm.alreadyRoom) {
    //   //이미 있음
    // }
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
                Text(
                  "유저 목록 (${searchedList.length})",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
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
              : Expanded(
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
                        userData: user,
                        onTap: () => _onCreateRoom(user),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
