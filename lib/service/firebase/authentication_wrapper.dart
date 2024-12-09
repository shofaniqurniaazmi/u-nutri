import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutritrack/presentation/pages/login_screen.dart';
import 'package:nutritrack/presentation/pages/user_clasification.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              //jika berhasil maka akan diarahka ke halaman user classfication
              return const UserClassificationScreen();
            } else {
              //jika gagal maka akan diarahkan ke halaman HomePage
              //return HomePage();
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
