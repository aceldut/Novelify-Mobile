import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final double? fontSize; // Tambahkan nullable untuk fontSize

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize:
                fontSize ?? 14), // Gunakan fontSize dengan penanganan nullable
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        ),
      ),
      cursorColor: Colors.black,
      style: TextStyle(
          fontSize:
              fontSize ?? 14), // Gunakan fontSize dengan penanganan nullable
    );
  }
}
