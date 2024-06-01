import 'package:hive_flutter/hive_flutter.dart';
part 'movies.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  String? releaseDate;
  String? thumb;
  String? type;

  Movie({
    required this.id,
    required this.title,
    this.thumb,
    this.releaseDate,
    this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'],
      title: json['Title'],
      thumb: json['Poster'],
      releaseDate: json['Year'],
      type: json['Type'],
    );
  }
}

class MovieInfo {
  final String id;
  final String title;
  final String cover;
  final String description;
  final String releaseDate;
  final String duration;
  final String genres;
  final String casts;
  final String director;
  final String writer;
  final String ratings;

  MovieInfo({
    required this.id,
    required this.title,
    required this.cover,
    required this.description,
    required this.releaseDate,
    required this.duration,
    required this.genres,
    required this.casts,
    required this.director,
    required this.writer,
    required this.ratings,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      id: json['imdbID'],
      title: json['Title'],
      cover: json['Poster'],
      description: json['Plot'],
      releaseDate: json['Year'],
      duration: json['Runtime'],
      genres: json['Genre'],
      casts: json['Actors'],
      director: json['Director'],
      writer: json['Writer'],
      ratings: json['imdbRating'],
    );
  }
}

class ServerData {
  final String name;
  final String? stream;
  final Map<String, String> links;
  final String subtitle;

  ServerData(
    this.name,
    this.stream,
    this.links,
    this.subtitle,
  );
}

class NewAdded {
  final String title;
  final String imdbId;
  final String type;
  final String releaseDate;

  NewAdded({
    required this.title,
    required this.imdbId,
    required this.type,
    required this.releaseDate,
  });
}