import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String name;
  Function()? ontap;
  UserTile({super.key, required this.name, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: ontap,
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(
                width: 50,
              ),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
