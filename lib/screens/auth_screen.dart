import 'package:canteen_app/screens/screens.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(
            onClickRegister: toggle,
          )
        : RegisterScreen(
            onClickLogin: toggle,
          );
  }

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
