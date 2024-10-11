import 'package:daelim/helpers/StorageHelper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_screen.dart';
import 'package:daelim/screens/main/main_screen.dart';
import 'package:daelim/screens/setting/setting_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppScreen.login.toPath,
  //리다이렉트 관련 중간고사 문제 몇개 있음. 리다이렉트까지 시험범위
  redirect: (context, state) {
    if (state.fullPath == AppScreen.login.toPath) {
      return null;
    }
    if (StorageHelper.authData == null) {
      return AppScreen.login.toPath;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppScreen.login.toPath,
      name: AppScreen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppScreen.main.toPath,
      name: AppScreen.main.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainScreen(),
      ),
    ),
    GoRoute(
      path: AppScreen.setting.toPath,
      name: AppScreen.setting.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SettingScreen(),
      ),
    )
  ],
);
