import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_screen.dart';
import 'package:daelim/screens/main/main_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppScreen.login.toPath,
  routes: [
    GoRoute(
      path: AppScreen.login.toPath,
      name: AppScreen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppScreen.main.toPath,
      name: AppScreen.main.name,
      builder: (context, state) => const MainScreen(),
    ),
  ],
);
