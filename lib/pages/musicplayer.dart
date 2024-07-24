import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:try_app/pages/searchpage.dart';
import 'track.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<Track> tracks;
  final int initialIndex;
  final VoidCallback onStop;

  const MusicPlayerPage({
    Key? key,
    required this.tracks,
    required this.initialIndex,
    required this.onStop,
  }) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with AutomaticKeepAliveClientMixin<MusicPlayerPage> {
  late AudioPlayer _player;
  late int _currentIndex;
  bool _isPlaying = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _initPlayer();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _nextTrack();
      }
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  Future<void> _initPlayer() async {
    try {
      final track = widget.tracks[_currentIndex];
      final url = 'http://192.168.137.1:3000${track.src}';
      print('Initializing player with URL: $url'); // Log the URL
      await _player.setUrl(url);
      await _player.load();
      if (!_isPlaying) {
        _player.play();
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    widget.onStop();
    super.dispose();
  }

  void _playPause() {
    setState(() {
      if (_isPlaying) {
        _player.pause();
        _isPlaying = false;
      } else {
        _player.play();
        _isPlaying = true;
      }
    });
  }

  Future<void> _nextTrack() async {
    if (_currentIndex < widget.tracks.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _currentIndex = 0;
      });
    }
    await _player.stop();
    await _initPlayer();
  }

  Future<void> _previousTrack() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    } else {
      setState(() {
        _currentIndex = widget.tracks.length - 1;
      });
    }
    await _player.stop();
    await _initPlayer();
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first;
  }

  void _onTrackSelected(Track track) {
    final index = widget.tracks.indexWhere((t) => t.id == track.id);
    if (index != -1) {
      setState(() {
        _currentIndex = index;
      });
      _initPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final track = widget.tracks[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(track.title),
        actions: [
          IconButton(
            icon: Icon(Icons.minimize),
            onPressed: () {
              Navigator.of(context).pop();
              _showMinimizedPlayer();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    track.artist,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return Column(
                        children: [
                          Text(_formatDuration(position)),
                          Slider(
                            value: position.inSeconds.toDouble(),
                            min: 0.0,
                            max: _player.duration?.inSeconds.toDouble() ?? 0.0,
                            onChanged: (value) {
                              _player.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Text(_formatDuration(
                              _player.duration ?? Duration.zero)),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: _previousTrack,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _playPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: _nextTrack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMinimizedPlayer() {
    // Implement minimized player view here
  }
}
