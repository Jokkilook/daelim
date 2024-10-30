import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.name,
    required this.stNum,
    required this.ImageUrl,
  });

  final String name;
  final String stNum;
  final String ImageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAEAEA),
        foregroundImage: NetworkImage(ImageUrl),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(stNum),
    );
  }
}
