class Track {
  final String id;
  final String title;
  final String artist;
  final String src;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.src,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      src: json['src'] ?? '',
    );
  }
}
