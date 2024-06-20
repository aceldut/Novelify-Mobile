import 'package:flutter/material.dart';

// ThemeData untuk mode terang aplikasi
ThemeData lightMode = ThemeData(
  // Mode kecerahan tema terang
  brightness: Brightness.light,

  // Skema warna untuk mode terang
  colorScheme: ColorScheme.light(
    // Warna permukaan aplikasi
    surface: Colors.grey.shade300,

    // Warna utama aplikasi
    primary: Colors.grey.shade200,

    // Warna sekunder aplikasi
    secondary: Colors.grey.shade400,

    // Warna teks kontras pada latar belakang permukaan
    onSurface: Colors.black,
  ),

  // Konfigurasi teks tema
  textTheme: ThemeData.light().textTheme.apply(
        // Warna tubuh teks umum
        bodyColor: Colors.black,
      ),
);
