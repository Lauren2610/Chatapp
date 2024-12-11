import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/mybutton.dart';
import 'package:mitch_chatapp/Components/mytextfeild.dart';

class LoginPage extends StatelessWidget {
  LoginPage({required this.ontap});
  final void Function()? ontap;
  void login(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Welcome back! You've been missed.",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 16),
          ),
          Mytextfeild(
            textEditingController: _emailController,
            isObsecure: false,
            hintText: "Email",
          ),
          Mytextfeild(
            textEditingController: _passwordController,
            isObsecure: true,
            hintText: "Password",
          ),
          Mybutton(
            title: "LOGIN",
            ontap: () => login(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member? "),
              TextButton(
                onPressed: ontap,
                child: Text(
                  "Register NOW",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
