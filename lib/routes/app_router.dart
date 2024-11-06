import 'package:daelim/helpers/storage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_screen.dart';
import 'package:daelim/screens/users/users_screen.dart';
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
      //리턴하는 주소로 이동 ( null 이면 그대로 )
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
      path: AppScreen.users.toPath,
      name: AppScreen.users.name,
      //페이지빌더 - NoTransitionPage 쓰면 화면 전환 효과가 없이 이동함
      pageBuilder: (context, state) => const NoTransitionPage(
        child: UsersScreen(),
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
