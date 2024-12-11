import 'package:flutter/material.dart';
import 'package:mitch_chatapp/PAGES/login_page.dart';
import 'package:mitch_chatapp/PAGES/register_page.dart';

class LogisterParent extends StatefulWidget {
  const LogisterParent({Key? key}) : super(key: key);

  @override
  State<LogisterParent> createState() => _LogisterParentState();
}

class _LogisterParentState extends State<LogisterParent> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        ontap: togglePage,
      );
    } else {
      return RegisterPage(
        ontap: togglePage,
      );
    }
  }
}
