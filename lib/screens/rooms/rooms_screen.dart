import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.chattingRooms,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Text("채팅",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.circlePlus,
                size: 20,
              ))
        ],
      ),
      child: const Placeholder(),
    );
  }
}
