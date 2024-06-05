import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamsavor/repository/anime_repository.dart';

Future<List<AnimeCards>> spotlightAnime(String reqData) async {
  final res = await http.get(
    Uri.parse(''),
  );

  final data = jsonDecode(res.body);
  final animes = <AnimeCards>[];
  for (final anime in data[reqData]) {
    animes.add(AnimeCards.fromJson(anime));
  }
  return animes;
}

Future<AnimeInfo> fetchAnime(String id) async {
  final infoRes = await http.get(
      Uri.parse(''));
  final infoData = jsonDecode(infoRes.body)['anime'];
  final animeInfo = AnimeInfo(
    id: infoData['info']['id'],
    name: infoData['info']['name'],
    poster: infoData['info']['poster'],
    description: infoData['info']['description'],
    rating: infoData['info']['stats']['rating'],
    duration: infoData['info']['stats']['duration'],
    japanese: infoData['moreInfo']['japanese'] == ''
        ? 'N/A'
        : infoData['moreInfo']['japanese'],
    aired: infoData['moreInfo']['aired'],
    status: infoData['moreInfo']['status'],
    premiered: infoData['moreInfo']['premiered'],
    sub: infoData['info']['stats']['episodes']['sub'],
    dub: infoData['info']['stats']['episodes']['dub'],
    episodeCount: 0,
    episodes: [],
  );
  final episodesRes = await http.get(
      Uri.parse(''));
  final episodesData = jsonDecode(episodesRes.body);
  animeInfo.episodeCount = episodesData['totalEpisodes'];
  for (var episode in episodesData['episodes']) {
    animeInfo.episodes.add(
      Episode(
        title: episode['title'],
        episodeId: episode['episodeId'],
        number: episode['number'],
        isFiller: episode['isFiller'],
      ),
    );
  }
  return animeInfo;
}

Future<StreamingLinks> fetchStreamingLinks(String episodeID) async {
  String streamingLink;
  bool isDub = true;
  String subUrl = '';
  final res = await http.get(Uri.parse(
      ''));
  final data = jsonDecode(res.body);
  final res2 = await http.get(Uri.parse(
      ''));
  final data2 = jsonDecode(res2.body);
  if (data2['status'] == 500) {
    streamingLink = data['sources'][0]['url'];
    isDub = false;
  } else {
    streamingLink = data2['sources'][0]['url'];
  }
  for (var x in data['tracks']) {
    if (x['label'] == 'English') {
      subUrl = x['file'];
    }
  }
  final streaming = StreamingLinks(
    subUrl: subUrl,
    streamingLink: streamingLink,
    isDub: isDub,
  );
  return streaming;
}

Future<List<SearchAnime>> searchAnime(String search) async {
  final res = await http.get(Uri.parse(
      ''));
  final data = jsonDecode(res.body);
  final searchResults = <SearchAnime>[];
  for (final search in data['animes']) {
    searchResults.add(SearchAnime.fromJson(search));
  }
  return searchResults;
}
