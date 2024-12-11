import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/PAGES/login_page.dart';
import 'package:mitch_chatapp/PAGES/logister_parent.dart';
import 'package:mitch_chatapp/auth/auth_gate.dart';
import 'package:mitch_chatapp/firebase_options.dart';
import 'package:mitch_chatapp/themes/theme_provider.dart';
import 'package:mitch_chatapp/themes/themesdata.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
    );
  }
}
