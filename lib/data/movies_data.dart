import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamsavor/repository/movies.dart';

// Urls have been removed to prevent API misuse, since usage is limited [unless you choose to sponsor this project...]
Future<List<Movie>> searchMovies(String search) async {
  final res = await http.get(
    Uri.parse(
        ''),
  );

  final data = jsonDecode(res.body);
  final movies = <Movie>[];
  for (final movie in data['Search']) {
    movies.add(Movie.fromJson(movie));
  }
  return movies;
}

Future<MovieInfo> moviesInfo(String id) async {
  final res = await http.get(
    Uri.parse(
        ''),
  );
  
  final data = jsonDecode(res.body);
  final movieInfo = MovieInfo.fromJson(data);

  return movieInfo;
}

Future<List<ServerData>> listServers(String id) async {
  final url = Uri.parse('');
  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    final sources = data['sources'] as List;
    final serverDataList = sources.map((source) {
      final name = source['name'] as String;
      final data = source['data'] as Map<String, dynamic>;
      final stream = data['stream'] as String?;
      final subtitleData = (data['subtitle'] as List).firstWhere(
        (subtitle) => subtitle['lang'] == 'English',
        orElse: () => null,
      );
      final subtitle = subtitleData?['file'];
      return ServerData(name, stream, subtitle);
    }).toList();
    return serverDataList;
  } catch (e) {
    return [];
  }
}

Future<List<dynamic>> newData(String endpoint) async {
  String releaseDate = '';
  String title = '';
  String temp = '';
  final response =
      await http.get(Uri.parse(''));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final movies = jsonData['result']['items'];
    final data = movies.map((movie) {
      temp = movie['title'];
      title = temp.split('(')[0];
      releaseDate = temp.split('(')[1].replaceAll(')', '');
      final imdbId = movie['imdb_id'] as String;
      final type = movie['type'] as String;
      return NewAdded(
          title: title, imdbId: imdbId, type: type, releaseDate: releaseDate);
    }).toList();

    return data;
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<String> posterUrl(String imdbID) async {
  final res = await http
      .get(Uri.parse(''));
  final details = jsonDecode(res.body);
  if (details['Response'] == 'True') {
    return details['Poster'];
  }
  return '';
}