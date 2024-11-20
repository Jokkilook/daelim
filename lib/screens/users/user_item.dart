import 'package:daelim/config.dart';
import 'package:daelim/models/user_data.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  UserItem({super.key, required this.userData, this.onTap});

  final UserData userData;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAEAEA),
        foregroundImage:
            NetworkImage(userData.profile_image ?? Config.image.defaultProfile),
      ),
      title: Text(
        userData.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(userData.student_number),
    );
  }
}
