
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutritrack/presentation/pages/archive.dart';
import 'package:nutritrack/presentation/pages/calender.dart';
import 'package:nutritrack/presentation/pages/forget_screen.dart';
import 'package:nutritrack/presentation/pages/home.dart';
import 'package:nutritrack/presentation/pages/kamera.dart';
import 'package:nutritrack/presentation/pages/login_screen.dart';
import 'package:nutritrack/presentation/pages/onboard.dart';
import 'package:nutritrack/presentation/pages/profile.dart';
import 'package:nutritrack/presentation/pages/sign_up_screen.dart';
import 'package:nutritrack/presentation/pages/splash_screen.dart';
import 'package:nutritrack/presentation/pages/user_clasification.dart';
import 'package:nutritrack/presentation/pages/user_clasification2.dart';
import 'package:nutritrack/presentation/widget/bottom_bar.dart';
import 'package:nutritrack/service/provider/news_provider.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/onboard',
      builder: (BuildContext context, GoRouterState state) {
        return Onboard();
      },
    ),
    GoRoute(
      path: '/get-started',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (BuildContext context, GoRouterState state) {
        return const Signup();
      },
    ),
    GoRoute(
      path: '/forget-password',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/user-clasification',
      builder: (BuildContext context, GoRouterState state) {
        return const UserClassificationScreen();
      },
    ),
    GoRoute(
      path: '/user-clasification2',
      builder: (BuildContext context, GoRouterState state) {
        return UserClassificationNext();
      },
    ),
    // satu kesatuan home, archive, calender dan profile seharusnya menggunakan shell route
    ShellRoute(
      navigatorKey: GlobalKey<
          NavigatorState>(), // Optional: navigator for nested navigation
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return NavigationMenu(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: '/calendar',
          builder: (BuildContext context, GoRouterState state) {
            return const Calendar();
          },
        ),
        GoRoute(
          path: '/camera',
          builder: (BuildContext context, GoRouterState state) {
            return Camera();
          },
        ),
        GoRoute(
          path: '/archive',
          builder: (BuildContext context, GoRouterState state) {
            return Archive();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return Profile();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
