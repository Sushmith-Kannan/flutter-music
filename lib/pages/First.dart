import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:try_app/components/my_drawer.dart';
import 'dart:convert';

import 'musicplayer.dart';
import 'track.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  List<Track> _tracks = [];
  bool _isPlaying = false;
  bool _isExpanded = false;
  Track? _currentTrack;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:3000/tracks'));

    if (response.statusCode == 200) {
      final List<dynamic> trackJson = json.decode(response.body);
      setState(() {
        _tracks = trackJson.map((json) => Track.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  void _startPlaying(Track track) {
    setState(() {
      _currentTrack = track;
      _isPlaying = true;
      _isExpanded = true; // Expand bottom bar
    });
  }

  void _stopPlaying() {
    setState(() {
      _isPlaying = false;
      _isExpanded = false; // Collapse bottom bar when stopped
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Music Player',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
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
                    _startPlaying(track);
                  },
                );
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded ? 64.0 : 0.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                if (_currentTrack != null) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: MusicPlayerPage(
                          tracks: _tracks,
                          initialIndex: _tracks.indexOf(_currentTrack!),
                          onStop: _stopPlaying,
                        ),
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _currentTrack != null
                    ? [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentTrack!.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_currentTrack!.artist),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_up),
                      ]
                    : [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
