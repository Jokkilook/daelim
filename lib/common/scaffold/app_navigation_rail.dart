import 'package:daelim/extensions/context_extension.dart';
import 'package:daelim/helpers/api_helper.dart';
import 'package:daelim/routes/app_router.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppNavigationRail extends StatelessWidget {
  final AppScreen appScreen;

  const AppNavigationRail({
    super.key,
    required this.appScreen,
  });

  @override
  Widget build(BuildContext context) {
    //앱 라우터에 추가하면 자동으로 레일에 추가됨.
    final screens = List<AppScreen>.from(AppScreen.values);
    //앱 레일에 없앨 것 삭제.
    screens.removeRange(0, 2);

    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            onDestinationSelected: (value) {
              final screen = screens[value];
              appRouter.pushNamed(screen.name);
            },
            destinations: screens.map((e) {
              return NavigationRailDestination(
                icon: Icon(e.getIcon),
                label: Text(e.name),
              );
            }).toList(),
            selectedIndex: appScreen.index - 1,
          ),
        ),
        10.heightBox,
        IconButton(
          onPressed: () => ApiHelper.signOut(context),
          icon: const Icon(LucideIcons.logOut),
        ),
        10.heightBox
      ],
    );
  }
}
