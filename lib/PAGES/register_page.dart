import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/mybutton.dart';
import 'package:mitch_chatapp/Components/mytextfeild.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({required this.ontap});
  final void Function()? ontap;
  void register(BuildContext context) async {
    final _auth = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await _auth.signUpWithEmailAndPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Passwords doesn't match.Please try again"),
              ));
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            "Let's create an account for you",
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
          Mytextfeild(
            textEditingController: _confirmPasswordController,
            isObsecure: true,
            hintText: "Confirm Password",
          ),
          Mybutton(title: "REGISTER", ontap: () => register(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already a member? "),
              TextButton(
                onPressed: ontap,
                child: Text(
                  "Login NOW",
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
