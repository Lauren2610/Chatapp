import 'package:flutter/material.dart';

class Mytextfeild extends StatelessWidget {
  final String hintText;
  final bool isObsecure;
  FocusNode? focusNode;
  final TextEditingController textEditingController;
  Mytextfeild(
      {super.key,
      this.focusNode,
      required this.hintText,
      required this.isObsecure,
      required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        focusNode: focusNode,
        controller: textEditingController,
        obscureText: isObsecure,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
