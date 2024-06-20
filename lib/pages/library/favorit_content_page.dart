import 'package:flutter/material.dart';

class FavoritContentPage extends StatelessWidget {
  const FavoritContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SingleChildScrollView(
        child: Center(
          child: Text('Favorit Content'),
        ),
      ),
    );
  }
}
