import 'package:flutter/material.dart';
import 'card.dart'; // Assuming the file containing MusicCards is named music_cards.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: MusicCards(),
    );
  }
}
