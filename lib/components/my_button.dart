import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap; // Mengubah tipe fungsi onTap menjadi nullable

  const MyButton({
    super.key, // Menambahkan Key? key yang sesuai dengan konvensi
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.9,
          child: ElevatedButton(
            onPressed: onTap, // Menggunakan onTap langsung tanpa perlu ()
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange, // Atur warna latar belakang
            ),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
