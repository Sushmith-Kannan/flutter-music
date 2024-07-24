import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:try_app/pages/track.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.137.1:3000'; // Updated IP address

  Future<List<String>> fetchArtists() async {
    final response = await http.get(Uri.parse('$baseUrl/artists'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      print('Failed to load artists with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load artists');
    }
  }

  Future<List<String>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      print('Failed to load albums with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load albums');
    }
  }

  Future<List<String>> fetchGenres() async {
    final response = await http.get(Uri.parse('$baseUrl/genres'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      print('Failed to load albums with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Track>> fetchSongsByArtist(String artistName) async {
    final encodedArtist = Uri.encodeComponent(artistName);
    final response =
        await http.get(Uri.parse('$baseUrl/artists/$encodedArtist'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      print(
          'Failed to load songs for artist $artistName with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Track>> fetchSongsByAlbum(String albumName) async {
    final encodedAlbum = Uri.encodeComponent(albumName);
    final response = await http.get(Uri.parse('$baseUrl/albums/$encodedAlbum'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      print(
          'Failed to load songs for album $albumName with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Track>> fetchSongsByGenre(String genreName) async {
    final encodedGenre = Uri.encodeComponent(genreName);
    final response = await http.get(Uri.parse('$baseUrl/genres/$encodedGenre'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      print(
          'Failed to load songs for album $genreName with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Track>> searchTracks(String query) async {
    final response = await http.get(
        Uri.parse('$baseUrl/tracks/search?q=${Uri.encodeComponent(query)}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Track.fromJson(json)).toList();
    } else {
      print('Failed to search tracks with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to search tracks');
    }
  }
}
