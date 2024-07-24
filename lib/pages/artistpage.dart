import 'package:flutter/material.dart';
import 'package:try_app/api/service_provider.dart';
import 'package:try_app/pages/songsview.dart';

class ArtistsScreen extends StatefulWidget {
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, List<String>?>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, List<String>?>> _fetchData() async {
    try {
      final artists = await _apiService.fetchArtists();
      final albums = await _apiService.fetchAlbums();
      final genres = await _apiService.fetchGenres();
      return {
        'artists': artists,
        'albums': albums,
        'genres': genres,
      };
    } catch (error) {
      return {
        'artists': null,
        'albums': null,
        'genres': null,
      };
    }
  }

  Widget _buildCategory(
      String title, List<String>? items, void Function(String) onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items?.map((item) {
                    // Replace with your local image asset path
                    String imagePath;
                    if (title == 'Artists') {
                      imagePath = 'lib/assets/tharkuri.jpeg';
                    } else if (title == 'Albums') {
                      imagePath = 'lib/assets/tharkuri.jpeg';
                    } else {
                      imagePath = 'lib/assets/tharkuri.jpeg';
                    }

                    return GestureDetector(
                      onTap: () => onTap(item),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Container(
                          width: 150,
                          height: 150,
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .black54, // Background color for readability
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, List<String>?>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
                child: Text('Error: ${snapshot.error ?? 'No data found'}'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                child: Column(
                  children: [
                    _buildCategory('Artists', data['artists'], (artist) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongsScreen(artist: artist),
                        ),
                      );
                    }),
                    _buildCategory('Albums', data['albums'], (album) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongsScreen(album: album),
                        ),
                      );
                    }),
                    _buildCategory('Genres', data['genres'], (genre) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongsScreen(genre: genre),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
