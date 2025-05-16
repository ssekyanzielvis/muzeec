import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
//import 'dart:io'; // Import for File type

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  int currentIndex = 0;
  bool isPlaying = false;
  bool isRepeat = false;

  @override
  void initState() {
    super.initState();
    requestPermissionAndFetchSongs();
  }

  Future<void> requestPermissionAndFetchSongs() async {
    // Request storage permission
    bool hasPermission = await audioQuery.permissionsStatus();
    if (!hasPermission) {
      await audioQuery.permissionsRequest();
    }

    // Fetch songs
    List<SongModel> fetchedSongs = await audioQuery.querySongs();
    setState(() {
      songs = fetchedSongs;
    });
  }

  void playAudio(int index) async {
    if (songs.isNotEmpty) {
      setState(() {
        currentIndex = index;
        isPlaying = true;
      });
      await audioPlayer.play(DeviceFileSource(songs[index].data));
    }
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void playNext() {
    if (currentIndex < songs.length - 1) {
      playAudio(currentIndex + 1);
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      playAudio(currentIndex - 1);
    }
  }

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
      audioPlayer
          .setReleaseMode(isRepeat ? ReleaseMode.loop : ReleaseMode.release);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        backgroundColor:
            Colors.blue[900]?.withOpacity(0.7), // Make app bar transparent
        elevation: 0, // Remove shadow
      ),
      // Add a background network image
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrrGuIZqag59HO-ZH2ZJeDWJr_ZfxMFRmNfA&s'), // Replace with your image URL
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Column(
          children: [
            // Top Section: Metadata
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QueryArtworkWidget(
                      id: songs.isNotEmpty ? songs[currentIndex].id : 0,
                      type: ArtworkType.AUDIO,
                      artworkHeight: 150,
                      artworkWidth: 150,
                      artworkBorder: BorderRadius.circular(10),
                    ),
                    SizedBox(height: 16),
                    Text(
                      songs.isNotEmpty
                          ? songs[currentIndex].title
                          : 'No Audio Selected',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      songs.isNotEmpty
                          ? songs[currentIndex].artist ?? 'Unknown Artist'
                          : 'Unknown Artist',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // Middle Section: Playback Controls
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        size: 40, color: Colors.white),
                    onPressed: playPrevious,
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50, color: Colors.white),
                    onPressed: togglePlayPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 40, color: Colors.white),
                    onPressed: playNext,
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat,
                        size: 30,
                        color: isRepeat ? Colors.blue : Colors.white70),
                    onPressed: toggleRepeat,
                  ),
                ],
              ),
            ),

            // Bottom Section: List of Audio Files
            Expanded(
              flex: 2,
              child: Container(
                color:
                    Colors.black54, // Semi-transparent background for the list
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(songs[index].title,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(songs[index].artist ?? 'Unknown Artist',
                          style: TextStyle(color: Colors.white70)),
                      onTap: () => playAudio(index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
