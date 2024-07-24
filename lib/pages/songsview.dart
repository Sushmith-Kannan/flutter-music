import 'package:flutter/material.dart';
import 'package:try_app/api/service_provider.dart'; // Import the MusicPlayerPage
import 'package:try_app/pages/musicplayer.dart';
import 'track.dart';

class SongsScreen extends StatefulWidget {
  final String? artist;
  final String? album;
  final String? genre;

  SongsScreen({this.artist, this.album, this.genre});

  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Track>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    if (widget.artist != null) {
      _tracksFuture = _apiService.fetchSongsByArtist(widget.artist!);
    } else if (widget.album != null) {
      _tracksFuture = _apiService.fetchSongsByAlbum(widget.album!);
    } else if (widget.genre != null) {
      _tracksFuture = _apiService.fetchSongsByGenre(widget.genre!);
    } else {
      throw Exception('Either artist, album, or genre must be provided');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.artist ?? widget.album ?? widget.genre ?? 'Songs',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'No songs found',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ));
          } else {
            final tracks = snapshot.data!;
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  title: Text(
                    track.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  subtitle: Text(
                    track.artist,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerPage(
                          tracks: tracks,
                          initialIndex: index,
                          onStop: () {
                            // Handle any cleanup if needed
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
