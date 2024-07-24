import 'package:flutter/material.dart';
import 'package:try_app/api/service_provider.dart';
import 'package:try_app/pages/track.dart';

class SearchPage extends StatefulWidget {
  final List<Track> initialTracks;
  final Function(Track) onTrackSelected;

  SearchPage({required this.initialTracks, required this.onTrackSelected});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Track> _searchResults = [];
  String _errorMessage = '';

  void _searchTracks() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = '';
      });
      return;
    }
    try {
      final results = await _apiService.searchTracks(query);
      setState(() {
        _searchResults = results;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching tracks: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Search Tracks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by title or artist',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchTracks,
                ),
              ),
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _searchResults = [];
                    _errorMessage = '';
                  });
                }
              },
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final track = _searchResults[index];
                return ListTile(
                  title: Text(track.title),
                  subtitle: Text(track.artist),
                  onTap: () {
                    widget.onTrackSelected(track);
                    _searchController.clear(); // Clear the search field
                    Navigator.of(context).pop(); // Close the search page
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
