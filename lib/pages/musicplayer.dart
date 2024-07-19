import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
  bool _isPlaying = false;
  late int _currentIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final track = widget.tracks[_currentIndex];
      await _player.setUrl('http://192.168.137.1:3000${track.src}');
      await _player.load();
      _player.play();
      _player.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });
    } catch (e) {
      print('Error initializing player: $e');
      // Handle error gracefully, e.g., show a message to the user
    }
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose of resources
    widget.onStop(); // Notify parent to stop playing
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextTrack() async {
    if (_currentIndex < widget.tracks.length - 1) {
      _currentIndex++;
      await _player.stop();
      await _player.setUrl(
          'http://192.168.137.1:3000${widget.tracks[_currentIndex].src}');
      await _player.load();
      _player.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _previousTrack() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _player.stop();
      await _player.setUrl(
          'http://192.168.137.1:3000${widget.tracks[_currentIndex].src}');
      await _player.load();
      _player.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure super.build is called

    final track = widget.tracks[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(track.title),
      ),
      body: Column(
        children: <Widget>[
          Text(track.artist),
          StreamBuilder<Duration?>(
            stream: _player.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  if (position > duration) {
                    position = duration;
                  }
                  return Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _player.seek(Duration(seconds: value.toInt()));
                    },
                  );
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
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
          ),
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return Text(
                '${_formatDuration(position)} / ${_formatDuration(_player.duration ?? Duration.zero)}',
              );
            },
          ),
        ],
      ),
    );
  }
}
