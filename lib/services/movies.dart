import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamsavor/repository/movies.dart';

// Urls have been removed to prevent API misuse, since usage is limited [unless you choose to sponsor this project...]
Future<List<Movie>> searchMovies(String search) async {
  final res = await http.get(
    Uri.parse(''),
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
    Uri.parse(''),
  );

  final data = jsonDecode(res.body);
  final movieInfo = MovieInfo.fromJson(data);

  return movieInfo;
}

Future<ServerData> listServers(String id) async {
  final url = Uri.parse('');
  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
    final body = jsonDecode(response.body);
    final sources = body['sources'] as List;
    final serverData = sources.firstWhere(
        (source) => source['name'] == 'Vidplay',
        orElse: () => null);
    if (serverData == null) throw Exception('No server data found');
    final name = serverData['name'] as String;
    final data = serverData['data'] as Map<String, dynamic>;
    final stream = data['stream'] as String?;
    String subtitle = 'none';
    if (data['subtitle'].length != 0) {
      final subtitleData = (data['subtitle'] as List).firstWhere(
        (subtitle) => subtitle['lang'] == 'English',
        orElse: () => 'none',
      );
      subtitle = subtitleData['file'];
    }
    final map = await listStreams(stream!);
    return ServerData(name, stream, map, subtitle);
  } catch (e) {
    rethrow;
  }
}

Future<Map<String, String>> listStreams(String streamUrl) async {
  Map<String, String> streams = {};
  final res = await http.get(Uri.parse(streamUrl));
  final data = res.body.split('\n');

  try {
    for (int i = 0; i < data.length - 1; i++) {
      if (i % 2 != 0) {
        final key = data[i].split('=').last;
        final value = data[i + 1];
        streams[key] = value;
      }
    }
    return streams;
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<dynamic>> newData(String endpoint) async {
  List<dynamic> dataList = [];

  for (int i = 1; i < 6; i++) {
    final response =
        await http.get(Uri.parse(''));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final movies = jsonData['result']['items'];
      final data = movies.map((movie) {
        String temp = movie['title'];
        String title = temp.split('(')[0];
        String releaseDate = temp.split('(')[1].replaceAll(')', '');
        final imdbId = movie['imdb_id'] as String;
        final type = movie['type'] as String;
        return NewAdded(
            title: title, imdbId: imdbId, type: type, releaseDate: releaseDate);
      }).toList();
      dataList.addAll(data);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
  return dataList;
}

Future<String?> posterUrl(String imdbID) async {
  final res = await http
      .get(Uri.parse(''));
  final details = jsonDecode(res.body);
  if (details['Response'] == 'True') {
    return details['Poster'];
  }
  return null;
}
