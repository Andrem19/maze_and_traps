import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.iconData,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(iconData),
            hintText: hintText),
      ),
    );
  }
}