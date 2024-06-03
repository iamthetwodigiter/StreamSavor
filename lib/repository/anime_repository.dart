import 'package:hive_flutter/hive_flutter.dart';

part 'anime_repository.g.dart';

@HiveType(typeId: 1)
class AnimeCards {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String poster;

  AnimeCards({
    required this.id,
    required this.name,
    required this.poster,
  });

  factory AnimeCards.fromJson(Map<String, dynamic> json) {
    return AnimeCards(
      id: json['id'],
      name: json['name'],
      poster: json['poster'],
    );
  }
}

class Episode {
  final String title;
  final String episodeId;
  final int number;
  final bool isFiller;

  Episode({
    required this.title,
    required this.episodeId,
    required this.number,
    required this.isFiller,
  });
}

class AnimeInfo {
  final String id;
  final String name;
  final String poster;
  final String description;
  final String rating;
  final String duration;
  final String? japanese;
  final String? aired;
  final String? status;
  final String? premiered;
  final int? sub;
  final int? dub;
  int episodeCount;
  List<Episode> episodes;

  AnimeInfo({
    required this.id,
    required this.name,
    required this.poster,
    required this.description,
    required this.rating,
    required this.duration,
    this.japanese,
    this.aired,
    this.status,
    this.premiered,
    required this.sub,
    required this.dub,
    required this.episodeCount,
    required this.episodes
  });
}

class StreamingLinks {
  final String subUrl;
  final String streamingLink;
  final bool isDub;

  StreamingLinks({
    required this.subUrl,
    required this.streamingLink,
    required this.isDub,
  });
}

class SearchAnime {
  final String id;
  final String name;
  final String poster;
  final String type;

  SearchAnime({
    required this.id,
    required this.name,
    required this.poster,
    required this.type,
  });

  factory SearchAnime.fromJson(Map<String, dynamic> json) {
    return SearchAnime(
      id: json['id'],
      name: json['name'],
      poster: json['poster'],
      type: json['type'],
    );
  }
}