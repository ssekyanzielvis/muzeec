import 'package:flutter/material.dart';
import 'piano_game.dart';
import 'music_player.dart';
import 'music_recorder.dart';
import 'mixer.dart';

class MusicCards extends StatelessWidget {
  const MusicCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💿💿💿💿💿💿💿💿💿💿💿💿💿💿💿💿💿'),
        backgroundColor:
            Colors.blue[900]?.withOpacity(0.7), // Dark blue with 70% opacity
        elevation: 0, // Remove shadow
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrrGuIZqag59HO-ZH2ZJeDWJr_ZfxMFRmNfA&s', // Replace with your network image URL
                ),
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0), // Add padding to the body
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 3
                        : 2, // Responsive grid
                    crossAxisSpacing: 16, // Spacing between columns
                    mainAxisSpacing: 16, // Spacing between rows
                    childAspectRatio: 1, // Make cards square
                    children: <Widget>[
                      _buildCard(
                        context,
                        'Piano',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREZLIwsFjF_PagR79JEHOGLkZ2Ya6GzZlRmQ&s',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PianoGame()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'Music',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiIEDnmMBjbm5pooPQsawPe2pjkhp4MZtVKw&s',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayer()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'Record Music',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ41MmCqNDGxp67Lbe1XdfyQoqvzLn0fqd4qA&s',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicRecorder()),
                          );
                        },
                      ),
                      _buildCard(
                        context,
                        'Mix Music',
                        'https://cdn.prod.website-files.com/60a0ade9a9e15bdd6b98f68b/612182583f212f05d5d15f72_how%20to%20remix%20a%20song.jpg',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Mixer()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String cardName, String imageUrl,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Card name outside the card
          Text(
            cardName,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600
                  ? 24
                  : 18, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ensure text is visible on the background
            ),
          ),
          const SizedBox(height: 8), // Spacing between name and card
          // Card with image
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias, // Ensure the image doesn't overflow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // Cover the entire card
              ),
            ),
          ),
        ],
      ),
    );
  }
}
