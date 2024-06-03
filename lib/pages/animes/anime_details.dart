import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamsavor/pages/video_player.dart';
import 'package:streamsavor/repository/anime_repository.dart';
import 'package:streamsavor/services/animes.dart';

class AnimeDetails extends StatefulWidget {
  final String id;
  final String name;
  final String poster;
  const AnimeDetails({
    super.key,
    required this.id,
    required this.name,
    required this.poster,
  });

  @override
  _AnimeDetailsState createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> {
  int _currentPage = 0;
  final int _itemsPerPage = 24;

  late Box<AnimeCards> favoritesBox;
  Set<AnimeCards> favAnimes = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoritesBox = Hive.box('anime-fav');
    setState(() {
      favAnimes = favoritesBox.values.toSet();
    });
  }

  Future<void> _saveFavorites() async {
    await favoritesBox.putAll(
      Map.fromEntries(
        favAnimes.map(
          (anime) => MapEntry(
            anime.id,
            anime,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // if (Hive.isBoxOpen('anime-fav')) {
    //   print('The anime-fav box is open');
    //   favoritesBox.close();
    //   favoritesBox.deleteFromDisk();
    //   print("Box deleted");
    // } else {
    //   print('The anime-fav box is not open');
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              favAnimes.any((anime) => anime.id == widget.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              if (favAnimes.any((anime) => anime.id == widget.id)) {
                favAnimes.removeWhere((anime) => anime.id == widget.id);
              } else {
                favAnimes.add(
                  AnimeCards(
                      id: widget.id, name: widget.name, poster: widget.poster),
                );
              }
              _saveFavorites();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Added to Favorites ❤️',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<AnimeInfo>(
          future: fetchAnime(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final animeData = snapshot.data!;
              final totalPages =
                  (animeData.episodes.length / _itemsPerPage).ceil();

              return Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: animeData.poster,
                          height: size.height * 0.275,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                animeData.name,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 247, 202, 255),
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Aired: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.aired!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nPremiered: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.premiered!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nJapanese: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.japanese!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nDuration: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.duration,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nRating: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.rating,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nStatus: ',
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: animeData.status!,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    // const TextSpan(
                                    //   text: '\nSubbed: ',
                                    //   style: TextStyle(
                                    //     color: Colors.purple,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontFamily: 'Poppins',
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                    // TextSpan(
                                    //   text: animeData.sub.toString(),
                                    //   style: const TextStyle(
                                    //     fontFamily: 'Poppins',
                                    //   ),
                                    // ),
                                    // const TextSpan(
                                    //   text: '\nDubbed: ',
                                    //   style: TextStyle(
                                    //     color: Colors.purple,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontFamily: 'Poppins',
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                    // TextSpan(
                                    //   text: animeData.dub.toString(),
                                    //   style: const TextStyle(
                                    //     fontFamily: 'Poppins',
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      animeData.description,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 247, 202, 255),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Episodes',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                            textAlign: TextAlign.left,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton<int>(
                                dropdownColor:
                                    const Color.fromARGB(186, 78, 47, 83),
                                value: _currentPage,
                                items: List.generate(totalPages, (index) {
                                  return DropdownMenuItem(
                                    value: index,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 247, 202, 255),
                                      ),
                                    ),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    _currentPage = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (_currentPage + 1) * _itemsPerPage >
                              animeData.episodes.length
                          ? animeData.episodes.length -
                              _currentPage * _itemsPerPage
                          : _itemsPerPage,
                      itemBuilder: (context, index) {
                        final itemIndex = _currentPage * _itemsPerPage + index;
                        final items = animeData.episodes[itemIndex];
                        return Container(
                          height: size.height * 0.18,
                          width: double.infinity,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(186, 78, 47, 83),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: animeData.poster,
                                width: size.width * 0.2,
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () async {
                                    final streamingLinks =
                                        await fetchStreamingLinks(
                                            items.episodeId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DefaultPlayer(
                                          videoUrl:
                                              streamingLinks.streamingLink,
                                          subUrl: streamingLinks.subUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'Episode: ${items.number}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 235, 119, 255),
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        items.title,
                                        softWrap: true,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 235, 119, 255),
                                            fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          (animeData.dub != null &&
                                                  items.number <= animeData.dub!
                                              ? 'Dub'
                                              : 'Sub'),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 247, 202, 255),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

            return Text(
              'Unable to Fetch Data!!',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
