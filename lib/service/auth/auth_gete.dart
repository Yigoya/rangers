import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rangers/homepage.dart';
import 'package:rangers/main.dart';
import 'package:rangers/service/auth/login_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHome();
          } else {
            return const LoginRegister();
          }
        },
      ),
    );
  }
}
