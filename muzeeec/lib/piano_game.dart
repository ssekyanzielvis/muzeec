import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class PianoGame extends StatefulWidget {
  const PianoGame({Key? key}) : super(key: key);

  @override
  State<PianoGame> createState() => _PianoGameState();
}

class _PianoGameState extends State<PianoGame> {
  // White keys
  final List<String> notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];

  // Black keys
  final List<String> additionalNotes = [
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q'
  ];

  // Additional bottom bar keys
  final List<String> bottomBarNotes = ['R', 'S', 'T', 'U', 'V', 'W', 'X'];

  // Combined keys (initialized directly to avoid late initialization error)
  late final List<String> allKeys = [
    ...notes,
    ...additionalNotes,
    ...bottomBarNotes,
    ...notes,
    ...additionalNotes,
    ...bottomBarNotes,
    ...notes,
    ...additionalNotes,
    ...bottomBarNotes,
    ...notes,
    ...additionalNotes,
    ...bottomBarNotes,
  ];

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playSound(String note) async {
    try {
      await audioPlayer.setSource(AssetSource('sounds/$note.mp3'));
      await audioPlayer.resume();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Widget buildPianoButton(String note, Color color) {
    return GestureDetector(
      onTap: () => playSound(note),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            note,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color == Colors.black ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('🎵 Piano'),
        backgroundColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeData.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 8 keys per row
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1, // Square keys
            ),
            itemCount: allKeys.length, // Total keys count
            itemBuilder: (context, index) {
              // Alternate colors for keys
              final color = index % 2 == 0 ? Colors.white : Colors.black;
              return buildPianoButton(allKeys[index], color);
            },
          ),
        ),
      ),
    );
  }
}
