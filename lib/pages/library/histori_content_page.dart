import 'package:flutter/material.dart';

class HistroriContentPage extends StatelessWidget {
  const HistroriContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SingleChildScrollView(
        child: Center(
          child: Text('Histori Content'),
        ),
      ),
    );
  }
}
